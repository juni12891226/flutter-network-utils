import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:sudani_network_layer/utils/log/debug_util.dart';

class TeCLoggerInterceptor extends InterceptorsWrapper {
  final String? baseUrl;
  final String? apiEndPoint;

  TeCLoggerInterceptor({this.baseUrl, this.apiEndPoint});

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _printLogs(
      "\n❌❌❌❌ ------- Failure Response Start ------- ❌❌❌❌\n\n",
      LogLevel.error,
    );
    _printLogs("Error::: ${err.message}", LogLevel.error);
    _printLogs("Type:: ${err.type}", LogLevel.error);
    _printLogs(
      "URL::: ${(baseUrl ?? "") + (apiEndPoint ?? "")}",
      LogLevel.error,
    );
    _printLogs("Headers::: ${err.response?.headers}", LogLevel.error);
    if (err.requestOptions.data != null) {
      _printLogs(
        "Request Body::: ${jsonEncode(err.requestOptions.data)}",
        LogLevel.error,
      );
    }
    _printLogs("Status Code::: ${err.response?.statusCode}", LogLevel.error);
    _printLogs("Response::: ${err.response?.data}", LogLevel.error);
    _printLogs(
      "\n❌❌❌❌ ------- Failure Response End ------- ❌❌❌❌\n\n",
      LogLevel.error,
    );
    super.onError(err, handler);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _printLogs("Requesting to URL: ${options.uri}", LogLevel.debug);

    _printLogs("Request Headers: ${options.headers}", LogLevel.debug);
    if (options.data != null) {
      _printLogs("Request Body::: ${jsonEncode(options.data)}", LogLevel.debug);
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    switch (response.statusCode) {
      case 200:
        _printLogs(
          "\n✅✅✅ ------- Success Response Start ------- ✅✅✅ \n",
          LogLevel.success,
        );
        _printLogs(
          "URL::: ${(baseUrl ?? "") + (apiEndPoint ?? "")}",
          LogLevel.success,
        );
        _printLogs("Headers::: ${response.headers}", LogLevel.success);
        _printLogs("Status Code::: ${response.statusCode}", LogLevel.success);
        _printLogs(
          "Response::: ${jsonEncode(response.data)}",
          LogLevel.success,
        );
        _printLogs(
          "\n✅✅✅ ------- Success Response End ------- ✅✅✅ \n",
          LogLevel.success,
        );
    }
    super.onResponse(response, handler);
  }

  void _printLogs(String text, LogLevel logLevel) {
    NetworkDebugUtils.debugLog(text, logLevel: logLevel);
  }
}
