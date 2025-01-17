import 'dart:io';

import 'package:apotik_online/core/color/colors.dart';
import 'package:apotik_online/core/image_picker/images.dart';
import 'package:apotik_online/core/utils/global_utils.dart';
import 'package:apotik_online/core/validator/validator.dart';
import 'package:apotik_online/core/widget/container.dart';
import 'package:apotik_online/core/widget/loading.dart';
import 'package:apotik_online/core/widget/text.dart';
import 'package:apotik_online/core/widget/text_field_input.dart';
import 'package:apotik_online/feature/domain/entity/auth_model.dart';
import 'package:apotik_online/feature/presentation/riverpod/auth_riverpod.dart';
import 'package:apotik_online/feature/presentation/riverpod/image_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _cpass = TextEditingController();
  final TextEditingController _name = TextEditingController();

  final _key = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    _email.dispose();
    _pass.dispose();
    _name.dispose();
    _cpass.dispose();
  }

  @override
  void deactivate() {
    ref.invalidate(imageProvider);
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, widget) {
        final authWatch = ref.watch(authProvider);

        if (authWatch.state == GlobalState.loading) {
          return const Loading();
        } else {
          final imageFile = ref.watch(imageProvider);
          return Scaffold(
            body: SafeArea(
              child: CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: containerUtils(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 12,
                      ),
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
                              height: 30,
                            ),
                            _picture(imageFile),
                            if (imageFile != '')
                              TextButton(
                                onPressed: () {
                                  ref.invalidate(imageProvider);
                                },
                                child: textUtils(
                                  text: 'Hapus Foto',
                                ),
                              ),
                            _form(),
                            const SizedBox(
                              height: 32,
                            ),
                            _regisButton(authWatch, imageFile),
                            const SizedBox(
                              height: 24,
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
      },
    );
  }

  _picture(String imageFile) {
    double radius = 60;
    return InkWell(
      onTap: () {
        showSource(context, false);
      },
      child: Stack(
        alignment: Alignment.bottomRight,
        children: [
          CircleAvatar(
            radius: radius,
            backgroundImage:
                imageFile.isNotEmpty ? FileImage(File(imageFile)) : null,
            backgroundColor: imageFile.isNotEmpty ? null : grey,
            child: imageFile.isNotEmpty
                ? null
                : Icon(
                    Icons.person,
                    color: white,
                    size: radius,
                  ),
          ),
          imageFile.isNotEmpty
              ? const SizedBox()
              : Positioned(
                  bottom: 2.5,
                  right: 2.5,
                  child: CircleAvatar(
                    backgroundColor: greenCharum,
                    radius: 12,
                    child: Icon(
                      Icons.add,
                      color: white,
                      size: 16,
                    ),
                  ),
                )
        ],
      ),
    );
  }

  _form() {
    return Column(
      children: [
        const SizedBox(
          height: 24,
        ),
        TextFieldInput(
          radius: false,
          textEditingController: _name,
          isPass: false,
          valid: (e) => Validator.validateNama(e),
          hintText: 'Name',
          textInputType: TextInputType.text,
        ),
        const SizedBox(
          height: 24,
        ),
        TextFieldInput(
          radius: false,
          textEditingController: _email,
          isPass: false,
          valid: (e) => Validator.validateEmail(e),
          hintText: 'Email',
          textInputType: TextInputType.emailAddress,
        ),
        const SizedBox(
          height: 24,
        ),
        TextFieldInput(
          radius: false,
          textEditingController: _pass,
          isPass: true,
          valid: (e) => Validator.validatePass(e),
          hintText: 'Password',
          textInputType: TextInputType.text,
        ),
        const SizedBox(
          height: 24,
        ),
        TextFieldInput(
          radius: false,
          textEditingController: _cpass,
          isPass: true,
          valid: (e) => Validator.validatePassReplay(e, _pass.text),
          hintText: 'Confirm Password',
          textInputType: TextInputType.text,
        ),
      ],
    );
  }

  _text() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: textUtils(
            text: "Create new account",
            weight: FontWeight.bold,
            size: 24,
          ),
        ),
        const SizedBox(height: 2),
        textUtils(
          text: "Let's make a new account.",
        ),
      ],
    );
  }

  _regisButton(AuthProvider authWatch, String imageFile) {
    return InkWell(
      onTap: () async {
        if (_key.currentState!.validate()) {
          await ref
              .read(authProvider.notifier)
              .register(
                model: RegisterModel(
                  profilepict: imageFile,
                  name: _name.text,
                  email: _email.text,
                  password: _pass.text,
                  passwordconfirmation: _cpass.text,
                ),
              )
              .then((_) {
            if (authWatch.state == GlobalState.none) {
              ref.read(imageProvider.notifier).state = '';
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
          text: 'Sign up',
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
          child: textUtils(text: "Have an account? "),
        ),
        GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: textUtils(
              text: "Log in here.",
              weight: FontWeight.bold,
              color: greenCharum,
            ),
          ),
        )
      ],
    );
  }
}
