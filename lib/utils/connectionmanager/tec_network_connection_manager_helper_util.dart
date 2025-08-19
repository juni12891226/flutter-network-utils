import 'package:http/http.dart' as http;
import 'package:sudani_network_layer/utils/imports/tec_network_layer_imports_util.dart';

class TeCNetworkConnectionManagerHelperUtil {
  /// private constructor
  TeCNetworkConnectionManagerHelperUtil._();

  /// the one and only instance of this singleton
  static final instance = TeCNetworkConnectionManagerHelperUtil._();

  ///To check if the network connection is available
  Future<bool> isNetworkAvailable() async {
    if (kIsWeb) {
      return await _webHasInternet();
    } else {
      return await _mobileHasInternet();
    }
  }

  Future<bool> _mobileHasInternet() async {
    bool isNetworkAvailable = await InternetConnectionChecker().hasConnection;
    if (isNetworkAvailable) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> _webHasInternet() async {
    try {
      final result = await http.get(Uri.parse('www.google.com'));
      if (result.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } on SocketException catch (_) {
      return false;
    }
  }
}
