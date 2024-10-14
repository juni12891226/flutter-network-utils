import 'package:network_utils_pack/network/util/imports_util.dart';

class RequestCompletionHelperModel<T> {
  String? requestResponse;
  bool isSuccess;
  RequestCompletionStatusEnums responseCompletionStatus;
  String? reasonFromDIOLayer;
  String? reasonFromServer;
  T? responseWrapper;
  int status;

  RequestCompletionHelperModel(
      {this.responseWrapper,
      this.reasonFromDIOLayer,
      this.requestResponse,
      required this.isSuccess,
      this.reasonFromServer,
      required this.status,
      required this.responseCompletionStatus});
}
