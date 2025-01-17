import 'package:apotik_online/core/utils/global_utils.dart';
import 'package:apotik_online/feature/domain/entity/drugs_products_model.dart';

class DrugsCategoriesModel {
  int? id;
  String? name;
  List<DrugsProductsModel>? products;

  DrugsCategoriesModel({
    this.id,
    this.name,
    this.products,
  });

  DrugsCategoriesModel.fromJson(M json) {
    id = json['id'];
    name = json['name'];
    if (json['products'] != null) {
      products = <DrugsProductsModel>[];
      json['products'].forEach((v) {
        products!.add(DrugsProductsModel.fromJson(v));
      });
    }
  }

  M toJson() {
    final M data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }
}
