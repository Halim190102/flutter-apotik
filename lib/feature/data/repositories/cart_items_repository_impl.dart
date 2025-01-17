import 'package:apotik_online/core/utils/global_utils.dart';
import 'package:apotik_online/feature/data/datasources/network/api/cart_items_api.dart';
import 'package:apotik_online/feature/domain/entity/cart_items_model.dart';
import 'package:apotik_online/feature/domain/repositories/cart_items_repository.dart';

class CartItemsRepositoryImpl implements CartItemsRepository {
  final CartItemsApi api;

  CartItemsRepositoryImpl(this.api);
  @override
  Fr getCartItems() async {
    return await api.getCartItems();
  }

  @override
  Fr createCartItems({required CartItemsModel model}) async {
    return await api.createCartItems(model: model);
  }

  @override
  Fr updateCartItems({required CartItemsModel model}) async {
    return await api.updateCartItems(model: model);
  }

  @override
  Fr deleteCartItems({required CartItemsModel model}) async {
    return await api.deleteCartItems(model: model);
  }

  @override
  Fr multiDeleteCartItems({required List<int> id}) async {
    return await api.multiDeleteCartItems(id: id);
  }
}
