// SRP: Each interceptor class has a single responsibility (auth vs. logging).
// This factory creates a fully configured Dio instance for the TMDB API.
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_challenge_pinapp/src/core/utils/constants.dart';

/// Singleton Dio client configured for the TMDB API v3.
class DioClient {
  DioClient._();

  static Dio? _instance;

  static Dio get instance {
    _instance ??= _build();
    return _instance!;
  }

  static Dio _build() {
    final dio = Dio(
      BaseOptions(
        baseUrl: kTmdbBaseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        headers: {'Content-Type': 'application/json'},
      ),
    );

    // SRP: AuthInterceptor is solely responsible for attaching the Bearer token.
    // TODO: logging interceptor
    dio.interceptors.add(_AuthInterceptor());

    // Only attach logging in debug builds — never log tokens in production.
    if (kDebugMode) {
      dio.interceptors.add(LogInterceptor(
        requestBody: false,
        responseBody: false,
        requestHeader: false,
      ));
    }

    return dio;
  }
}

/// Injects the TMDB Bearer token into every request header.
// Token is read at request time from the dotenv store — never hardcoded.
class _AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.headers['Authorization'] = 'Bearer $kTmdbReadAccessToken';
    super.onRequest(options, handler);
  }
}
