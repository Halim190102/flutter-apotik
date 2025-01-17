import 'package:apotik_online/core/utils/global_utils.dart';
import 'package:apotik_online/feature/domain/entity/profile_model.dart';
import 'package:dio/dio.dart';

class DrugsProductsModel {
  int? id, categoryId, price, stock;
  String? name, description, picture;

  DrugsProductsModel({
    this.id,
    this.categoryId,
    this.name,
    this.description,
    this.price,
    this.stock,
    this.picture,
  });

  DrugsProductsModel.fromJson(M json) {
    id = json['id'];
    categoryId = json['category_id'];
    name = json['name'];
    description = json['description'];
    price = json['price'];
    stock = json['stock'];
    picture = json['picture'];
  }

  Ff toJson() async {
    return FormData.fromMap({
      if (id != null) 'id': id,
      if (categoryId != null) 'category_id': categoryId,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (price != null) 'price': price,
      if (stock != null) 'stock': stock,
      if (picture != null) 'picture': await pictureData(picture!)
    });
  }

  Future<MultipartFile?> pictureData(String pictures) async {
    return await ImageModel(profilepict: pictures).toJson();
  }
}
