import 'package:apotik_online/core/color/colors.dart';
import 'package:apotik_online/core/validator/validator.dart';
import 'package:apotik_online/core/widget/container.dart';
import 'package:apotik_online/core/widget/text.dart';
import 'package:apotik_online/feature/presentation/riverpod/auth_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pinput/pinput.dart';

class VerifyCode extends ConsumerStatefulWidget {
  const VerifyCode({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _VerifyCodeState();
}

class _VerifyCodeState extends ConsumerState<VerifyCode> {
  final TextEditingController _code = TextEditingController();
  final _key = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();
    _code.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

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
            _sendResetCodeButton(size),
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
            text: "Verify Code",
            weight: FontWeight.bold,
            size: 24,
          ),
        ),
        const SizedBox(height: 2),
        textUtils(
          text:
              "We have sent a verification code to your email. Enter the code to continue.",
        ),
      ],
    );
  }

  _form() {
    return Pinput(
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      validator: (e) => Validator.validateCode(e),
      length: 6,
      controller: _code,
      errorPinTheme: PinTheme(
        margin: const EdgeInsets.symmetric(horizontal: 5),
        height: 55,
        width: 40,
        decoration: BoxDecoration(
          color: white,
          border: Border.all(color: red),
          borderRadius: BorderRadius.circular(5),
        ),
      ),
      defaultPinTheme: PinTheme(
        textStyle: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        margin: const EdgeInsets.symmetric(horizontal: 5),
        height: 55,
        width: 40,
        decoration: BoxDecoration(
          color: white,
          border: Border.all(color: grey),
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }

  _sendResetCodeButton(Size size) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: () async {
            if (_key.currentState!.validate()) {
              await ref.read(authProvider.notifier).verifyResetCode(
                    code: _code.text,
                  );
            }
          },
          child: containerUtils(
            width: size.width * .75,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 12),
            borderRadius: 10,
            color: greenCharum,
            child: textUtils(
              text: 'Verify your code',
              color: white,
            ),
          ),
        ),
        InkWell(
          onTap: () async {
            if (_key.currentState!.validate()) {
              await ref.read(authProvider.notifier).sendResetCode(
                    email: '',
                  );
            }
          },
          child: containerUtils(
            child: const CircleAvatar(
              radius: 22,
              child: Icon(
                size: 16,
                Icons.replay,
                color: Colors.black,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
