import 'package:network_utils_pack/network/util/imports_util.dart';

abstract class RequestValidatorHelperUtil {
  Future<void> processPostRequest<T extends Decodable>(
      {required String baseURL,
      required String apiEndPoint,
      Map<String, dynamic>? requestBody,
      required Dio dioInstance,
      required RequestCompletionCallback requestCompletionCallback,
      required bool showRawLogs,
      required NetworkRequestMethodType networkRequestMethodType});

  Future<void> processGetRequest<T extends Decodable>(
      {required String baseURL,
      required String apiEndPoint,
      Map<String, dynamic>? requestBody,
      required Dio dioInstance,
      required RequestCompletionCallback requestCompletionCallback,
      required bool showRawLogs,
      required NetworkRequestMethodType networkRequestMethodType});

  bool isValidResponseJson(Response responseFromServer);

  RequestCompletionHelperModel onRequestCompletionGetHelperModel<T extends Decodable>(
      {required Response responseFromServer, CreateModelClassCallback<T>? createModelClassCallback});
}
