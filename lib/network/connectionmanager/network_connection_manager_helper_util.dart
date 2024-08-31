import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:network_utils_pack/network/util/imports_util.dart';

class NetworkConnectionManagerHelperUtil {
  /// private constructor
  NetworkConnectionManagerHelperUtil._();

  /// the one and only instance of this singleton
  static final instance = NetworkConnectionManagerHelperUtil._();

  ///To check if the network connection is available
  Future<bool> isNetworkAvailable() async {
    if(kIsWeb){
      return await _webHasInternet();
    }else{
      return await _mobileHasInternet();
    }
  }

  Future<bool> _mobileHasInternet()async{
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
      if(result.statusCode==200){
        return true;
      }
      else{
        return false;
      }
    }
    on SocketException catch (_) {
      return false;
    }
  }
}
