import 'package:sudani_network_layer/utils/imports/tec_network_layer_imports_util.dart';

class TeCResponseParser {
  static T parseJson<T>(
    String jsonString,
    T Function(Map<String, dynamic>) fromJson,
  ) {
    final Map<String, dynamic> jsonMap = jsonDecode(jsonString);
    return fromJson(jsonMap);
  }
}
