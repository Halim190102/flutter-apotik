import 'package:apotik_online/core/utils/global_utils.dart';
import 'package:apotik_online/feature/domain/entity/orders_model.dart';
import 'package:apotik_online/feature/domain/repositories/orders_repository.dart';

class OrdersUseCase {
  final OrdersRepository repository;

  OrdersUseCase(this.repository);
  Fr getOrders() async {
    return await repository.getOrders();
  }

  Fr createOrders({required List<int> id}) async {
    return await repository.createOrders(id: id);
  }

  Fr deleteOrders({required OrdersModel model}) async {
    return await repository.deleteOrders(model: model);
  }

  Fr multiDeleteOrders({required List<int> id}) async {
    return await repository.multiDeleteOrders(id: id);
  }

  Fr changeStatus({required OrdersModel model}) async {
    return await repository.changeStatus(model: model);
  }

  Fr cancelled({required OrdersModel model}) async {
    return await repository.cancelled(model: model);
  }
}
