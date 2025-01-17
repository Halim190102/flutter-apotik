import 'package:apotik_online/core/utils/global_utils.dart';
import 'package:apotik_online/feature/data/datasources/network/api/orders_api.dart';
import 'package:apotik_online/feature/domain/entity/orders_model.dart';
import 'package:apotik_online/feature/domain/repositories/orders_repository.dart';

class OrdersRepositoryImpl implements OrdersRepository {
  final OrdersApi api;

  OrdersRepositoryImpl(this.api);
  @override
  Fr getOrders() async {
    return await api.getOrders();
  }

  @override
  Fr createOrders({required List<int> id}) async {
    return await api.createOrders(id: id);
  }

  @override
  Fr deleteOrders({required OrdersModel model}) async {
    return await api.deleteOrders(model: model);
  }

  @override
  Fr multiDeleteOrders({required List<int> id}) async {
    return await api.multiDeleteOrders(id: id);
  }

  @override
  Fr changeStatus({required OrdersModel model}) async {
    return await api.changeStatus(model: model);
  }

  @override
  Fr cancelled({required OrdersModel model}) async {
    return await api.cancelled(model: model);
  }
}
