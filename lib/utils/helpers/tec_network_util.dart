import 'package:sudani_network_layer/utils/imports/tec_network_layer_imports_util.dart';
import 'package:sudani_network_layer/utils/log/debug_util.dart';

class TeCNetworkUtil {
  /// private constructor
  TeCNetworkUtil._();

  /// the one and only instance of this singleton
  static final instance = TeCNetworkUtil._();

  ///convert the string to the json
  dynamic getDecodedJSON({required String responseBody}) {
    return json.decode(responseBody);
  }

  ///convert the json to the string
  String getEncodedJSONString({required dynamic toEncode}) {
    return json.encode(toEncode);
  }

  void showLog(
    String logData, {
    required bool showRawLogs,
    required TeCNetworkRequestMethodType networkRequestMethodType,
  }) {
    if (showRawLogs) {
      var networkRequestMethodTypeString = networkRequestMethodType.toString();
      NetworkDebugUtils.debugLog(
        "netWork-Utils_X:::\n{$networkRequestMethodTypeString} Request Logs Starts:::\n$logData\n Logs ends",
        logLevel: LogLevel.debug,
      );
    }
  }

  String? getReasonFromServer(String json) {
    var parsedJson = jsonDecode(json);
    // Access the value by key
    return parsedJson['responseMessage'];
  }

  String? getStatusCodeInsideJsonFromServer(String json) {
    var parsedJson = jsonDecode(json);
    // Access the value by key
    return parsedJson['responseCode'];
  }
}
