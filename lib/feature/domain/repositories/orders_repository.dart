import 'package:apotik_online/core/utils/global_utils.dart';
import 'package:apotik_online/feature/domain/entity/orders_model.dart';

abstract class OrdersRepository {
  Fr getOrders();
  Fr createOrders({required List<int> id});
  Fr deleteOrders({required OrdersModel model});
  Fr multiDeleteOrders({required List<int> id});
  Fr changeStatus({required OrdersModel model});
  Fr cancelled({required OrdersModel model});
}
