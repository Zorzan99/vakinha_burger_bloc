import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:vakinha_burger/app/core/config/env/env.dart';
import 'package:vakinha_burger/app/core/rest_client/interceptor/auth_interceptor.dart';

class CustomDio extends DioForNative {
  late AuthInterceptor _authInterceptor;
  CustomDio()
      : super(BaseOptions(
          baseUrl: Env.i['backend_base_url'] ?? '',
          connectTimeout: const Duration(
            milliseconds: 5000,
          ),
          receiveTimeout: const Duration(
            milliseconds: 60000,
          ),
        )) {
    interceptors.add(
      LogInterceptor(
        requestBody: true,
        responseBody: true,
        requestHeader: true,
        responseHeader: true,
      ),
    );
    _authInterceptor = AuthInterceptor(this);
  }

  CustomDio auth() {
    interceptors.add(_authInterceptor);
    return this;
  }

  CustomDio unauth() {
    interceptors.remove(_authInterceptor);

    return this;
  }
}
