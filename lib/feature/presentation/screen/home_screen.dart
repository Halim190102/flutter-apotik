import 'package:apotik_online/core/utils/global_utils.dart';
import 'package:apotik_online/core/widget/loading.dart';
import 'package:apotik_online/feature/presentation/riverpod/auth_riverpod.dart';
import 'package:apotik_online/feature/presentation/riverpod/cart_items_riverpod.dart';
import 'package:apotik_online/feature/presentation/riverpod/drugs_riverpod.dart';
import 'package:apotik_online/feature/presentation/riverpod/orders_riverpod.dart';
import 'package:apotik_online/feature/presentation/screen/admin/admin_home.dart';
import 'package:apotik_online/feature/presentation/screen/patient/patient_home.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(authProvider.notifier).getDataUser().then((_) {
        ref.read(drugsProvider.notifier).getCategories();
        ref.read(cartItemsProvider.notifier).getCartItems();
        ref.read(ordersProvider).getOrders();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final authWatch = ref.watch(authProvider);
        final drugsWatch = ref.watch(drugsProvider);
        final cartWatch = ref.watch(cartItemsProvider);
        final ordersWatch = ref.watch(ordersProvider);

        if ([authWatch, drugsWatch, cartWatch, ordersWatch]
            .any((state) => state.state == GlobalState.loading)) {
          return const Loading();
        } else {
          final profile = authWatch.profile;
          if (profile != null) {
            if (profile.role == 'admin') {
              return const Admin();
            } else {
              return const Patient();
            }
          } else {
            return const SizedBox.shrink();
          }
        }
      },
    );
  }
}
