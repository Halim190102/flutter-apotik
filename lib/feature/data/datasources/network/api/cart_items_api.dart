import 'package:apotik_online/core/utils/api_endpoints.dart';
import 'package:apotik_online/core/utils/global_utils.dart';
import 'package:apotik_online/feature/domain/entity/cart_items_model.dart';
import 'package:dio/dio.dart';

class CartItemsApi {
  final Dio dio;

  CartItemsApi(this.dio);

  Fr getCartItems() async {
    return await dio.get(
      cartItemsEndPoint,
    );
  }

  Fr createCartItems({required CartItemsModel model}) async {
    return await dio.post(
      cartItemsEndPoint,
      data: model.toJson(),
    );
  }

  Fr updateCartItems({required CartItemsModel model}) async {
    return await dio.post(
      '$cartItemsEndPoint/${model.id}?_method=PUT',
      data: model.toJson(),
    );
  }

  Fr deleteCartItems({required CartItemsModel model}) async {
    return await dio.delete(
      '$cartItemsEndPoint/${model.id}',
      data: model.toJson(),
    );
  }

  Fr multiDeleteCartItems({required List<int> id}) async {
    FormData form = FormData.fromMap({
      for (int i = 0; i < id.length; i++) 'ids[$i]': id[i],
    });
    return await dio.post(
      '${cartItemsEndPoint}_delete',
      data: form,
    );
  }
}
