import 'package:apotik_online/core/utils/global_utils.dart';
import 'package:apotik_online/core/widget/container.dart';
import 'package:apotik_online/core/widget/loading.dart';
import 'package:apotik_online/feature/presentation/riverpod/auth_riverpod.dart';
import 'package:apotik_online/feature/presentation/riverpod/reset_riverpod.dart';
import 'package:apotik_online/feature/presentation/screen/reset/reset_password.dart';
import 'package:apotik_online/feature/presentation/screen/reset/send_code.dart';
import 'package:apotik_online/feature/presentation/screen/reset/verify_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ResetScreen extends ConsumerStatefulWidget {
  const ResetScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ResetScreenState();
}

class _ResetScreenState extends ConsumerState<ResetScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, widget) {
        final authWatch = ref.watch(authProvider);
        if (authWatch.state == GlobalState.loading) {
          return const Loading();
        } else {
          switch (authWatch.message) {
            case 'Verification code has been send':
              ref.read(resetProvider.notifier).state = 1;
              break;
            case 'Reset code verified successfully':
              ref.read(resetProvider.notifier).state = 2;
              break;
            case 'Reset password success':
              Navigator.of(context).pushNamedAndRemoveUntil(
                '/login',
                (route) => false,
              );
              ref.invalidate(resetProvider);
              break;
          }
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
                      child: Consumer(
                        builder: (context, ref, widget) {
                          final resetState = ref.watch(resetProvider);

                          return AnimatedSwitcher(
                            duration: const Duration(milliseconds: 500),
                            transitionBuilder:
                                (Widget child, Animation<double> animation) {
                              return SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(-1, 0),
                                  end: Offset.zero,
                                ).animate(animation),
                                child: child,
                              );
                            },
                            child: _buildResetPage(resetState),
                          );
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildResetPage(int resetState) {
    switch (resetState) {
      case 0:
        return const SendResetCode();
      case 1:
        return const VerifyCode();
      case 2:
        return const ResetYourPassword();
      default:
        return Container();
    }
  }
}
