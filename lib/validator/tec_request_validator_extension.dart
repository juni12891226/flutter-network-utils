import 'package:sudani_network_layer/utils/imports/tec_network_layer_imports_util.dart';

extension TeCRequestValidatorExtension on TeCRequestCompletionStatusEnums {
  TeCNetworkRequestCompletionHelperModel? getRequestCompletionHelperModel() {
    switch (this) {
      case TeCRequestCompletionStatusEnums.badCertificate:
        return TeCNetworkRequestCompletionHelperModel(
          status: TeCNetworkLayerConstants.badCertificate,
          reasonFromDIOLayer: "Bad Certificate. (Dio)",
          isSuccess: false,
          responseCompletionStatus:
              TeCRequestCompletionStatusEnums.badCertificate,
        );
      case TeCRequestCompletionStatusEnums.badResponse:
        return TeCNetworkRequestCompletionHelperModel(
          status: TeCNetworkLayerConstants.responseNotValid,
          reasonFromDIOLayer: "Bad Response. (Dio)",
          isSuccess: false,
          responseCompletionStatus: TeCRequestCompletionStatusEnums.badResponse,
        );
      case TeCRequestCompletionStatusEnums.connectTimeOut:
        return TeCNetworkRequestCompletionHelperModel(
          status: TeCNetworkLayerConstants.connectionTimeout,
          reasonFromDIOLayer: "Connection Timeout. (Dio)",
          isSuccess: false,
          responseCompletionStatus:
              TeCRequestCompletionStatusEnums.connectTimeOut,
        );
      case TeCRequestCompletionStatusEnums.cancel:
        return TeCNetworkRequestCompletionHelperModel(
          status: TeCNetworkLayerConstants.requestCancelled,
          reasonFromDIOLayer: "Request Cancelled. (Dio)",
          isSuccess: false,
          responseCompletionStatus: TeCRequestCompletionStatusEnums.cancel,
        );
      case TeCRequestCompletionStatusEnums.receiveTimeOut:
        return TeCNetworkRequestCompletionHelperModel(
          status: TeCNetworkLayerConstants.receiveTimeout,
          reasonFromDIOLayer: "Receive Timeout. (Dio)",
          isSuccess: false,
          responseCompletionStatus:
              TeCRequestCompletionStatusEnums.receiveTimeOut,
        );
      case TeCRequestCompletionStatusEnums.sendTimeOut:
        return TeCNetworkRequestCompletionHelperModel(
          status: TeCNetworkLayerConstants.sendTimeout,
          reasonFromDIOLayer: "Send Timeout. (Dio)",
          isSuccess: false,
          responseCompletionStatus: TeCRequestCompletionStatusEnums.sendTimeOut,
        );
      case TeCRequestCompletionStatusEnums.connectionError:
        return TeCNetworkRequestCompletionHelperModel(
          status: TeCNetworkLayerConstants.connectionError,
          reasonFromDIOLayer: "Connection Error. (Dio)",
          isSuccess: false,
          responseCompletionStatus:
              TeCRequestCompletionStatusEnums.connectionError,
        );
      default:
        return TeCNetworkRequestCompletionHelperModel(
          status: TeCNetworkLayerConstants.unknown,
          reasonFromDIOLayer: "Unknown Dio Exception. (Dio)",
          isSuccess: false,
          responseCompletionStatus:
              TeCRequestCompletionStatusEnums.unknownStatus,
        );
    }
  }
}
