import 'package:apotik_online/core/utils/global_utils.dart';
import 'package:apotik_online/feature/data/datasources/network/api/cart_items_api.dart';
import 'package:apotik_online/feature/data/repositories/cart_items_repository_impl.dart';
import 'package:apotik_online/feature/domain/entity/cart_items_model.dart';
import 'package:apotik_online/feature/domain/repositories/cart_items_repository.dart';
import 'package:apotik_online/feature/domain/usecase/cart_items_usecase.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final cartItemsApiProvider = Provider<CartItemsApi>(
    (ref) => CartItemsApi(ref.read(dioClientProvider).dio));

final cartItemsRepositoryProvider = Provider<CartItemsRepository>(
    (ref) => CartItemsRepositoryImpl(ref.read(cartItemsApiProvider)));

final useCaseProvider = Provider<CartItemsUseCase>(
    (ref) => CartItemsUseCase(ref.read(cartItemsRepositoryProvider)));

final cartItemsProvider = ChangeNotifierProvider<CartItemsProvider>((ref) {
  return CartItemsProvider(ref.read(useCaseProvider));
});

class CartItemsProvider extends BaseProvider {
  List<CartItemsModel> cartItemsList = [];

  final CartItemsUseCase _usecase;

  CartItemsProvider(this._usecase);

  Fv getCartItems() async {
    changeGlobalState(s: GlobalState.loading);
    Response response = await _usecase.getCartItems();
    if (response.statusCode == 200 &&
        response.data['message'] == 'Get data success') {
      cartItemsList = (response.data['data'] as List)
          .map((e) => CartItemsModel.fromJson(e))
          .toList();
      cartItemsList.sort((a, b) => b.updatedAt!.compareTo(a.updatedAt!));
      changeGlobalState(s: GlobalState.none, message: response.data['message']);
    } else {
      changeGlobalState(
          s: GlobalState.error, message: response.data['message']);
    }
  }

  Fv createCartItems({required CartItemsModel model}) async {
    changeGlobalState(s: GlobalState.loading);
    Response response = await _usecase.createCartItems(model: model);
    if (response.statusCode == 200 &&
        response.data['message'] == 'Store data success') {
      CartItemsModel cartItems = CartItemsModel.fromJson(response.data['data']);
      if (cartItemsList.any((i) => i.productId == cartItems.productId)) {
        int index = cartItemsList.indexWhere((e) => e.id == cartItems.id);
        cartItemsList[index] = cartItems;
      } else {
        cartItemsList.add(cartItems);
      }
      cartItemsList.sort((a, b) => b.updatedAt!.compareTo(a.updatedAt!));

      changeGlobalState(s: GlobalState.none, message: response.data['message']);
    } else {
      changeGlobalState(
          s: GlobalState.error, message: response.data['message']);
    }
  }

  Fv updateCartItems({required CartItemsModel model}) async {
    changeGlobalState(s: GlobalState.loading);
    Response response = await _usecase.updateCartItems(model: model);
    if (response.statusCode == 200 &&
        response.data['message'] == 'Update data success') {
      CartItemsModel cartItems = CartItemsModel.fromJson(response.data['data']);
      int index = cartItemsList.indexWhere((e) => e.id == cartItems.id);
      cartItemsList[index] = cartItems;
      cartItemsList.sort((a, b) => b.updatedAt!.compareTo(a.updatedAt!));
      changeGlobalState(s: GlobalState.none, message: response.data['message']);
    } else {
      changeGlobalState(
          s: GlobalState.error, message: response.data['message']);
    }
  }

  Fv deleteCartItems({required CartItemsModel model}) async {
    changeGlobalState(s: GlobalState.loading);
    Response response = await _usecase.deleteCartItems(model: model);
    if (response.statusCode == 200 &&
        response.data['message'] == 'Delete data success') {
      cartItemsList.removeWhere((e) => e.id == model.id);
      changeGlobalState(s: GlobalState.none, message: response.data['message']);
    } else {
      changeGlobalState(
          s: GlobalState.error, message: response.data['message']);
    }
  }

  Fv multiDeleteCartItems({required List<int> id}) async {
    changeGlobalState(s: GlobalState.loading);
    Response response = await _usecase.multiDeleteCartItems(id: id);
    if (response.statusCode == 200 &&
        response.data['message'] == 'Delete multi data success') {
      for (int i in id) {
        cartItemsList.removeWhere((e) => e.id == i);
      }
      changeGlobalState(s: GlobalState.none, message: response.data['message']);
    } else {
      changeGlobalState(
          s: GlobalState.error, message: response.data['message']);
    }
  }
}
