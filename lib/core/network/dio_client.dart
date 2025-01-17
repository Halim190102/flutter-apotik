import 'package:apotik_online/core/utils/api_endpoints.dart';
import 'package:apotik_online/feature/data/datasources/local/token_datasource.dart';
import 'package:apotik_online/feature/domain/entity/token_model.dart';
import 'package:apotik_online/feature/presentation/riverpod/auth_riverpod.dart';
import 'package:dio/dio.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

class DioClient {
  final Dio dio;
  final Ref ref;

  DioClient(this.ref)
      : dio = Dio(
          BaseOptions(
            baseUrl: baseUrl,
            contentType: "application/json",
            receiveTimeout: const Duration(seconds: 6000),
            connectTimeout: const Duration(seconds: 6000),
          ),
        ) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          TokenModel? tokens = await TokenDataSource.getToken();
          options.headers['Authorization'] = 'Bearer ${tokens?.accessToken}';
          return handler.next(options);
        },
        onError: (error, handler) async {
          if (error.response?.statusCode == 401) {
            TokenModel? tokens = await TokenDataSource.getToken();
            try {
              FormData form = FormData.fromMap({
                'refresh_token': tokens?.refreshToken,
              });
              Response response = await dio.post(
                AuthApiEndpoints.refresh,
                data: form,
              );
              TokenModel newtokens = TokenModel.fromJson(response.data);
              await TokenDataSource.saveToken(newtokens);
              if (newtokens.accessToken != null) {
                dio.options.headers['Authorization'] =
                    'Bearer ${newtokens.accessToken!}';
                final RequestOptions options = error.requestOptions;
                options.headers['Authorization'] =
                    'Bearer ${newtokens.accessToken}';
                return handler.resolve(await dio.fetch(options));
              }
            } catch (e) {
              await TokenDataSource.clearToken();
              ref.read(authProvider.notifier).option(1);
              GlobalVariable.navigatorKey.currentState
                  ?.pushNamedAndRemoveUntil('/login', (route) => false);
            }
          } else {
            return handler.next(error);
          }
        },
      ),
    );
  }
}
