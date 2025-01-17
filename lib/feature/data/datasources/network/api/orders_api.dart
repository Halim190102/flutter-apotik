import 'package:apotik_online/core/utils/api_endpoints.dart';
import 'package:apotik_online/core/utils/global_utils.dart';
import 'package:apotik_online/feature/domain/entity/orders_model.dart';
import 'package:dio/dio.dart';

class OrdersApi {
  final Dio dio;

  OrdersApi(this.dio);

  Fr getOrders() async {
    return await dio.get(
      OrdersApiEndpoints.orders,
    );
  }

  Fr createOrders({required List<int> id}) async {
    FormData form = FormData.fromMap({
      for (int i = 0; i < id.length; i++) 'order_ids[$i]': id[i],
    });
    return await dio.post(
      OrdersApiEndpoints.orders,
      data: form,
    );
  }

  Fr deleteOrders({required OrdersModel model}) async {
    return await dio.delete(
      '${OrdersApiEndpoints.orders}/${model.id}',
    );
  }

  Fr multiDeleteOrders({required List<int> id}) async {
    FormData form = FormData.fromMap({
      for (int i = 0; i < id.length; i++) 'ids[$i]': id[i],
    });
    return await dio.post(
      OrdersApiEndpoints.ordersMulti,
      data: form,
    );
  }

  Fr changeStatus({required OrdersModel model}) async {
    return await dio.post(
      '${OrdersApiEndpoints.changeStatus}/${model.id}',
      data: model.toJson(),
    );
  }

  Fr cancelled({required OrdersModel model}) async {
    return await dio.get(
      '${OrdersApiEndpoints.cancelled}/${model.id}',
    );
  }
}
