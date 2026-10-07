import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:sun_web_system/core/api/dio_function/api_constants.dart';
import '../../constants.dart';

class Network {
  static String _languageCode = 'ar';

  static String get languageCode => _languageCode;

  static void setLanguageCode(String languageCode) {
    _languageCode = languageCode.toLowerCase() == 'en' ? 'en' : 'ar';
  }

  static Dio _createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrlApi,
        receiveDataWhenStatusError: true,
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        followRedirects: true,
        maxRedirects: 5,
        validateStatus: (status) {
          return status != null && status < 500;
        },
      ),
    );

    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          options.queryParameters = {
            ...options.queryParameters,
            'lang': _languageCode,
          };
          handler.next(options);
        },
      ),
    );

    if (kDebugMode) {
      // Log after adding lang so the URL shows the query actually sent.
      dio.interceptors.add(
        PrettyDioLogger(
          requestBody: true,
          responseBody: true,
          error: true,
          compact: false,
          maxWidth: 120,
          logPrint: (message) => debugPrint(message.toString()),
          filter: (options, _) => options.uri.path.startsWith('/Order/'),
        ),
      );
    }

    return dio;
  }

  static final Dio dio = _createDio();

  static Future<Response> getData(String url) async {
    return await dio.get(url, options: Options(headers: myHeaders));
  }

  static Future<Response> putDataWithBody(var jsonData, String url) async {
    return await dio.put(
      url,
      data: jsonData,
      options: Options(headers: myHeaders),
    );
  }

  static Future<Response> putDataWithBodyAndParams(
      var jsonData, var jsonQuery, String url) async {
    return await dio.put(
      url,
      data: jsonData,
      queryParameters: jsonQuery,
      options: Options(headers: myHeaders),
    );
  }

  static Future<Response> deleteData(var jsonQuery, String url) async {
    return await dio.delete(
      url,
      options: Options(headers: myHeaders),
      queryParameters: jsonQuery,
    );
  }

  static Future<Response> deleteDataWithBody(var jsonData, String url) async {
    return await dio.delete(
      url,
      data: jsonData,
      options: Options(headers: myHeaders),
    );
  }

  static Future<Response> deleteDataWithBodyAndParams(
      var jsonData, var jsonQuery, String url) async {
    return await dio.delete(
      url,
      data: jsonData,
      queryParameters: jsonQuery,
      options: Options(headers: myHeaders),
    );
  }

  static Future<Response> getDataWithParams(var jsonQuery, String url) async {
    return await dio.get(
      url,
      options: Options(headers: myHeaders),
      queryParameters: jsonQuery,
    );
  }

  static Future<Response> postDataWithBody(var jsonData, String url) async {
    return await dio.post(
      url,
      data: jsonData,
      options: Options(headers: myHeaders),
    );
  }

  static Future<Response> postDataWithBodyAndParams(
      var jsonData, var jsonQuery, String url) async {
    return await dio.post(
      url,
      data: jsonData,
      queryParameters: jsonQuery,
      options: Options(headers: myHeaders),
    );
  }

  static Future<Response> postDataWithQuery(
      Map<String, dynamic> jsonQuery, String url) async {
    return await dio.post(
      url,
      queryParameters: jsonQuery,
      options: Options(headers: myHeaders),
    );
  }
}
