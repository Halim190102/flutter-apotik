import 'package:apotik_online/core/utils/global_utils.dart';
import 'package:apotik_online/feature/data/datasources/network/api/drugs_api.dart';
import 'package:apotik_online/feature/domain/entity/drugs_categories_model.dart';
import 'package:apotik_online/feature/domain/entity/drugs_products_model.dart';
import 'package:apotik_online/feature/domain/repositories/drugs_repository.dart';

class DrugsRepositoryImpl implements DrugsRepository {
  final DrugsApi api;

  DrugsRepositoryImpl(this.api);

  @override
  Fr getCategories() async {
    return await api.getCategories();
  }

  @override
  Fr createCategories({required DrugsCategoriesModel model}) async {
    return await api.createCategories(model: model);
  }

  @override
  Fr updateCategories({required DrugsCategoriesModel model}) async {
    return await api.updateCategories(model: model);
  }

  @override
  Fr deleteCategories({required DrugsCategoriesModel model}) async {
    return await api.deleteCategories(model: model);
  }

  @override
  Fr multiDeleteCategories({required List<int> id}) async {
    return await api.multiDeleteCategories(id: id);
  }

  @override
  Fr getProducts() async {
    return await api.getProducts();
  }

  @override
  Fr createProducts({required DrugsProductsModel model}) async {
    return await api.createProducts(model: model);
  }

  @override
  Fr updateProducts({required DrugsProductsModel model}) async {
    return await api.updateProducts(model: model);
  }

  @override
  Fr deleteProducts({required DrugsProductsModel model}) async {
    return await api.deleteProducts(model: model);
  }

  @override
  Fr multiDeleteProducts({required List<int> id}) async {
    return await api.multiDeleteProducts(id: id);
  }
}
