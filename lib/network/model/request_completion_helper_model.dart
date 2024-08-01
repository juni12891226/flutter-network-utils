import 'package:network_utils_pack/network/util/imports_util.dart';

class RequestCompletionHelperModel<T> {
  String? requestResponse;
  bool isSuccess;
  RequestCompletionStatusEnums responseCompletionStatus;
  String? reason;
  T? responseWrapper;

  RequestCompletionHelperModel(
      {this.responseWrapper,
      this.reason,
      this.requestResponse,
      required this.isSuccess,
      required this.responseCompletionStatus});
}
