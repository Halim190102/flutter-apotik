import 'package:apotik_online/core/color/colors.dart';
import 'package:apotik_online/core/utils/api_endpoints.dart';
import 'package:apotik_online/feature/presentation/riverpod/auth_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GlobalSnackbar {
  static showSnackbar(
    WidgetRef ref,
    Widget widget,
  ) {
    GlobalVariable.scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(
        onVisible: () {
          ref.read(authProvider.notifier).stateNone();
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        content: widget,
        backgroundColor: greenCharum,
        dismissDirection: DismissDirection.startToEnd,
        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(GlobalVariable.navigatorKey.currentContext!)
                  .size
                  .height -
              150,
          left: 10,
          right: 10,
        ),
      ),
    );
  }
}
