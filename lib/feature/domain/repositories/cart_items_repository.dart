import 'package:apotik_online/core/utils/global_utils.dart';
import 'package:apotik_online/feature/domain/entity/cart_items_model.dart';

abstract class CartItemsRepository {
  Fr getCartItems();
  Fr createCartItems({required CartItemsModel model});
  Fr updateCartItems({required CartItemsModel model});
  Fr deleteCartItems({required CartItemsModel model});
  Fr multiDeleteCartItems({required List<int> id});
}
