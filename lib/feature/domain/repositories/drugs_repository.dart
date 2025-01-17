import 'package:apotik_online/core/utils/global_utils.dart';
import 'package:apotik_online/feature/domain/entity/drugs_categories_model.dart';
import 'package:apotik_online/feature/domain/entity/drugs_products_model.dart';

abstract class DrugsRepository {
  Fr getCategories();
  Fr createCategories({required DrugsCategoriesModel model});
  Fr updateCategories({required DrugsCategoriesModel model});
  Fr deleteCategories({required DrugsCategoriesModel model});
  Fr multiDeleteCategories({required List<int> id});
  Fr getProducts();
  Fr createProducts({required DrugsProductsModel model});
  Fr updateProducts({required DrugsProductsModel model});
  Fr deleteProducts({required DrugsProductsModel model});
  Fr multiDeleteProducts({required List<int> id});
}
