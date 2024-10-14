import 'dart:convert';
import 'dart:io';

import 'package:network_utils_pack/network/util/imports_util.dart';

class NetworkManagerHelperUtil implements RequestValidatorHelperUtil {
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
  ///[isHideKeyboardOnAPICall] is optional, default is true, to hide the keyboard on each API call
  ///[createModelClassCallback] is optional and can be used to get the response parsed model though the JSON
  ///Usage for [createModelClassCallback] is that you have to pass it as:
  ///createModelClassCallback: () => APIObjectTypeResponse<MyModel>(create: () => MyModel()),
  ///then you can consume it as:
  ///APIObjectTypeResponse<MyModel> myModel=requestCompletionHelperModel.responseWrapper.response;
  ///then you can access its param properties as:
  ///myModel.myProperty
  Future<void> requestDioAPI<T extends Decodable>(
      {required RequestCompletionCallback requestCompletionCallback,
      required NetworkRequestMethodType requestMethodType,
      required String baseURL,
      required String apiEndPoint,
      Map<String, dynamic>? requestHeaders,
      Map<String, dynamic>? requestBody,
      Map<String, dynamic>? queryParameters,
      FormData? formData,
      int connectTimeoutSecs = 30,
      int sendTimeoutSecs = 30,
      int receiveTimeoutSecs = 30,
      bool isHideKeyboardOnAPICall = true,
      List<Interceptor>? dioInterceptors,
      bool showRawLogs = false,
      CreateModelClassCallback<T>? createModelClassCallback}) async {
    if (isHideKeyboardOnAPICall) {
      ///hide keyboard
      NetworkUtil.instance.hideKeyboard();
    }

    ///there are two levels of security
    ///1. SHA256 FingerPrints should match
    ///2. SHA256 Hash Security Keys should match -> optional and is based on an boolean var

    ///get the network client from the util
    ///provided with the allowed SHA256 FingerPrints
    ///the very first layer of the security over the network layer
    ///that is if the SHA256 Finger prints will match only
    ///then the API gets onto next level
    Dio dio = NetworkClientHelperUtil.instance.getClient(
        baseURL: baseURL,
        connectTimeoutSecs: connectTimeoutSecs,
        receiveTimeoutSecs: receiveTimeoutSecs,
        sendTimeoutSecs: sendTimeoutSecs,
        requestCompletionCallback: requestCompletionCallback,
        apiEndPoint: apiEndPoint,
        requestHeaders: requestHeaders ?? {},
        requestMethod: requestMethodType,
        dioInterceptors: dioInterceptors);

    if (requestMethodType == NetworkRequestMethodType.upload) {
      if (formData == null) {
        throw Exception("Please post the request with the form data required for the Upload Request!");
      }
    }

    // dio.httpClientAdapter = IOHttpClientAdapter(
    //     onHttpClientCreate: (_) {
    //       // Don't trust any certificate just because their root cert is trusted.
    //       final HttpClient client = HttpClient(context: SecurityContext(withTrustedRoots: false));
    //       // You can test the intermediate / root cert here. We just ignore it.
    //       client.badCertificateCallback = (cert, host, port) {
    //         return true;
    //       };
    //       return client;
    //     },
    //
    //     // validateCertificate: (cert, host, port) {
    //     //   // Check that the cert fingerprint matches the one we expect.
    //     //   // We definitely require _some_ certificate.
    //     //   if (cert == null) {
    //     //     return false;
    //     //   }
    //     //   // Validate it any way you want. Here we only check that
    //     //   // the fingerprint matches the OpenSSL SHA256.
    //     //   bool valid = "8af954997043f60f932f899ce5474b2c695e4ea434a91acb3f47e2c41c942c3e" == sha256.convert(cert.der).toString();
    //     //   return valid;
    //     // },
    //     );

    //check network here
    NetworkConnectionManagerHelperUtil.instance.isNetworkAvailable().then((bool isNetworkAvailable) async {
      if (isNetworkAvailable) {
        if (requestMethodType == NetworkRequestMethodType.post) {
          processPostRequest(
              queryParameters: queryParameters,
              showRawLogs: showRawLogs,
              baseURL: baseURL,
              apiEndPoint: apiEndPoint,
              requestBody: requestBody,
              dioInstance: dio,
              requestCompletionCallback: requestCompletionCallback,
              createModelClassCallback: createModelClassCallback,
              networkRequestMethodType: requestMethodType);
        } else if (requestMethodType == NetworkRequestMethodType.get) {
          processGetRequest(
              queryParameters: queryParameters,
              showRawLogs: showRawLogs,
              baseURL: baseURL,
              apiEndPoint: apiEndPoint,
              requestBody: requestBody,
              dioInstance: dio,
              requestCompletionCallback: requestCompletionCallback,
              createModelClassCallback: createModelClassCallback,
              networkRequestMethodType: requestMethodType);
        } else if (requestMethodType == NetworkRequestMethodType.upload) {
          processUploadRequest(
              formData: formData,
              showRawLogs: showRawLogs,
              baseURL: baseURL,
              apiEndPoint: apiEndPoint,
              dioInstance: dio,
              requestCompletionCallback: requestCompletionCallback,
              createModelClassCallback: createModelClassCallback,
              networkRequestMethodType: requestMethodType);
        }
      } else {
        //no network
        requestCompletionCallback(RequestCompletionHelperModel(
            status: NetworkLayerConstants.noInternetConnection,
            reasonFromDIOLayer: "No Internet Connection Available!",
            isSuccess: false,
            responseCompletionStatus: RequestCompletionStatusEnums.noInternetConnection));
      }
    });
  }

  ///When the server responds, that is when the request completes (success | failure)
  ///Checks the status code from the server response
  ///Checks the server response if valid or not that is if valid JSON and is mappable
  ///[responseFromServer] is required
  ///[createModelClassCallback] is optional, if provided will return as:
  ///APIObjectTypeResponse<T> or
  ///APIListTypeResponse<T>
  ///Where T is your supplied type for your model
  @override
  RequestCompletionHelperModel onRequestCompletionGetHelperModel<T extends Decodable>(
      {required Response responseFromServer, CreateModelClassCallback<T>? createModelClassCallback}) {
    int statusCodeFromServer = responseFromServer.statusCode ?? NetworkLayerConstants.defaultInCaseOfNull;
    if (statusCodeFromServer == NetworkLayerConstants.success) {
      if (isValidResponseJson(responseFromServer)) {
        //success
        return RequestCompletionHelperModel(
            status: NetworkLayerConstants.success,
            reasonFromServer: isValidResponseJson(responseFromServer) ? NetworkUtil.instance.getReasonFromServer(jsonEncode(responseFromServer.data)) : null,
            requestResponse: jsonEncode(responseFromServer.data),
            reasonFromDIOLayer: "Success (200).",
            responseCompletionStatus: RequestCompletionStatusEnums.success,
            isSuccess: true);
      } else {
        //request response in invalid, null or empty or json has errors
        return RequestCompletionHelperModel(
            status: NetworkLayerConstants.responseNotValid,
            reasonFromDIOLayer: "Request response is not valid.",
            responseCompletionStatus: RequestCompletionStatusEnums.requestResponseInValid,
            isSuccess: false);
      }
    } else if (statusCodeFromServer == NetworkLayerConstants.badRequest) {
      return RequestCompletionHelperModel(
          reasonFromServer: isValidResponseJson(responseFromServer) ? NetworkUtil.instance.getReasonFromServer(jsonEncode(responseFromServer.data)) : null,
          status: NetworkLayerConstants.badRequest,
          reasonFromDIOLayer: "Bad Request (400).",
          responseCompletionStatus: RequestCompletionStatusEnums.badRequest,
          isSuccess: false);
    } else if (statusCodeFromServer == NetworkLayerConstants.noContent) {
      return RequestCompletionHelperModel(
          reasonFromServer: isValidResponseJson(responseFromServer) ? NetworkUtil.instance.getReasonFromServer(jsonEncode(responseFromServer.data)) : null,
          status: NetworkLayerConstants.noContent,
          reasonFromDIOLayer: "No content (201).",
          responseCompletionStatus: RequestCompletionStatusEnums.noContent,
          isSuccess: false);
    } else if (statusCodeFromServer == NetworkLayerConstants.unAuthorised) {
      return RequestCompletionHelperModel(
          reasonFromServer: isValidResponseJson(responseFromServer) ? NetworkUtil.instance.getReasonFromServer(jsonEncode(responseFromServer.data)) : null,
          status: NetworkLayerConstants.unAuthorised,
          reasonFromDIOLayer: "UnAuthorised (401).",
          responseCompletionStatus: RequestCompletionStatusEnums.unAuthorised,
          isSuccess: false);
    } else if (statusCodeFromServer == NetworkLayerConstants.forbidden) {
      return RequestCompletionHelperModel(
          reasonFromServer: isValidResponseJson(responseFromServer) ? NetworkUtil.instance.getReasonFromServer(jsonEncode(responseFromServer.data)) : null,
          status: NetworkLayerConstants.forbidden,
          reasonFromDIOLayer: "Forbidden (403).",
          responseCompletionStatus: RequestCompletionStatusEnums.forbidden,
          isSuccess: false);
    } else if (statusCodeFromServer == NetworkLayerConstants.internalServerError) {
      return RequestCompletionHelperModel(
          reasonFromServer: isValidResponseJson(responseFromServer) ? NetworkUtil.instance.getReasonFromServer(jsonEncode(responseFromServer.data)) : null,
          status: NetworkLayerConstants.internalServerError,
          reasonFromDIOLayer: "Internal Server Error (500).",
          responseCompletionStatus: RequestCompletionStatusEnums.internalServerError,
          isSuccess: false);
    } else if (statusCodeFromServer == NetworkLayerConstants.notFound) {
      return RequestCompletionHelperModel(
          reasonFromServer: isValidResponseJson(responseFromServer) ? NetworkUtil.instance.getReasonFromServer(jsonEncode(responseFromServer.data)) : null,
          status: NetworkLayerConstants.notFound,
          reasonFromDIOLayer: "Not found (404).",
          responseCompletionStatus: RequestCompletionStatusEnums.notFound,
          isSuccess: false);
    } else {
      //unknown result code
      return RequestCompletionHelperModel(
          reasonFromServer: isValidResponseJson(responseFromServer) ? NetworkUtil.instance.getReasonFromServer(jsonEncode(responseFromServer.data)) : null,
          status: NetworkLayerConstants.unknown,
          reasonFromDIOLayer: "Unknown status code from server.",
          responseCompletionStatus: RequestCompletionStatusEnums.unknownStatus,
          isSuccess: false);
    }
  }

  ///Validate the response from the server
  ///If the response returned from server is a valid JSON and is mappable
  ///[responseFromServer] is required param, the Dio Response
  @override
  bool isValidResponseJson(Response responseFromServer) {
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
  Future<void> processPostRequest<T extends Decodable>(
      {required String baseURL,
      required String apiEndPoint,
      required Dio dioInstance,
      required RequestCompletionCallback requestCompletionCallback,
      required NetworkRequestMethodType networkRequestMethodType,
      Map<String, dynamic>? requestBody,
      Map<String, dynamic>? queryParameters,
      bool showRawLogs = false,
      CreateModelClassCallback<T>? createModelClassCallback}) async {
    try {
      var requestStopWatchTimer = Stopwatch();
      requestStopWatchTimer.start();
      await dioInstance.post(apiEndPoint, data: requestBody ?? {}, queryParameters: queryParameters ?? {}).then((Response responseFromServer) {
        var elapsedTimeDuration = requestStopWatchTimer.elapsed.toString();
        requestStopWatchTimer.stop();

        //process the response validation
        requestCompletionCallback(onRequestCompletionGetHelperModel(responseFromServer: responseFromServer, createModelClassCallback: createModelClassCallback));
        //show the time taken by the API call
        NetworkUtil.instance.showLog(
          showRawLogs: showRawLogs,
          networkRequestMethodType: networkRequestMethodType,
          "URL:::$baseURL$apiEndPoint RawResponseFromServer:::${jsonEncode(responseFromServer.data)}\nelapsedTimeDuration:::$elapsedTimeDuration",
        );
      });
    } on DioException catch (dioException) {
      NetworkUtil.instance.showLog(
        showRawLogs: showRawLogs,
        networkRequestMethodType: networkRequestMethodType,
        "URL:::$baseURL$apiEndPoint RawExceptionFromDio:::${dioException.error}",
      );
      requestCompletionCallback((NetworkLayerErrorException.handle(dioException).failure) ??
          RequestCompletionHelperModel(
              status: NetworkLayerConstants.dioNetworkLayerException,
              reasonFromDIOLayer: "DioException has been thrown!",
              isSuccess: false,
              responseCompletionStatus: RequestCompletionStatusEnums.unknownStatus));
    }
  }

  @override
  Future<void> processGetRequest<T extends Decodable>(
      {required String baseURL,
      required String apiEndPoint,
      required Dio dioInstance,
      required RequestCompletionCallback requestCompletionCallback,
      required NetworkRequestMethodType networkRequestMethodType,
      Map<String, dynamic>? requestBody,
      Map<String, dynamic>? queryParameters,
      bool showRawLogs = false,
      CreateModelClassCallback<T>? createModelClassCallback}) async {
    try {
      var requestStopWatchTimer = Stopwatch();
      requestStopWatchTimer.start();
      await dioInstance.get(apiEndPoint, data: requestBody ?? {}, queryParameters: queryParameters ?? {}).then((Response responseFromServer) {
        var elapsedTimeDuration = requestStopWatchTimer.elapsed.toString();
        requestStopWatchTimer.stop();

        //process the response validation
        requestCompletionCallback(onRequestCompletionGetHelperModel(responseFromServer: responseFromServer, createModelClassCallback: createModelClassCallback));
        //show the time taken by the API call
        NetworkUtil.instance.showLog(
          showRawLogs: showRawLogs,
          networkRequestMethodType: networkRequestMethodType,
          "URL:::$baseURL$apiEndPoint RawResponseFromServer:::${jsonEncode(responseFromServer.data)}\nelapsedTimeDuration:::$elapsedTimeDuration",
        );
      });
    } on DioException catch (dioException) {
      NetworkUtil.instance.showLog(
        showRawLogs: showRawLogs,
        networkRequestMethodType: networkRequestMethodType,
        "URL:::$baseURL$apiEndPoint RawExceptionFromDio:::${dioException.error}",
      );
      requestCompletionCallback((NetworkLayerErrorException.handle(dioException).failure) ??
          RequestCompletionHelperModel(
              status: NetworkLayerConstants.dioNetworkLayerException,
              reasonFromDIOLayer: "DioException has been thrown!",
              isSuccess: false,
              responseCompletionStatus: RequestCompletionStatusEnums.unknownStatus));
    }
  }

  @override
  Future<void> processUploadRequest<T extends Decodable>(
      {required String baseURL,
      required String apiEndPoint,
      required Dio dioInstance,
      required RequestCompletionCallback requestCompletionCallback,
      required NetworkRequestMethodType networkRequestMethodType,
      FormData? formData,
      bool showRawLogs = false,
      CreateModelClassCallback<T>? createModelClassCallback}) async {
    try {
      var requestStopWatchTimer = Stopwatch();
      requestStopWatchTimer.start();
      await dioInstance.post(apiEndPoint, data: formData ?? {}).then((Response responseFromServer) {
        var elapsedTimeDuration = requestStopWatchTimer.elapsed.toString();
        requestStopWatchTimer.stop();

        //process the response validation
        requestCompletionCallback(onRequestCompletionGetHelperModel(responseFromServer: responseFromServer, createModelClassCallback: createModelClassCallback));
        //show the time taken by the API call
        NetworkUtil.instance.showLog(
          showRawLogs: showRawLogs,
          networkRequestMethodType: networkRequestMethodType,
          "URL:::$baseURL$apiEndPoint RawResponseFromServer:::${jsonEncode(responseFromServer.data)}\nelapsedTimeDuration:::$elapsedTimeDuration",
        );
      });
    } on DioException catch (dioException) {
      NetworkUtil.instance.showLog(
        showRawLogs: showRawLogs,
        networkRequestMethodType: networkRequestMethodType,
        "URL:::$baseURL$apiEndPoint RawExceptionFromDio:::${dioException.error}",
      );
      requestCompletionCallback((NetworkLayerErrorException.handle(dioException).failure) ??
          RequestCompletionHelperModel(
              status: NetworkLayerConstants.dioNetworkLayerException,
              reasonFromDIOLayer: "DioException has been thrown!",
              isSuccess: false,
              responseCompletionStatus: RequestCompletionStatusEnums.unknownStatus));
    }
  }
}
