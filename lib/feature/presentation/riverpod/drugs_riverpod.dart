import 'package:apotik_online/core/utils/global_utils.dart';
import 'package:apotik_online/feature/data/datasources/network/api/drugs_api.dart';
import 'package:apotik_online/feature/data/repositories/drugs_repository_impl.dart';
import 'package:apotik_online/feature/domain/entity/drugs_categories_model.dart';
import 'package:apotik_online/feature/domain/entity/drugs_products_model.dart';
import 'package:apotik_online/feature/domain/repositories/drugs_repository.dart';
import 'package:apotik_online/feature/domain/usecase/drugs_usecase.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final drugsApiProvider =
    Provider<DrugsApi>((ref) => DrugsApi(ref.read(dioClientProvider).dio));

final drugsRepositoryProvider = Provider<DrugsRepository>(
    (ref) => DrugsRepositoryImpl(ref.read(drugsApiProvider)));

final useCaseProvider = Provider<DrugsUseCase>(
    (ref) => DrugsUseCase(ref.read(drugsRepositoryProvider)));

final drugsProvider = ChangeNotifierProvider<DrugsProvider>((ref) {
  return DrugsProvider(ref.read(useCaseProvider));
});

class DrugsProvider extends BaseProvider {
  List<DrugsCategoriesModel> categoriesList = [];
  List<DrugsProductsModel> productsList = [];

  final DrugsUseCase _usecase;

  DrugsProvider(this._usecase);

  Fv getCategories() async {
    changeGlobalState(s: GlobalState.loading);
    Response response = await _usecase.getCategories();
    if (response.statusCode == 200 &&
        response.data['message'] == 'Get data success') {
      categoriesList = (response.data['data'] as List)
          .map((e) => DrugsCategoriesModel.fromJson(e))
          .toList();
      categoriesList.sort(
          (a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
      for (var c in categoriesList) {
        if (c.products != null) {
          productsList.addAll(c.products!);
        }
      }
      productsList.sort(
          (a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
      changeGlobalState(s: GlobalState.none, message: response.data['message']);
    } else {
      changeGlobalState(
          s: GlobalState.error, message: response.data['message']);
    }
  }

  Fv createCategories({required DrugsCategoriesModel model}) async {
    changeGlobalState(s: GlobalState.loading);
    Response response = await _usecase.createCategories(model: model);
    if (response.statusCode == 200 &&
        response.data['message'] == 'Store data success') {
      DrugsCategoriesModel category =
          DrugsCategoriesModel.fromJson(response.data['data']);
      categoriesList.add(category);
      categoriesList.sort(
          (a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
      changeGlobalState(s: GlobalState.none, message: response.data['message']);
    } else {
      changeGlobalState(
          s: GlobalState.error, message: response.data['message']);
    }
  }

  Fv updateCategories({required DrugsCategoriesModel model}) async {
    changeGlobalState(s: GlobalState.loading);
    Response response = await _usecase.updateCategories(model: model);
    if (response.statusCode == 200 &&
        response.data['message'] == 'Update data success') {
      DrugsCategoriesModel category =
          DrugsCategoriesModel.fromJson(response.data['data']);
      int index = categoriesList.indexWhere((e) => e.id == category.id);
      categoriesList[index] = category;
      categoriesList.sort(
          (a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
      changeGlobalState(s: GlobalState.none, message: response.data['message']);
    } else {
      changeGlobalState(
          s: GlobalState.error, message: response.data['message']);
    }
  }

  Fv deleteCategories({required DrugsCategoriesModel model}) async {
    changeGlobalState(s: GlobalState.loading);
    Response response = await _usecase.deleteCategories(model: model);
    if (response.statusCode == 200 &&
        response.data['message'] == 'Delete data success') {
      deleteC(model.id);
      changeGlobalState(s: GlobalState.none, message: response.data['message']);
    } else {
      changeGlobalState(
          s: GlobalState.error, message: response.data['message']);
    }
  }

  Fv multiDeleteCategories({required List<int> id}) async {
    changeGlobalState(s: GlobalState.loading);
    Response response = await _usecase.multiDeleteCategories(id: id);
    if (response.statusCode == 200 &&
        response.data['message'] == 'Delete multi data success') {
      for (int i in id) {
        deleteC(i);
      }
      changeGlobalState(s: GlobalState.none, message: response.data['message']);
    } else {
      changeGlobalState(
          s: GlobalState.error, message: response.data['message']);
    }
  }

  deleteC(int? cid) {
    categoriesList.removeWhere((e) => e.id == cid);
    productsList.removeWhere((e) => e.categoryId == cid);
  }

  Fv getProducts() async {
    changeGlobalState(s: GlobalState.loading);
    Response response = await _usecase.getProducts();
    if (response.statusCode == 200 &&
        response.data['message'] == 'Get data success') {
      productsList = (response.data['data'] as List)
          .map((e) => DrugsProductsModel.fromJson(e))
          .toList();
      productsList.sort(
          (a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
      changeGlobalState(s: GlobalState.none, message: response.data['message']);
    } else {
      changeGlobalState(
          s: GlobalState.error, message: response.data['message']);
    }
  }

  Fv createProducts({required DrugsProductsModel model}) async {
    changeGlobalState(s: GlobalState.loading);
    Response response = await _usecase.createProducts(model: model);
    if (response.statusCode == 200 &&
        response.data['message'] == 'Store data success') {
      DrugsProductsModel product =
          DrugsProductsModel.fromJson(response.data['data']);
      productsList.add(product);
      productsList.sort(
          (a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
      changeGlobalState(s: GlobalState.none, message: response.data['message']);
    } else {
      changeGlobalState(
          s: GlobalState.error, message: response.data['message']);
    }
  }

  Fv updateProducts({required DrugsProductsModel model}) async {
    changeGlobalState(s: GlobalState.loading);
    Response response = await _usecase.updateProducts(model: model);
    if (response.statusCode == 200 &&
        response.data['message'] == 'Update data success') {
      DrugsProductsModel product =
          DrugsProductsModel.fromJson(response.data['data']);
      int index = productsList.indexWhere((e) => e.id == product.id);
      productsList[index] = product;
      productsList.sort(
          (a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
      changeGlobalState(s: GlobalState.none, message: response.data['message']);
    } else {
      changeGlobalState(
          s: GlobalState.error, message: response.data['message']);
    }
  }

  Fv deleteProducts({required DrugsProductsModel model}) async {
    changeGlobalState(s: GlobalState.loading);
    Response response = await _usecase.deleteProducts(model: model);
    if (response.statusCode == 200 &&
        response.data['message'] == 'Delete data success') {
      productsList.removeWhere((e) => e.id == model.id);
      changeGlobalState(s: GlobalState.none, message: response.data['message']);
    } else {
      changeGlobalState(
          s: GlobalState.error, message: response.data['message']);
    }
  }

  Fv multiDeleteProducts({required List<int> id}) async {
    changeGlobalState(s: GlobalState.loading);
    Response response = await _usecase.multiDeleteProducts(id: id);
    if (response.statusCode == 200 &&
        response.data['message'] == 'Delete multi data success') {
      for (int i in id) {
        productsList.removeWhere((e) => e.id == i);
      }
      changeGlobalState(s: GlobalState.none, message: response.data['message']);
    } else {
      changeGlobalState(
          s: GlobalState.error, message: response.data['message']);
    }
  }
}
