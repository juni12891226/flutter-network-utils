import 'package:sudani_network_layer/utils/imports/tec_network_layer_imports_util.dart';

class TeCNetworkLayerException implements Exception {
  String cause;

  TeCNetworkLayerException({required this.cause});
}

class TeCNetworkLayerErrorException implements Exception {
  TeCNetworkRequestCompletionHelperModel? failure;

  TeCNetworkLayerErrorException.handle(dynamic error) {
    if (error is DioException) {
      // dio error so its an error from response of the API or from dio itself
      failure = _handleError(error);
    } else {
      // default error
      failure =
          TeCRequestCompletionStatusEnums.unknownStatus
              .getRequestCompletionHelperModel();
    }
  }

  TeCNetworkRequestCompletionHelperModel? _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
        return TeCRequestCompletionStatusEnums.connectTimeOut
            .getRequestCompletionHelperModel();
      case DioExceptionType.sendTimeout:
        return TeCRequestCompletionStatusEnums.sendTimeOut
            .getRequestCompletionHelperModel();
      case DioExceptionType.receiveTimeout:
        return TeCRequestCompletionStatusEnums.receiveTimeOut
            .getRequestCompletionHelperModel();
      case DioExceptionType.cancel:
        return TeCRequestCompletionStatusEnums.cancel
            .getRequestCompletionHelperModel();
      case DioExceptionType.badCertificate:
        return TeCRequestCompletionStatusEnums.badCertificate
            .getRequestCompletionHelperModel();
      case DioExceptionType.badResponse:
        return TeCRequestCompletionStatusEnums.badResponse
            .getRequestCompletionHelperModel();
      case DioExceptionType.connectionError:
        return TeCRequestCompletionStatusEnums.connectionError
            .getRequestCompletionHelperModel();
      default:
        return TeCRequestCompletionStatusEnums.unknownStatus
            .getRequestCompletionHelperModel();
    }
  }
}
