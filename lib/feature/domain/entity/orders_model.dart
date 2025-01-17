import 'package:apotik_online/core/utils/global_utils.dart';

class OrdersModel {
  int? id, userId, totalPrice, statusOption;
  String? status, messages;
  List<Pivot>? pivot;
  DateTime? createdAt, updatedAt;

  OrdersModel({
    this.id,
    this.userId,
    this.totalPrice,
    this.status,
    this.messages,
    this.pivot,
    this.createdAt,
    this.updatedAt,
    this.statusOption,
  });

  OrdersModel.fromJson(M json) {
    id = json['id'];
    userId = json['user_id'];
    totalPrice = json['total_price'];
    status = json['status'];
    messages = json['messages'];
    createdAt =
        json['created_at'] != null ? DateTime.parse(json['created_at']) : null;
    updatedAt =
        json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null;
    if (json['pivot'] != null) {
      pivot = <Pivot>[];
      json['pivot'].forEach((v) {
        pivot!.add(Pivot.fromJson(v));
      });
    }
  }

  M toJson() {
    final M data = <String, dynamic>{};
    data['status_option'] = statusOption;
    data['id'] = id;
    return data;
  }
}

class Pivot {
  int? orderId, cartItemId;

  Pivot({
    this.orderId,
    this.cartItemId,
  });

  Pivot.fromJson(M json) {
    orderId = json['order_id'];
    cartItemId = json['cart_item_id'];
  }
}
