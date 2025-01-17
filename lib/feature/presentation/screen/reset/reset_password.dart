import 'package:apotik_online/core/color/colors.dart';
import 'package:apotik_online/core/validator/validator.dart';
import 'package:apotik_online/core/widget/container.dart';
import 'package:apotik_online/core/widget/text.dart';
import 'package:apotik_online/core/widget/text_field_input.dart';
import 'package:apotik_online/feature/presentation/riverpod/auth_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ResetYourPassword extends ConsumerStatefulWidget {
  const ResetYourPassword({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ResetYourPasswordState();
}

class _ResetYourPasswordState extends ConsumerState<ResetYourPassword> {
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _cpass = TextEditingController();
  final _key = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    _pass.dispose();
    _cpass.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return containerUtils(
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
              height: 32,
            ),
            _sendResetCodeButton(),
          ],
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
            text: "Reset Your Password",
            weight: FontWeight.bold,
            size: 24,
          ),
        ),
        const SizedBox(height: 2),
        textUtils(
          text:
              "Your account password will be changed. Be sure to enter a good and strong password to keep your account secure.",
        ),
      ],
    );
  }

  _form() {
    return Column(
      children: [
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

  _sendResetCodeButton() {
    return InkWell(
      onTap: () async {
        if (_key.currentState!.validate()) {
          await ref.read(authProvider.notifier).resetPassword(
                password: _pass.text,
                passwordconfirmation: _cpass.text,
              );
        }
      },
      child: containerUtils(
        width: double.infinity,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 12),
        borderRadius: 10,
        color: greenCharum,
        child: textUtils(
          text: 'Send Reset Code',
          color: white,
        ),
      ),
    );
  }
}
