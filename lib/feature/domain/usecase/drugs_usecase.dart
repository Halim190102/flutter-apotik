import 'package:apotik_online/core/utils/global_utils.dart';
import 'package:apotik_online/feature/domain/entity/drugs_categories_model.dart';
import 'package:apotik_online/feature/domain/entity/drugs_products_model.dart';
import 'package:apotik_online/feature/domain/repositories/drugs_repository.dart';

class DrugsUseCase {
  final DrugsRepository repository;

  DrugsUseCase(this.repository);

  Fr getCategories() async {
    return await repository.getCategories();
  }

  Fr createCategories({required DrugsCategoriesModel model}) async {
    return await repository.createCategories(model: model);
  }

  Fr updateCategories({required DrugsCategoriesModel model}) async {
    return await repository.updateCategories(model: model);
  }

  Fr deleteCategories({required DrugsCategoriesModel model}) async {
    return await repository.deleteCategories(model: model);
  }

  Fr multiDeleteCategories({required List<int> id}) async {
    return await repository.multiDeleteCategories(id: id);
  }

  Fr getProducts() async {
    return await repository.getProducts();
  }

  Fr createProducts({required DrugsProductsModel model}) async {
    return await repository.createProducts(model: model);
  }

  Fr updateProducts({required DrugsProductsModel model}) async {
    return await repository.updateProducts(model: model);
  }

  Fr deleteProducts({required DrugsProductsModel model}) async {
    return await repository.deleteProducts(model: model);
  }

  Fr multiDeleteProducts({required List<int> id}) async {
    return await repository.multiDeleteProducts(id: id);
  }
}
