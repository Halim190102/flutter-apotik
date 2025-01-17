import 'package:apotik_online/core/color/colors.dart';
import 'package:apotik_online/core/validator/validator.dart';
import 'package:apotik_online/core/widget/container.dart';
import 'package:apotik_online/core/widget/text.dart';
import 'package:apotik_online/core/widget/text_field_input.dart';
import 'package:apotik_online/feature/presentation/riverpod/auth_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SendResetCode extends ConsumerStatefulWidget {
  const SendResetCode({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SendResetCodeState();
}

class _SendResetCodeState extends ConsumerState<SendResetCode> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _pass = TextEditingController();
  final _key = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    _email.dispose();
    _pass.dispose();
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
            text: "Enter Your Email",
            weight: FontWeight.bold,
            size: 24,
          ),
        ),
        const SizedBox(height: 2),
        textUtils(
          text:
              "Enter your email address below and we'll send you a code to reset your password.",
        ),
      ],
    );
  }

  _form() {
    return TextFieldInput(
      radius: false,
      textEditingController: _email,
      isPass: false,
      hintText: 'Email',
      valid: (e) => Validator.validateEmail(e),
      textInputType: TextInputType.emailAddress,
    );
  }

  _sendResetCodeButton() {
    return InkWell(
      onTap: () async {
        if (_key.currentState!.validate()) {
          await ref
              .read(authProvider.notifier)
              .sendResetCode(email: _email.text);
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
