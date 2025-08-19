import 'package:sudani_network_layer/utils/imports/tec_network_layer_imports_util.dart';

class TeCNetworkRequestCompletionHelperModel<T> {
  String? requestResponse;
  bool isSuccess;
  TeCRequestCompletionStatusEnums responseCompletionStatus;
  String? reasonFromDIOLayer;
  String? reasonFromServer;
  int status;
  T? responseObject;

  TeCNetworkRequestCompletionHelperModel({
    this.reasonFromDIOLayer,
    this.responseObject,
    this.requestResponse,
    required this.isSuccess,
    this.reasonFromServer,
    required this.status,
    required this.responseCompletionStatus,
  });
}
