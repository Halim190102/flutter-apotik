import 'package:apotik_online/core/utils/global_utils.dart';

class CartItemsModel {
  int? id, userId, productId, qty, price;
  String? status;
  DateTime? createdAt, updatedAt;

  CartItemsModel({
    this.id,
    this.userId,
    this.productId,
    this.qty,
    this.price,
    this.status,
    this.createdAt,
    this.updatedAt,
  });

  CartItemsModel.fromJson(M json) {
    id = json['id'];
    userId = json['user_id'];
    productId = json['product_id'];
    qty = json['qty'];
    price = json['price'];
    status = json['status'];
    createdAt =
        json['created_at'] != null ? DateTime.parse(json['created_at']) : null;
    updatedAt =
        json['updated_at'] != null ? DateTime.parse(json['updated_at']) : null;
  }

  M toJson() {
    final M data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['product_id'] = productId;
    data['qty'] = qty;
    data['price'] = price;
    data['status'] = status;
    return data;
  }
}
