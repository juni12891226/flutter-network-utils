import 'package:dio/dio.dart' as dio_dart;
import 'package:sudani_network_layer/utils/imports/tec_network_layer_imports_util.dart';

abstract class TeCNetworkRequest {
  Future<void> processPostRequest<T>({
    required String baseURL,
    required Function() onAuthorizationFailedCallback,
    T Function(Map<String, dynamic>)? responseParserCallback,
    required String apiEndPoint,
    Map<String, dynamic>? requestBody,
    required dio_dart.Dio dioInstance,
    required TeCNetworkRequestCompletionCallback requestCompletionCallback,
    required bool showRawLogs,
    required TeCNetworkRequestMethodType networkRequestMethodType,
  });

  Future<void> processGetRequest<T>({
    required String baseURL,
    required Function() onAuthorizationFailedCallback,

    T Function(Map<String, dynamic>)? responseParserCallback,
    required String apiEndPoint,
    Map<String, dynamic>? requestBody,
    required dio_dart.Dio dioInstance,
    required TeCNetworkRequestCompletionCallback requestCompletionCallback,
    required bool showRawLogs,
    required TeCNetworkRequestMethodType networkRequestMethodType,
  });

  Future<void> processUploadRequest<T>({
    required String baseURL,
    required Function() onAuthorizationFailedCallback,

    T Function(Map<String, dynamic>)? responseParserCallback,
    required String apiEndPoint,
    required dio_dart.Dio dioInstance,
    dio_dart.FormData? formData,
    required TeCNetworkRequestCompletionCallback requestCompletionCallback,
    required bool showRawLogs,
    required TeCNetworkRequestMethodType networkRequestMethodType,
  });

  bool isValidResponseJson(dio_dart.Response responseFromServer);

  TeCNetworkRequestCompletionHelperModel onRequestCompletionGetHelperModel<T>({
    required dio_dart.Response responseFromServer,
    T Function(Map<String, dynamic>)? responseParserCallback,
    required Function() onAuthorizationFailedCallback,
  });
}
