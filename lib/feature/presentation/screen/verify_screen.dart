import 'package:apotik_online/core/color/colors.dart';
import 'package:apotik_online/core/utils/global_utils.dart';
import 'package:apotik_online/core/widget/container.dart';
import 'package:apotik_online/core/widget/loading.dart';
import 'package:apotik_online/core/widget/text.dart';
import 'package:apotik_online/feature/presentation/riverpod/auth_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VerifyScreen extends ConsumerStatefulWidget {
  const VerifyScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends ConsumerState<VerifyScreen> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as bool;

    return Consumer(builder: (context, ref, widget) {
      final authWatch = ref.watch(authProvider);
      if (authWatch.state == GlobalState.loading) {
        return const Loading();
      } else {
        final message = authWatch.message;
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
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 28,
                        ),
                        _text(),
                        const SizedBox(
                          height: 42,
                        ),
                        textUtils(
                          size: 18,
                          weight: FontWeight.bold,
                          text: message,
                          align: TextAlign.center,
                          color: message == 'Email has not been verified'
                              ? red
                              : green,
                        ),
                        const SizedBox(
                          height: 32,
                        ),
                        _button(authWatch, context, args)
                      ],
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

  _button(AuthProvider authWatch, BuildContext context, bool args) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            ref.read(authProvider.notifier).checkEmail().then((_) {
              if (authWatch.state == GlobalState.none &&
                  authWatch.message == 'Email has already been verified') {
                if (!context.mounted) return;
                Navigator.of(context).pushNamedAndRemoveUntil(
                  args == true ? '/login' : '/initial',
                  (route) => false,
                );
              }
            });
          },
          child: containerUtils(
            height: 60,
            width: 120,
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 12),
            borderRadius: 10,
            color: greenCharum,
            child: textUtils(
              size: 16,
              text: 'Verify',
              color: white,
            ),
          ),
        ),
        const SizedBox(
          width: 24,
        ),
        GestureDetector(
          onTap: () {
            ref.read(authProvider.notifier).resendEmail();
          },
          child: const CircleAvatar(
            radius: 32,
            child: Icon(
              size: 24,
              Icons.replay,
              color: Colors.black,
            ),
          ),
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
            text: "Verify your email",
            weight: FontWeight.bold,
            size: 24,
          ),
        ),
        const SizedBox(height: 2),
        textUtils(
          text: "Verify your email through the email we have sent you.",
        ),
      ],
    );
  }
}
