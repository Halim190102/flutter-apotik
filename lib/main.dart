import 'package:apotik_online/core/utils/api_endpoints.dart';
import 'package:apotik_online/core/utils/global_utils.dart';
import 'package:apotik_online/core/widget/snackbar.dart';
import 'package:apotik_online/feature/data/datasources/local/token_datasource.dart';
import 'package:apotik_online/feature/domain/entity/token_model.dart';
import 'package:apotik_online/feature/presentation/riverpod/auth_riverpod.dart';
import 'package:apotik_online/feature/presentation/riverpod/cart_items_riverpod.dart';
import 'package:apotik_online/feature/presentation/riverpod/drugs_riverpod.dart';
import 'package:apotik_online/feature/presentation/riverpod/image_riverpod.dart';
import 'package:apotik_online/feature/presentation/riverpod/index_riverpod.dart';
import 'package:apotik_online/feature/presentation/riverpod/orders_riverpod.dart';
import 'package:apotik_online/feature/presentation/riverpod/reset_riverpod.dart';
import 'package:apotik_online/feature/presentation/screen/admin/categories_method.dart';
import 'package:apotik_online/feature/presentation/screen/full_image_screen.dart';
import 'package:apotik_online/feature/presentation/screen/home_screen.dart';
import 'package:apotik_online/feature/presentation/screen/login_screen.dart';
import 'package:apotik_online/feature/presentation/screen/admin/products_method.dart';
import 'package:apotik_online/feature/presentation/screen/profile_update.dart';
import 'package:apotik_online/feature/presentation/screen/register_screen.dart';
import 'package:apotik_online/feature/presentation/screen/reset_screen.dart';
import 'package:apotik_online/feature/presentation/screen/verify_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  TokenModel? token = await TokenDataSource.getToken();
  runApp(
    ProviderScope(
      child: MyApp(
        home: token != null ? const HomeScreen() : const LoginScreen(),
      ),
    ),
  );
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key, required this.home});
  final Widget home;

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  Widget build(BuildContext context) {
    _setupListeners();

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: MaterialApp(
        navigatorKey: GlobalVariable.navigatorKey,
        scaffoldMessengerKey: GlobalVariable.scaffoldMessengerKey,
        debugShowCheckedModeBanner: false,
        routes: {
          '/home': (_) => const HomeScreen(),
          '/login': (_) => const LoginScreen(),
          '/register': (_) => const RegisterScreen(),
          '/verify': (_) => const VerifyScreen(),
          '/reset': (_) => const ResetScreen(),
          '/full_image': (_) => const FullImageScreen(),
          '/password_change': (_) => const PasswordChangeScreen(),
          '/name_change': (_) => const NameChangeScreen(),
          '/categories': (_) => const CategoriesScreen(),
          '/products': (_) => const ProductsScreen(),
        },
        home: widget.home,
      ),
    );
  }

  void _setupListeners() {
    // Listener untuk authProvider
    ref.listen(authProvider, (previous, next) {
      if (next.state == GlobalState.error && next.message.isNotEmpty) {
        _showSnackbar(next.message);
      } else if (next.state == GlobalState.none &&
          next.message == "Logged out successfully") {
        _handleLogout();
      }
    });
    final providers = [drugsProvider, cartItemsProvider, ordersProvider];
    for (final provider in providers) {
      _handleStateChanges(provider, (next) {
        if (next.state == GlobalState.error && next.message.isNotEmpty) {
          _showSnackbar(next.message);
        }
      });
    }
  }

  void _handleStateChanges<T>(
      ProviderListenable<T> provider, void Function(T next) onStateChange) {
    ref.listen(provider, (previous, next) {
      onStateChange(next);
    });
  }

  void _showSnackbar(String message) {
    GlobalSnackbar.showSnackbar(
      ref,
      Text(message),
    );
  }

  void _handleLogout() {
    ref.read(drugsProvider.notifier).categoriesList.clear();
    ref.read(drugsProvider.notifier).productsList.clear();
    ref.read(cartItemsProvider.notifier).cartItemsList.clear();
    ref.read(ordersProvider.notifier).ordersList.clear();

    GlobalVariable.navigatorKey.currentState
        ?.pushNamedAndRemoveUntil(
      '/login',
      (route) => false,
    )
        .then((_) {
      ref.invalidate(adminRiverpod);
      ref.invalidate(patientRiverpod);
      ref.invalidate(resetProvider);
      ref.invalidate(imageProvider);
    });
  }
  //   void _handledState() {
  //   final authState = ref.watch(authProvider);
  //   final drugsState = ref.watch(drugsProvider);
  //   final cartState = ref.watch(cartItemsProvider);
  //   final ordersWatch = ref.watch(ordersProvider);

  //   if ([authState, drugsState, cartState, ordersWatch].any((state) =>
  //       state.state == GlobalState.error && state.message.isNotEmpty)) {
  //     WidgetsBinding.instance.addPostFrameCallback((_) {
  //       GlobalSnackbar.showSnackbar(
  //         ref,
  //         Text(
  //           [
  //             authState.message,
  //             drugsState.message,
  //             cartState.message,
  //             ordersWatch.message,
  //           ].firstWhere(
  //             (message) => message.isNotEmpty,
  //           ),
  //         ),
  //       );
  //     });
  //   } else if (authState.state == GlobalState.none &&
  //       authState.message == "Logged out successfully") {
  //     ref.read(drugsProvider.notifier).categoriesList.clear();
  //     ref.read(drugsProvider.notifier).productsList.clear();
  //     ref.read(cartItemsProvider.notifier).cartItemsList.clear();
  //     ref.read(ordersProvider.notifier).ordersList.clear();

  //     GlobalVariable.navigatorKey.currentState
  //         ?.pushNamedAndRemoveUntil(
  //       '/login',
  //       (route) => false,
  //     )
  //         .then((_) {
  //       ref.invalidate(adminRiverpod);
  //       ref.invalidate(patientRiverpod);
  //       ref.invalidate(resetProvider);
  //       ref.invalidate(imageProvider);
  //     });
  //   }
  // }
}
