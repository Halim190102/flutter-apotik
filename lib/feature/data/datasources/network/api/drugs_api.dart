import 'package:apotik_online/core/utils/api_endpoints.dart';
import 'package:apotik_online/core/utils/global_utils.dart';
import 'package:apotik_online/feature/domain/entity/drugs_categories_model.dart';
import 'package:apotik_online/feature/domain/entity/drugs_products_model.dart';
import 'package:dio/dio.dart';

class DrugsApi {
  final Dio dio;

  DrugsApi(this.dio);

  Fr getCategories() async {
    return await dio.get(
      DrugsApiEndpoints.drugsCategories,
    );
  }

  Fr createCategories({required DrugsCategoriesModel model}) async {
    return await dio.post(
      DrugsApiEndpoints.drugsCategories,
      data: model.toJson(),
    );
  }

  Fr updateCategories({required DrugsCategoriesModel model}) async {
    return await dio.post(
      '${DrugsApiEndpoints.drugsCategories}/${model.id}?_method=PUT',
      data: model.toJson(),
    );
  }

  Fr deleteCategories({required DrugsCategoriesModel model}) async {
    return await dio.delete(
      '${DrugsApiEndpoints.drugsCategories}/${model.id}',
    );
  }

  Fr multiDeleteCategories({required List<int> id}) async {
    FormData form = FormData.fromMap({
      for (int i = 0; i < id.length; i++) 'ids[$i]': id[i],
    });
    return await dio.post(
      DrugsApiEndpoints.drugsCategoriesMulti,
      data: form,
    );
  }

  Fr getProducts() async {
    return await dio.get(
      DrugsApiEndpoints.drugsProducts,
    );
  }

  Fr createProducts({required DrugsProductsModel model}) async {
    return await dio.post(
      DrugsApiEndpoints.drugsProducts,
      data: await model.toJson(),
    );
  }

  Fr updateProducts({required DrugsProductsModel model}) async {
    return await dio.post(
      '${DrugsApiEndpoints.drugsProducts}/${model.id}?_method=PUT',
      data: await model.toJson(),
    );
  }

  Fr deleteProducts({required DrugsProductsModel model}) async {
    return await dio.delete(
      '${DrugsApiEndpoints.drugsProducts}/${model.id}',
    );
  }

  Fr multiDeleteProducts({required List<int> id}) async {
    FormData form = FormData.fromMap({
      for (int i = 0; i < id.length; i++) 'ids[$i]': id[i],
    });
    return await dio.post(
      DrugsApiEndpoints.drugsProductsMulti,
      data: form,
    );
  }
}
