import 'package:apotik_online/core/utils/global_utils.dart';
import 'package:apotik_online/feature/data/datasources/network/api/orders_api.dart';
import 'package:apotik_online/feature/data/repositories/orders_repository_impl.dart';
import 'package:apotik_online/feature/domain/entity/orders_model.dart';
import 'package:apotik_online/feature/domain/repositories/orders_repository.dart';
import 'package:apotik_online/feature/domain/usecase/orders_usecase.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final ordersApiProvider =
    Provider<OrdersApi>((ref) => OrdersApi(ref.read(dioClientProvider).dio));

final ordersRepositoryProvider = Provider<OrdersRepository>(
    (ref) => OrdersRepositoryImpl(ref.read(ordersApiProvider)));

final useCaseProvider = Provider<OrdersUseCase>(
    (ref) => OrdersUseCase(ref.read(ordersRepositoryProvider)));

final ordersProvider = ChangeNotifierProvider<OrdersProvider>((ref) {
  return OrdersProvider(ref.read(useCaseProvider));
});

class OrdersProvider extends BaseProvider {
  List<OrdersModel> ordersList = [];

  final OrdersUseCase _usecase;

  OrdersProvider(this._usecase);

  Fv getOrders() async {
    changeGlobalState(s: GlobalState.loading);
    Response response = await _usecase.getOrders();
    if (response.statusCode == 200 &&
        response.data['message'] == 'Get data success') {
      ordersList = (response.data['data'] as List)
          .map((e) => OrdersModel.fromJson(e))
          .toList();
      ordersList.sort((a, b) => b.updatedAt!.compareTo(a.updatedAt!));
      changeGlobalState(s: GlobalState.none, message: response.data['message']);
    } else {
      changeGlobalState(
          s: GlobalState.error, message: response.data['message']);
    }
  }

  Fv createOrders({required List<int> id}) async {
    changeGlobalState(s: GlobalState.loading);
    Response response = await _usecase.createOrders(id: id);
    if (response.statusCode == 200 &&
        response.data['message'] == 'Store data success') {
      OrdersModel cartItems = OrdersModel.fromJson(response.data['data']);
      ordersList.add(cartItems);
      ordersList.sort((a, b) => b.updatedAt!.compareTo(a.updatedAt!));
      changeGlobalState(s: GlobalState.none, message: response.data['message']);
    } else {
      changeGlobalState(
          s: GlobalState.error, message: response.data['message']);
    }
  }

  Fv deleteOrders({required OrdersModel model}) async {
    changeGlobalState(s: GlobalState.loading);
    Response response = await _usecase.deleteOrders(model: model);
    if (response.statusCode == 200 &&
        response.data['message'] == 'Delete data success') {
      ordersList.removeWhere((e) => e.id == model.id);
      changeGlobalState(s: GlobalState.none, message: response.data['message']);
    } else {
      changeGlobalState(
          s: GlobalState.error, message: response.data['message']);
    }
  }

  Fv multiDeleteOrders({required List<int> id}) async {
    changeGlobalState(s: GlobalState.loading);
    Response response = await _usecase.multiDeleteOrders(id: id);
    if (response.statusCode == 200 &&
        response.data['message'] == 'Delete multi data success') {
      for (int i in id) {
        ordersList.removeWhere((e) => e.id == i);
      }
      changeGlobalState(s: GlobalState.none, message: response.data['message']);
    } else {
      changeGlobalState(
          s: GlobalState.error, message: response.data['message']);
    }
  }

  Fv changeStatus({required OrdersModel model}) async {
    changeGlobalState(s: GlobalState.loading);
    Response response = await _usecase.changeStatus(model: model);
    if (response.statusCode == 200 && response.data['message'] == 'success') {
      OrdersModel orders = OrdersModel.fromJson(response.data['data']);
      int index = ordersList.indexWhere((e) => e.id == orders.id);
      ordersList[index] = orders;
      ordersList.sort((a, b) => b.updatedAt!.compareTo(a.updatedAt!));
      changeGlobalState(s: GlobalState.none, message: response.data['message']);
    } else {
      changeGlobalState(
          s: GlobalState.error, message: response.data['message']);
    }
  }

  Fv cancelled({required OrdersModel model}) async {
    changeGlobalState(s: GlobalState.loading);
    Response response = await _usecase.cancelled(model: model);
    if (response.statusCode == 200 && response.data['message'] == 'success') {
      OrdersModel orders = OrdersModel.fromJson(response.data['data']);
      int index = ordersList.indexWhere((e) => e.id == orders.id);
      ordersList[index] = orders;
      ordersList.sort((a, b) => b.updatedAt!.compareTo(a.updatedAt!));
      changeGlobalState(s: GlobalState.none, message: response.data['message']);
    } else {
      changeGlobalState(
          s: GlobalState.error, message: response.data['message']);
    }
  }
}
