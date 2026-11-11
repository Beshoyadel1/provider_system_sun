import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import '../api_json.dart';
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
        onResponse: (response, handler) {
          response.data = ApiJson.decode(response.data);
          handler.next(response);
        },
        onError: (error, handler) {
          final response = error.response;
          if (response != null) response.data = ApiJson.decode(response.data);
          handler.next(error);
        },
      ),
    );

    if (kDebugMode) dio.interceptors.add(_DebugDioLogger());

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

class _DebugDioLogger extends PrettyDioLogger {
  _DebugDioLogger()
      : super(
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
          responseBody: true,
          compact: false,
          maxWidth: 120,
          logPrint: (message) => debugPrint(message.toString()),
        );

  static final _sensitiveField = RegExp(
    r'password|token|^(authorization|proxy-authorization|cookie|set-cookie|otp|verification[_-]?code|cvv|card[_-]?number|(x-)?api[_-]?key)$',
    caseSensitive: false,
  );

  final _requestPreviews = Expando<RequestOptions>();

  // PrettyDioLogger formats copies so redaction never changes the API payload.
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final preview = _requestPreview(options)..data = _bodyPreview(options.data);
    _requestPreviews[options] = preview;
    super.onRequest(preview, RequestInterceptorHandler());
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _logResponse(response);
    handler.next(response);
  }

  @override
  void onError(DioException error, ErrorInterceptorHandler handler) {
    final response = error.response;
    if (response == null) {
      logPrint(
          'Dio error (${error.type.name}): ${_requestPreview(error.requestOptions).uri}');
    } else {
      _logResponse(response);
    }
    handler.next(error);
  }

  void _logResponse(Response response) {
    super.onResponse(
      Response(
        requestOptions: _requestPreviews[response.requestOptions] ??
            _requestPreview(response.requestOptions),
        data: _bodyPreview(response.data),
        headers: Headers.fromMap({
          for (final entry in response.headers.map.entries)
            entry.key: _sensitiveField.hasMatch(entry.key)
                ? ['[redacted]']
                : entry.value,
        }),
        statusCode: response.statusCode,
        statusMessage: response.statusMessage,
      ),
      ResponseInterceptorHandler(),
    );
  }

  RequestOptions _requestPreview(RequestOptions options) {
    final uri = options.uri;
    return options.copyWith(
      path: uri
          .replace(queryParameters: _redactFields(uri.queryParametersAll))
          .toString(),
      queryParameters: {},
      headers: _redactFields(options.headers),
      extra: _redactFields(options.extra),
    );
  }

  Object? _bodyPreview(Object? body) {
    if (body is String) {
      try {
        return _redact(jsonDecode(body));
      } on FormatException {
        return body;
      }
    }
    if (body is FormData) {
      return _redactFields({
        ...Map.fromEntries(body.fields),
        for (final file in body.files)
          file.key: '[file: ${file.value.length} bytes]',
      });
    }
    return _redact(body);
  }

  Object? _redact(Object? value) {
    if (value is Uint8List) return '[${value.length} bytes]';
    if (value is Map) return _redactFields(value);
    if (value is List) return value.map(_redact).toList();
    return value;
  }

  Map<String, dynamic> _redactFields(Map fields) {
    return {
      for (final entry in fields.entries)
        entry.key.toString(): _sensitiveField.hasMatch(entry.key.toString()) &&
                entry.value != null &&
                entry.value != ''
            ? '[redacted]'
            : _redact(entry.value),
    };
  }
}
