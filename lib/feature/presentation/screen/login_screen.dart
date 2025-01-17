import 'dart:convert';

import 'package:apotik_online/core/color/colors.dart';
import 'package:apotik_online/core/utils/global_utils.dart';
import 'package:apotik_online/core/validator/validator.dart';
import 'package:apotik_online/core/widget/container.dart';
import 'package:apotik_online/core/widget/loading.dart';
import 'package:apotik_online/core/widget/text.dart';
import 'package:apotik_online/core/widget/text_field_input.dart';
import 'package:apotik_online/feature/data/datasources/local/token_datasource.dart';
import 'package:apotik_online/feature/domain/entity/auth_model.dart';
import 'package:apotik_online/feature/domain/entity/token_model.dart';
import 'package:apotik_online/feature/presentation/riverpod/auth_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:webview_flutter/webview_flutter.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  final _key = GlobalKey<FormState>();

  late WebViewController _controller;

  @override
  void initState() {
    super.initState();
    // state();
    _controller = WebViewController()
      ..enableZoom(false)
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (String url) async {
            if (url.contains('/callback')) {
              try {
                final jsonContent =
                    await _controller.runJavaScriptReturningResult(
                  "document.body.innerText",
                );
                Map data = jsonDecode(
                  jsonDecode(
                    jsonContent
                        .toString()
                        .replaceAll(r'\\"', '"')
                        .replaceAll(r'\\n', '')
                        .replaceAll(r'\\', ''),
                  ),
                );

                String? accessToken = data['access_token'];
                String? refreshToken = data['refresh_token'];

                if (data.isNotEmpty) {
                  await TokenDataSource.saveToken(TokenModel(
                    accessToken: accessToken,
                    refreshToken: refreshToken,
                  ));

                  if (!mounted) return;

                  Navigator.of(context).pop();
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil('/menu', (route) => false);
                } else {
                  // log("Login failed, token not found.");
                }
              } catch (e) {
                // log('Error parsing JSON: $e');
              }
            }
          },
        ),
      );
  }

  @override
  void dispose() {
    super.dispose();
    _email.dispose();
    _pass.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Consumer(builder: (context, ref, widget) {
      final authWatch = ref.watch(authProvider);

      if (authWatch.state == GlobalState.loading) {
        return const Loading();
      } else {
        return Scaffold(
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: containerUtils(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 12),
                    width: double.infinity,
                    child: Form(
                      key: _key,
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 28,
                          ),
                          _text(),
                          const SizedBox(
                            height: 42,
                          ),
                          _form(),
                          const SizedBox(
                            height: 16,
                          ),
                          _forgotPasswordButton(),
                          const SizedBox(
                            height: 32,
                          ),
                          _loginButton(authWatch),
                          const SizedBox(
                            height: 24,
                          ),
                          textUtils(text: "Or sign log in with"),
                          const SizedBox(
                            height: 24,
                          ),
                          SizedBox(
                            width: 200,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _socialMedia('github', size),
                                // _socialMedia('facebook'),
                                // _socialMedia('twitter'),
                              ],
                            ),
                          ),
                          Flexible(
                            flex: 2,
                            child: Container(),
                          ),
                          _forSignUpButton()
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    });
  }

  _socialMedia(String logo, Size size) {
    return InkWell(
      onTap: () async {
        String url =
            await ref.read(authProvider.notifier).sendSocial(provider: logo);
        if (!mounted) return;
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) => Dialog(
            backgroundColor: white,
            child: containerUtils(
              margin: const EdgeInsets.all(10),
              height: size.height * 0.65,
              width: size.width * 0.9,
              child: url.isNotEmpty
                  ? WebViewWidget(
                      controller: _controller
                        ..loadRequest(
                          Uri.parse(url),
                        ),
                    )
                  : CircularProgressIndicator(
                      color: greenCharum,
                    ),
            ),
          ),
        );
      },
      child: containerUtils(
        height: 42,
        width: 42,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 12),
        borderColor: grey,
        borderRadius: 10,
        color: white,
        child: Image.asset(
          'assets/social-media-logo/$logo.png',
        ),
      ),
    );
  }

  _form() {
    return Column(
      children: [
        TextFieldInput(
          radius: false,
          textEditingController: _email,
          isPass: false,
          hintText: 'Email',
          valid: (e) => Validator.validateEmail(e),
          textInputType: TextInputType.emailAddress,
        ),
        const SizedBox(
          height: 24,
        ),
        TextFieldInput(
          valid: (e) => Validator.validatePassLog(e),
          radius: false,
          textEditingController: _pass,
          isPass: true,
          hintText: 'Password',
          textInputType: TextInputType.text,
        ),
      ],
    );
  }

  _forgotPasswordButton() {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed('/reset');
      },
      child: Align(
        alignment: Alignment.centerRight,
        child: textUtils(
          text: 'Forgot Password ?',
          color: greenCharum,
          weight: FontWeight.bold,
        ),
      ),
    );
  }

  _text() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: textUtils(
            text: "Welcome back!",
            weight: FontWeight.bold,
            size: 24,
          ),
        ),
        const SizedBox(height: 2),
        textUtils(
          text:
              "You’ve been missed. You can sign in first to see any threads you searching for.",
        ),
      ],
    );
  }

  _loginButton(AuthProvider authWatch) {
    return InkWell(
      onTap: () async {
        if (_key.currentState!.validate()) {
          await ref
              .read(authProvider.notifier)
              .login(
                model: LoginModel(
                  email: _email.text,
                  password: _pass.text,
                ),
              )
              .then((_) {
            if (authWatch.state == GlobalState.none &&
                authWatch.message == 'Login successfully') {
              if (!mounted) return;
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/home',
                (route) => false,
              );
            }
            if (authWatch.state == GlobalState.error &&
                authWatch.message == 'Email has not been verified') {
              if (!mounted) return;
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/verify',
                (route) => false,
                arguments: false,
              );
            }
          });
        }
      },
      child: containerUtils(
        width: double.infinity,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 12),
        borderRadius: 10,
        color: greenCharum,
        child: textUtils(
          text: 'Log in',
          color: white,
        ),
      ),
    );
  }

  _forSignUpButton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: textUtils(text: "Don't have an account? "),
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed('/register');
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: textUtils(
              text: "Sign up here.",
              weight: FontWeight.bold,
              color: greenCharum,
            ),
          ),
        )
      ],
    );
  }
}
