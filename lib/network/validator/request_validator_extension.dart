import 'package:network_utils_pack/network/util/imports_util.dart';

extension RequestValidatorExtension on RequestCompletionStatusEnums {
  RequestCompletionHelperModel? getRequestCompletionHelperModel() {
    switch (this) {
      case RequestCompletionStatusEnums.badCertificate:
        return RequestCompletionHelperModel(
            status: NetworkLayerConstants.badCertificate,
            reasonFromDIOLayer: "Bad Certificate. (Dio)",
            isSuccess: false,
            responseCompletionStatus: RequestCompletionStatusEnums.badCertificate);
      case RequestCompletionStatusEnums.badResponse:
        return RequestCompletionHelperModel(
            status: NetworkLayerConstants.responseNotValid,
            reasonFromDIOLayer: "Bad Response. (Dio)",
            isSuccess: false,
            responseCompletionStatus: RequestCompletionStatusEnums.badResponse);
      case RequestCompletionStatusEnums.connectTimeOut:
        return RequestCompletionHelperModel(
            status: NetworkLayerConstants.connectionTimeout,
            reasonFromDIOLayer: "Connection Timeout. (Dio)",
            isSuccess: false,
            responseCompletionStatus: RequestCompletionStatusEnums.connectTimeOut);
      case RequestCompletionStatusEnums.cancel:
        return RequestCompletionHelperModel(
            status: NetworkLayerConstants.requestCancelled,
            reasonFromDIOLayer: "Request Cancelled. (Dio)",
            isSuccess: false,
            responseCompletionStatus: RequestCompletionStatusEnums.cancel);
      case RequestCompletionStatusEnums.receiveTimeOut:
        return RequestCompletionHelperModel(
            status: NetworkLayerConstants.receiveTimeout,
            reasonFromDIOLayer: "Receive Timeout. (Dio)",
            isSuccess: false,
            responseCompletionStatus: RequestCompletionStatusEnums.receiveTimeOut);
      case RequestCompletionStatusEnums.sendTimeOut:
        return RequestCompletionHelperModel(
            status: NetworkLayerConstants.sendTimeout, reasonFromDIOLayer: "Send Timeout. (Dio)", isSuccess: false, responseCompletionStatus: RequestCompletionStatusEnums.sendTimeOut);
      case RequestCompletionStatusEnums.connectionError:
        return RequestCompletionHelperModel(
            status: NetworkLayerConstants.connectionError,
            reasonFromDIOLayer: "Connection Error. (Dio)",
            isSuccess: false,
            responseCompletionStatus: RequestCompletionStatusEnums.connectionError);
      default:
        return RequestCompletionHelperModel(
            status: NetworkLayerConstants.unknown,
            reasonFromDIOLayer: "Unknown Dio Exception. (Dio)",
            isSuccess: false,
            responseCompletionStatus: RequestCompletionStatusEnums.unknownStatus);
    }
  }
}
