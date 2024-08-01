import 'package:network_utils_pack/network/util/imports_util.dart';

class NetworkLayerException implements Exception {
  String cause;

  NetworkLayerException({required this.cause});
}

class NetworkLayerErrorException implements Exception {
  RequestCompletionHelperModel? failure;

  NetworkLayerErrorException.handle(dynamic error) {
    if (error is DioException) {
      // dio error so its an error from response of the API or from dio itself
      failure = _handleError(error);
    } else {
      // default error
      failure = RequestCompletionStatusEnums.unknownStatus
          .getRequestCompletionHelperModel();
    }
  }

  RequestCompletionHelperModel? _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return RequestCompletionStatusEnums.connectTimeOut
            .getRequestCompletionHelperModel();
      case DioExceptionType.sendTimeout:
        return RequestCompletionStatusEnums.sendTimeOut
            .getRequestCompletionHelperModel();
      case DioExceptionType.receiveTimeout:
        return RequestCompletionStatusEnums.receiveTimeOut
            .getRequestCompletionHelperModel();
      case DioExceptionType.cancel:
        return RequestCompletionStatusEnums.cancel
            .getRequestCompletionHelperModel();
      case DioExceptionType.badCertificate:
        return RequestCompletionStatusEnums.badCertificate
            .getRequestCompletionHelperModel();
      case DioExceptionType.badResponse:
        return RequestCompletionStatusEnums.badResponse
            .getRequestCompletionHelperModel();
      case DioExceptionType.connectionError:
        return RequestCompletionStatusEnums.connectionError
            .getRequestCompletionHelperModel();
      default:
        return RequestCompletionStatusEnums.unknownStatus
            .getRequestCompletionHelperModel();
    }
  }
}
