import 'package:apotik_online/core/color/colors.dart';
import 'package:apotik_online/core/utils/global_utils.dart';
import 'package:apotik_online/core/validator/validator.dart';
import 'package:apotik_online/core/widget/container.dart';
import 'package:apotik_online/core/widget/loading.dart';
import 'package:apotik_online/core/widget/text.dart';
import 'package:apotik_online/core/widget/text_field_input.dart';
import 'package:apotik_online/feature/domain/entity/profile_model.dart';
import 'package:apotik_online/feature/presentation/riverpod/auth_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PasswordChangeScreen extends ConsumerStatefulWidget {
  const PasswordChangeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _PasswordChangeScreenState();
}

class _PasswordChangeScreenState extends ConsumerState<PasswordChangeScreen> {
  final TextEditingController _current = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _cpass = TextEditingController();

  final _key = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    _current.dispose();
    _pass.dispose();
    _cpass.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Consumer(builder: (context, ref, widget) {
        final authWatch = ref.watch(authProvider);
        if (authWatch.state == GlobalState.loading) {
          return const Loading();
        } else {
          return CustomScrollView(
            slivers: [
              SliverFillRemaining(
                hasScrollBody: false,
                child: containerUtils(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  width: double.infinity,
                  child: Form(
                    key: _key,
                    child: Column(
                      children: [
                        _text(),
                        const SizedBox(
                          height: 42,
                        ),
                        _form(),
                        const SizedBox(
                          height: 16,
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        _updatePasswordButton(authWatch),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        }
      }),
    );
  }

  _form() {
    return Column(
      children: [
        TextFieldInput(
          radius: false,
          textEditingController: _current,
          isPass: true,
          hintText: 'Current Password',
          valid: (e) => Validator.validatePassLog(e),
          textInputType: TextInputType.text,
        ),
        const SizedBox(
          height: 24,
        ),
        TextFieldInput(
          valid: (e) => Validator.validatePass(e),
          radius: false,
          textEditingController: _pass,
          isPass: true,
          hintText: 'New Password',
          textInputType: TextInputType.text,
        ),
        const SizedBox(
          height: 24,
        ),
        TextFieldInput(
          valid: (e) => Validator.validatePassReplay(e, _pass.text),
          radius: false,
          textEditingController: _pass,
          isPass: true,
          hintText: 'Confirm New Password',
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
            text: "Update your Password",
            weight: FontWeight.bold,
            size: 24,
          ),
        ),
        const SizedBox(height: 2),
        textUtils(
          text: "Change your password with a strong one",
        ),
      ],
    );
  }

  _updatePasswordButton(AuthProvider authWatch) {
    return InkWell(
      onTap: () async {
        if (_key.currentState!.validate()) {
          await ref
              .read(authProvider.notifier)
              .updatePassword(
                model: PasswordModel(
                  currentpassword: _current.text,
                  password: _pass.text,
                  passwordconfirmation: _cpass.text,
                ),
              )
              .then((_) {
            if (authWatch.state == GlobalState.none &&
                authWatch.message == 'Password updated successfully') {
              if (!mounted) return;
              Navigator.of(context).pop();
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
          text: 'Update Your Password',
          color: white,
        ),
      ),
    );
  }
}

class NameChangeScreen extends ConsumerStatefulWidget {
  const NameChangeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NameChangeScreenState();
}

class _NameChangeScreenState extends ConsumerState<NameChangeScreen> {
  final TextEditingController _name = TextEditingController();

  final _key = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    _name.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, widget) {
        final authWatch = ref.watch(authProvider);
        if (authWatch.state == GlobalState.loading) {
          return const Loading();
        } else {
          return Scaffold(
            appBar: AppBar(),
            body: CustomScrollView(
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
                          _text(),
                          const SizedBox(
                            height: 42,
                          ),
                          _form(),
                          const SizedBox(
                            height: 16,
                          ),
                          const SizedBox(
                            height: 32,
                          ),
                          _updatePasswordButton(authWatch),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  _form() {
    return TextFieldInput(
      radius: false,
      textEditingController: _name,
      isPass: false,
      valid: (e) => Validator.validateNama(e),
      hintText: 'Name',
      textInputType: TextInputType.text,
    );
  }

  _text() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: textUtils(
            text: "Change your Name",
            weight: FontWeight.bold,
            size: 24,
          ),
        ),
        const SizedBox(height: 2),
        textUtils(
          text: "Change your name as you wish",
        ),
      ],
    );
  }

  _updatePasswordButton(AuthProvider authWatch) {
    return InkWell(
      onTap: () async {
        if (_key.currentState!.validate()) {
          await ref
              .read(authProvider.notifier)
              .updateName(name: _name.text)
              .then((_) {
            if (authWatch.state == GlobalState.none &&
                authWatch.message == 'Name updated successfully') {
              if (!mounted) return;
              Navigator.of(context).pop();
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
          text: 'Change Your Name',
          color: white,
        ),
      ),
    );
  }
}
