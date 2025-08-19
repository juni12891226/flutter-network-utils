import 'package:dio/dio.dart' as dio_dart;
import 'package:flutter/material.dart';
import 'package:sudani_network_layer/utils/imports/tec_network_layer_imports_util.dart';
import 'package:sudani_network_layer/utils/log/debug_util.dart';

class TeCNetworkManager implements TeCNetworkRequest {
  ///Main caller method for requesting Dio APIs
  ///[requestCompletionCallback] is required
  ///[requestMethodType] is required, ENUMs -> for specifying the API method type
  ///[baseURL] is required, the Base URL pointing to the server
  ///[apiEndPoint] is required, the path of the API endpoint
  ///[requestHeaders] is optional
  ///[requestBody] is optional
  ///[connectTimeoutSecs] is optional, default is 30 Seconds
  ///[sendTimeoutSecs] is optional, default is 30 Seconds
  ///[receiveTimeoutSecs] is optional, default is 30 Seconds
  ///[dioInterceptors] is optional, is a list of Interceptors you want to add any of your own Interceptor
  ///[showRawLogs] is optional, default is set to false, to show the Dio Network Layer logs
  ///[responseParserCallback] is optional and can be used to get the response parsed model through the JSON
  ///Usage for [responseParserCallback] is that you have to pass it as:
  ///responseParserCallback: YourPojoModel.fromJson
  ///and then in API calling method:
  ///YourPojoModel object=requestCompletionHelperModel.responseObject
  ///and access the required property from **object**

  Future<void> requestDioAPI<T>({
    required BuildContext context,
    required TeCNetworkRequestCompletionCallback requestCompletionCallback,
    required TeCNetworkRequestMethodType requestMethodType,
    required String baseURL,
    required String apiEndPoint,
    Map<String, dynamic>? requestHeaders,
    Map<String, dynamic>? requestBody,
    Map<String, dynamic>? queryParameters,
    dio_dart.FormData? formData,
    int apiTimeoutInSecsFromConsumerSide = 60,
    bool useConsumerSideAPITimeout = false,
    List<dio_dart.Interceptor>? dioInterceptors,
    required Function() onAuthorizationFailedCallback,
    T Function(Map<String, dynamic>)? responseParserCallback,
    bool showRawLogs = false,
    bool showSSLPiningKeyInLogs = false,
  }) async {
    int appNetworkLayerTimeoutInSeconds =
        TeCDMPNetworkConstants.instance.appNetworkLayerTimeoutInSeconds;
    NetworkDebugUtils.debugLog(
      "DMP-Revamp-App-07-08-2025 TimeOutSecs:::$appNetworkLayerTimeoutInSeconds",
      logLevel: LogLevel.info,
    );

    ///get the network client from the util
    dio_dart.Dio dio = TeCNetworkClientHelperUtil.instance.getClient(
      showSSLPiningKeyInLogs: showSSLPiningKeyInLogs,
      baseURL: baseURL,
      showRawLogs: showRawLogs,
      connectTimeoutSecs:
          useConsumerSideAPITimeout
              ? apiTimeoutInSecsFromConsumerSide
              : appNetworkLayerTimeoutInSeconds,
      receiveTimeoutSecs:
          useConsumerSideAPITimeout
              ? apiTimeoutInSecsFromConsumerSide
              : appNetworkLayerTimeoutInSeconds,
      sendTimeoutSecs:
          useConsumerSideAPITimeout
              ? apiTimeoutInSecsFromConsumerSide
              : appNetworkLayerTimeoutInSeconds,
      requestCompletionCallback: requestCompletionCallback,
      apiEndPoint: apiEndPoint,
      requestHeaders: requestHeaders ?? {},
      requestMethod: requestMethodType,
      dioInterceptors: dioInterceptors,
    );

    if (requestMethodType == TeCNetworkRequestMethodType.upload) {
      if (formData == null) {
        throw Exception(
          "Please post the request with the form data required for the Upload Request!",
        );
      }
    }

    TeCNetworkConnectionManagerHelperUtil.instance.isNetworkAvailable().then((
      bool isNetworkAvailable,
    ) async {
      if (isNetworkAvailable) {
        if (requestMethodType == TeCNetworkRequestMethodType.post) {
          processPostRequest(
            onAuthorizationFailedCallback: onAuthorizationFailedCallback,
            queryParameters: queryParameters,
            showRawLogs: showRawLogs,
            baseURL: baseURL,
            apiEndPoint: apiEndPoint,
            requestBody: requestBody,
            dioInstance: dio,
            responseParserCallback: responseParserCallback,
            requestCompletionCallback: requestCompletionCallback,
            networkRequestMethodType: requestMethodType,
          );
        } else if (requestMethodType == TeCNetworkRequestMethodType.get) {
          processGetRequest(
            onAuthorizationFailedCallback: onAuthorizationFailedCallback,

            queryParameters: queryParameters,
            showRawLogs: showRawLogs,
            baseURL: baseURL,
            apiEndPoint: apiEndPoint,
            requestBody: requestBody,
            dioInstance: dio,
            responseParserCallback: responseParserCallback,
            requestCompletionCallback: requestCompletionCallback,
            networkRequestMethodType: requestMethodType,
          );
        } else if (requestMethodType == TeCNetworkRequestMethodType.upload) {
          processUploadRequest(
            onAuthorizationFailedCallback: onAuthorizationFailedCallback,

            formData: formData,
            showRawLogs: showRawLogs,
            baseURL: baseURL,
            apiEndPoint: apiEndPoint,
            dioInstance: dio,
            responseParserCallback: responseParserCallback,
            requestCompletionCallback: requestCompletionCallback,
            networkRequestMethodType: requestMethodType,
          );
        }
      } else {
        // _showToast(message: TeCLocalizationUtil.instance.localized("internetConnectionNotAvailable", screenName: "default"));
        //no network
        requestCompletionCallback(
          TeCNetworkRequestCompletionHelperModel(
            status: TeCNetworkLayerConstants.noInternetConnection,
            reasonFromDIOLayer: "No Internet Connection Available!",
            isSuccess: false,
            responseCompletionStatus:
                TeCRequestCompletionStatusEnums.noInternetConnection,
          ),
        );
      }
    });
  }

  // void _showToast({required String message, ToastGravity toastGravity = ToastGravity.BOTTOM}) {
  //   Fluttertoast.showToast(
  //     msg: message,
  //     toastLength: Toast.LENGTH_LONG,
  //     gravity: toastGravity,
  //     timeInSecForIosWeb: 1,
  //     backgroundColor: tecAppUtilInjector<ThemeUtil>().getThemeColor(
  //       className: "default",
  //       colorKeyName: "toastBgColor",
  //     ),
  //     textColor: tecAppUtilInjector<ThemeUtil>().getThemeColor(
  //       className: "default",
  //       colorKeyName: "toastMessageTextColor",
  //     ),
  //     fontSize: tecAppUtilInjector<AppSizeDimensUtil>().getDimenForFonts(givenDimen: 14),
  //   );
  // }

  ///When the server responds, that is when the request completes (success | failure)
  ///Checks the status code from the server response
  ///Checks the server response if valid or not that is if valid JSON and is mappable
  ///[responseFromServer] is required
  ///[createModelClassCallback] is optional, if provided will return as:
  ///APIObjectTypeResponse<T> or
  ///APIListTypeResponse<T>
  ///Where T is your supplied type for your model
  @override
  TeCNetworkRequestCompletionHelperModel onRequestCompletionGetHelperModel<T>({
    required dio_dart.Response responseFromServer,
    T Function(Map<String, dynamic>)? responseParserCallback,
    required Function() onAuthorizationFailedCallback,
  }) {
    int statusCodeFromServer =
        responseFromServer.statusCode ??
        TeCNetworkLayerConstants.defaultInCaseOfNull;

    if (statusCodeFromServer == TeCNetworkLayerConstants.success) {
      if (isValidResponseJson(responseFromServer)) {
        if (TeCNetworkUtil.instance.getStatusCodeInsideJsonFromServer(
              jsonEncode(responseFromServer.data),
            ) ==
            "401") {
          onAuthorizationFailedCallback();
        }
        //success
        return TeCNetworkRequestCompletionHelperModel(
          responseObject:
              responseParserCallback != null
                  ? TeCResponseParser.parseJson(
                    jsonEncode(responseFromServer.data),
                    responseParserCallback,
                  )
                  : null,
          status: TeCNetworkLayerConstants.success,
          reasonFromServer:
              isValidResponseJson(responseFromServer)
                  ? TeCNetworkUtil.instance.getReasonFromServer(
                    jsonEncode(responseFromServer.data),
                  )
                  : null,
          requestResponse: jsonEncode(responseFromServer.data),
          reasonFromDIOLayer: "Success (200).",
          responseCompletionStatus: TeCRequestCompletionStatusEnums.success,
          isSuccess: true,
        );
      } else {
        //request response in invalid, null or empty or json has errors
        return TeCNetworkRequestCompletionHelperModel(
          status: TeCNetworkLayerConstants.responseNotValid,
          reasonFromDIOLayer: "Request response is not valid.",
          responseCompletionStatus:
              TeCRequestCompletionStatusEnums.requestResponseInValid,
          isSuccess: false,
        );
      }
    } else if (statusCodeFromServer == TeCNetworkLayerConstants.badRequest) {
      return TeCNetworkRequestCompletionHelperModel(
        reasonFromServer:
            isValidResponseJson(responseFromServer)
                ? TeCNetworkUtil.instance.getReasonFromServer(
                  jsonEncode(responseFromServer.data),
                )
                : null,
        status: TeCNetworkLayerConstants.badRequest,
        reasonFromDIOLayer: "Bad Request (400).",
        responseCompletionStatus: TeCRequestCompletionStatusEnums.badRequest,
        isSuccess: false,
      );
    } else if (statusCodeFromServer == TeCNetworkLayerConstants.noContent) {
      return TeCNetworkRequestCompletionHelperModel(
        reasonFromServer:
            isValidResponseJson(responseFromServer)
                ? TeCNetworkUtil.instance.getReasonFromServer(
                  jsonEncode(responseFromServer.data),
                )
                : null,
        status: TeCNetworkLayerConstants.noContent,
        reasonFromDIOLayer: "No content (201).",
        responseCompletionStatus: TeCRequestCompletionStatusEnums.noContent,
        isSuccess: false,
      );
    } else if (statusCodeFromServer == TeCNetworkLayerConstants.unAuthorised) {
      return TeCNetworkRequestCompletionHelperModel(
        reasonFromServer:
            isValidResponseJson(responseFromServer)
                ? TeCNetworkUtil.instance.getReasonFromServer(
                  jsonEncode(responseFromServer.data),
                )
                : null,
        status: TeCNetworkLayerConstants.unAuthorised,
        reasonFromDIOLayer: "UnAuthorised (401).",
        responseCompletionStatus: TeCRequestCompletionStatusEnums.unAuthorised,
        isSuccess: false,
      );
    } else if (statusCodeFromServer == TeCNetworkLayerConstants.forbidden) {
      return TeCNetworkRequestCompletionHelperModel(
        reasonFromServer:
            isValidResponseJson(responseFromServer)
                ? TeCNetworkUtil.instance.getReasonFromServer(
                  jsonEncode(responseFromServer.data),
                )
                : null,
        status: TeCNetworkLayerConstants.forbidden,
        reasonFromDIOLayer: "Forbidden (403).",
        responseCompletionStatus: TeCRequestCompletionStatusEnums.forbidden,
        isSuccess: false,
      );
    } else if (statusCodeFromServer ==
        TeCNetworkLayerConstants.internalServerError) {
      return TeCNetworkRequestCompletionHelperModel(
        reasonFromServer:
            isValidResponseJson(responseFromServer)
                ? TeCNetworkUtil.instance.getReasonFromServer(
                  jsonEncode(responseFromServer.data),
                )
                : null,
        status: TeCNetworkLayerConstants.internalServerError,
        reasonFromDIOLayer: "Internal Server Error (500).",
        responseCompletionStatus:
            TeCRequestCompletionStatusEnums.internalServerError,
        isSuccess: false,
      );
    } else if (statusCodeFromServer == TeCNetworkLayerConstants.notFound) {
      return TeCNetworkRequestCompletionHelperModel(
        reasonFromServer:
            isValidResponseJson(responseFromServer)
                ? TeCNetworkUtil.instance.getReasonFromServer(
                  jsonEncode(responseFromServer.data),
                )
                : null,
        status: TeCNetworkLayerConstants.notFound,
        reasonFromDIOLayer: "Not found (404).",
        responseCompletionStatus: TeCRequestCompletionStatusEnums.notFound,
        isSuccess: false,
      );
    } else {
      //unknown result code
      return TeCNetworkRequestCompletionHelperModel(
        reasonFromServer:
            isValidResponseJson(responseFromServer)
                ? TeCNetworkUtil.instance.getReasonFromServer(
                  jsonEncode(responseFromServer.data),
                )
                : null,
        status: TeCNetworkLayerConstants.unknown,
        reasonFromDIOLayer: "Unknown status code from server.",
        responseCompletionStatus: TeCRequestCompletionStatusEnums.unknownStatus,
        isSuccess: false,
      );
    }
  }

  ///Validate the response from the server
  ///If the response returned from server is a valid JSON and is mappable
  ///[responseFromServer] is required param, the Dio Response
  @override
  bool isValidResponseJson(dio_dart.Response responseFromServer) {
    if (responseFromServer.data != null) {
      //decoding the string to json
      dynamic json = jsonDecode(jsonEncode(responseFromServer.data));
      if (json != null && json is Map) {
        return true;
      } else {
        return false;
      }
    } else {
      return false;
    }
  }

  ///method for calling POST type APIs
  ///MAY or MAY NOT include the request body
  ///[baseURL] is required, only using in Raw logs
  ///[apiEndPoint] is required
  ///[dioInstance] is required
  ///[requestCompletionCallback] is required for the API complete callback
  ///[showRawLogs] is optional, to show the Dio network layer logs
  ///[requestBody] is optional for POST request
  ///[createModelClassCallback] is optional, if provided will return as:
  ///APIObjectTypeResponse<T> or
  ///APIListTypeResponse<T>
  ///Where T is your supplied type for your model
  @override
  Future<void> processPostRequest<T>({
    required String baseURL,
    T Function(Map<String, dynamic>)? responseParserCallback,
    required Function() onAuthorizationFailedCallback,
    required String apiEndPoint,
    required dio_dart.Dio dioInstance,
    required TeCNetworkRequestCompletionCallback requestCompletionCallback,
    required TeCNetworkRequestMethodType networkRequestMethodType,
    Map<String, dynamic>? requestBody,
    Map<String, dynamic>? queryParameters,
    bool showRawLogs = false,
  }) async {
    try {
      var requestStopWatchTimer = Stopwatch();
      requestStopWatchTimer.start();
      await dioInstance
          .post(
            apiEndPoint,
            data: requestBody ?? {},
            queryParameters: queryParameters ?? {},
          )
          .then((dio_dart.Response responseFromServer) {
            var elapsedTimeDuration = requestStopWatchTimer.elapsed.toString();
            requestStopWatchTimer.stop();

            //process the response validation
            var model = onRequestCompletionGetHelperModel(
              responseFromServer: responseFromServer,
              responseParserCallback: responseParserCallback,
              onAuthorizationFailedCallback: onAuthorizationFailedCallback,
            );

            // if (model.status == 401 &&
            //     getPreferencesDataHolderManagerUtil.getLoginResponseModel() !=
            //         null &&
            //     !getPreferencesManagerUtil.getBoolValue(
            //         getPreferencesKeys.biometricAuthentication, false)) {
            //   getAppUtil.performUserLogout(showSessionTimeOutPopup: true);
            // } else {
            requestCompletionCallback(model);
            //show the time taken by the API call
            TeCNetworkUtil.instance.showLog(
              showRawLogs: showRawLogs,
              networkRequestMethodType: networkRequestMethodType,
              "URL:::$apiEndPoint RawResponseFromServer:::${jsonEncode(responseFromServer.data)}\nelapsedTimeDuration:::$elapsedTimeDuration",
            );
            // }
          });
    } on dio_dart.DioException catch (dioException) {
      TeCNetworkUtil.instance.showLog(
        showRawLogs: showRawLogs,
        networkRequestMethodType: networkRequestMethodType,
        "URL:::$apiEndPoint RawExceptionFromDio:::${dioException.error}",
      );
      requestCompletionCallback(
        (TeCNetworkLayerErrorException.handle(dioException).failure) ??
            TeCNetworkRequestCompletionHelperModel(
              status: TeCNetworkLayerConstants.dioNetworkLayerException,
              reasonFromDIOLayer: "DioException has been thrown!",
              isSuccess: false,
              responseCompletionStatus:
                  TeCRequestCompletionStatusEnums.unknownStatus,
            ),
      );
    }
  }

  @override
  Future<void> processGetRequest<T>({
    required String baseURL,
    required String apiEndPoint,
    required Function() onAuthorizationFailedCallback,

    T Function(Map<String, dynamic>)? responseParserCallback,
    required dio_dart.Dio dioInstance,
    required TeCNetworkRequestCompletionCallback requestCompletionCallback,
    required TeCNetworkRequestMethodType networkRequestMethodType,
    Map<String, dynamic>? requestBody,
    Map<String, dynamic>? queryParameters,
    bool showRawLogs = false,
  }) async {
    try {
      var requestStopWatchTimer = Stopwatch();
      requestStopWatchTimer.start();
      await dioInstance
          .get(
            apiEndPoint,
            data: requestBody ?? {},
            queryParameters: queryParameters ?? {},
          )
          .then((dio_dart.Response responseFromServer) {
            var elapsedTimeDuration = requestStopWatchTimer.elapsed.toString();
            requestStopWatchTimer.stop();

            //process the response validation
            var model = onRequestCompletionGetHelperModel(
              responseFromServer: responseFromServer,
              responseParserCallback: responseParserCallback,
              onAuthorizationFailedCallback: onAuthorizationFailedCallback,
            );

            // if (model.status == 401 &&
            //     getPreferencesDataHolderManagerUtil.getLoginResponseModel() !=
            //         null &&
            //     !getPreferencesManagerUtil.getBoolValue(
            //         getPreferencesKeys.biometricAuthentication, false)) {
            //   getAppUtil.performUserLogout(showSessionTimeOutPopup: true);
            // } else {
            requestCompletionCallback(model);
            //show the time taken by the API call
            TeCNetworkUtil.instance.showLog(
              showRawLogs: showRawLogs,
              networkRequestMethodType: networkRequestMethodType,
              "URL:::$apiEndPoint RawResponseFromServer:::${jsonEncode(responseFromServer.data)}\nelapsedTimeDuration:::$elapsedTimeDuration",
            );
            // }
          });
    } on dio_dart.DioException catch (dioException) {
      TeCNetworkUtil.instance.showLog(
        showRawLogs: showRawLogs,
        networkRequestMethodType: networkRequestMethodType,
        "URL:::$apiEndPoint RawExceptionFromDio:::${dioException.error}",
      );
      requestCompletionCallback(
        (TeCNetworkLayerErrorException.handle(dioException).failure) ??
            TeCNetworkRequestCompletionHelperModel(
              status: TeCNetworkLayerConstants.dioNetworkLayerException,
              reasonFromDIOLayer: "DioException has been thrown!",
              isSuccess: false,
              responseCompletionStatus:
                  TeCRequestCompletionStatusEnums.unknownStatus,
            ),
      );
    }
  }

  @override
  Future<void> processUploadRequest<T>({
    required String baseURL,
    T Function(Map<String, dynamic>)? responseParserCallback,
    required String apiEndPoint,
    required Function() onAuthorizationFailedCallback,

    required dio_dart.Dio dioInstance,
    required TeCNetworkRequestCompletionCallback requestCompletionCallback,
    required TeCNetworkRequestMethodType networkRequestMethodType,
    dio_dart.FormData? formData,
    bool showRawLogs = false,
  }) async {
    try {
      var requestStopWatchTimer = Stopwatch();
      requestStopWatchTimer.start();
      await dioInstance.post(apiEndPoint, data: formData ?? {}).then((
        dio_dart.Response responseFromServer,
      ) {
        var elapsedTimeDuration = requestStopWatchTimer.elapsed.toString();
        requestStopWatchTimer.stop();

        //process the response validation
        var model = onRequestCompletionGetHelperModel(
          responseFromServer: responseFromServer,
          responseParserCallback: responseParserCallback,
          onAuthorizationFailedCallback: onAuthorizationFailedCallback,
        );

        // if (model.status == 401 &&
        //     getPreferencesDataHolderManagerUtil.getLoginResponseModel() !=
        //         null &&
        //     !getPreferencesManagerUtil.getBoolValue(
        //         getPreferencesKeys.biometricAuthentication, false)) {
        //   getAppUtil.performUserLogout(showSessionTimeOutPopup: true);
        // } else {
        requestCompletionCallback(model);
        //show the time taken by the API call
        TeCNetworkUtil.instance.showLog(
          showRawLogs: showRawLogs,
          networkRequestMethodType: networkRequestMethodType,
          "URL:::$apiEndPoint RawResponseFromServer:::${jsonEncode(responseFromServer.data)}\nelapsedTimeDuration:::$elapsedTimeDuration",
        );
        // }
      });
    } on dio_dart.DioException catch (dioException) {
      TeCNetworkUtil.instance.showLog(
        showRawLogs: showRawLogs,
        networkRequestMethodType: networkRequestMethodType,
        "URL:::$apiEndPoint RawExceptionFromDio:::${dioException.error}",
      );
      requestCompletionCallback(
        (TeCNetworkLayerErrorException.handle(dioException).failure) ??
            TeCNetworkRequestCompletionHelperModel(
              status: TeCNetworkLayerConstants.dioNetworkLayerException,
              reasonFromDIOLayer: "DioException has been thrown!",
              isSuccess: false,
              responseCompletionStatus:
                  TeCRequestCompletionStatusEnums.unknownStatus,
            ),
      );
    }
  }
}
