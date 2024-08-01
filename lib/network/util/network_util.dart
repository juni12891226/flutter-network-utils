import 'dart:convert';

import 'package:flutter/material.dart';

class NetworkUtil {
  /// private constructor
  NetworkUtil._();

  /// the one and only instance of this singleton
  static final instance = NetworkUtil._();

  ///convert the string to the json
  dynamic getDecodedJSON({required String responseBody}) {
    return json.decode(responseBody);
  }

  ///convert the json to the string
  String getEncodedJSONString({required dynamic toEncode}) {
    return json.encode(toEncode);
  }

  ///To show the log
  ///[logData] is required, to be used for printing the logs
  ///[logKey] is optional and can be used as a unique random string to find the logs
  ///[isReleaseMode] is optional and default is false, if you want to only show the logs for release build
  ///[usePrint] is optional and if true, the print will be used else debugPrint
  ///You can use the [usePrint] if you want to show the logs in the pre-released build for your own logs
  ///But using print is highly not recommended!
  ///Signature ==> void showLog(String logData, {bool? isReleaseMode, String? logKey, bool? usePrint})
  void showLog(String logData) {
    debugPrint("netWork-Utils_X:::\nCDP Logs Starts:::\n$logData\nCDP Logs ends");
  }

  ///Hide the keyboard UX point
  ///That is when the user tries to start/perform an action
  ///Signature ==> void hideKeyboard()
  void hideKeyboard() {
    FocusManager.instance.primaryFocus?.unfocus();
  }
}
