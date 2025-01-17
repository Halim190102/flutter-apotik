import 'package:apotik_online/core/utils/global_utils.dart';
import 'package:apotik_online/feature/domain/entity/cart_items_model.dart';
import 'package:apotik_online/feature/domain/repositories/cart_items_repository.dart';

class CartItemsUseCase {
  final CartItemsRepository repository;

  CartItemsUseCase(this.repository);

  Fr getCartItems() async {
    return await repository.getCartItems();
  }

  Fr createCartItems({required CartItemsModel model}) async {
    return await repository.createCartItems(model: model);
  }

  Fr updateCartItems({required CartItemsModel model}) async {
    return await repository.updateCartItems(model: model);
  }

  Fr deleteCartItems({required CartItemsModel model}) async {
    return await repository.deleteCartItems(model: model);
  }

  Fr multiDeleteCartItems({required List<int> id}) async {
    return await repository.multiDeleteCartItems(id: id);
  }
}
