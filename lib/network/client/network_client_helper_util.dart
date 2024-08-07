import 'package:network_utils_pack/network/util/imports_util.dart';

class NetworkClientHelperUtil {
  /// private constructor
  NetworkClientHelperUtil._();

  /// the one and only instance of this singleton
  static final instance = NetworkClientHelperUtil._();

  ///Simple method to get the DIO network client to be used
  ///To call the network APIs (REST)
  ///[connectTimeoutSecs] is required
  ///[sendTimeoutSecs] is required
  ///[receiveTimeoutSecs] is required
  ///[requestCompletionCallback] is required
  ///[apiEndPoint] is required
  ///[requestHeaders] is required
  ///[requestMethod] is required
  ///[baseURL] is required
  ///[dioInterceptors] is optional to add any available Dio Interceptors
  Dio getClient(
      {required int connectTimeoutSecs, //default is 30 seconds
      required int sendTimeoutSecs, //default is 30 seconds
      required int receiveTimeoutSecs, //default is 30 seconds
      required RequestCompletionCallback requestCompletionCallback, //request completion callback
      required String apiEndPoint, //the baseURL appended with the endpoint
      required Map<String, dynamic> requestHeaders, //request headers to be send along the request
      required NetworkRequestMethodType requestMethod, // method to be specified in the caller method of the api
      required String baseURL,
      List<Interceptor>? dioInterceptors}) {
    var options = BaseOptions(
      baseUrl: baseURL,
      // baseURL without the endpoint
      responseType: ResponseType.json,
      //response type of the request, now only JSON
      method: requestMethod == NetworkRequestMethodType.post ? "post" : "get",
      //request method that is POST or GET
      sendTimeout: _getAPITimeoutDuration(givenAPITimeoutInSeconds: sendTimeoutSecs),
      connectTimeout: _getAPITimeoutDuration(givenAPITimeoutInSeconds: connectTimeoutSecs),
      receiveTimeout: _getAPITimeoutDuration(givenAPITimeoutInSeconds: receiveTimeoutSecs),
      headers: requestHeaders,
      receiveDataWhenStatusError: true,
      followRedirects: false,
      validateStatus: (status) {
        return (status ?? 0) <= 501;
      },
    );

    var dio = Dio(options);
    if (dioInterceptors != null && dioInterceptors.isNotEmpty) {
      dio.interceptors.addAll(dioInterceptors);
    }

    dio.interceptors.add(PrettyDioLogger(requestHeader: true, requestBody: true, responseBody: true, responseHeader: false, error: true, compact: false, maxWidth: 2048));
    return dio;
  }

  ///Get the timeout in Duration Object
  _getAPITimeoutDuration({required int givenAPITimeoutInSeconds}) {
    return Duration(seconds: givenAPITimeoutInSeconds > 0 ? givenAPITimeoutInSeconds : 30);
  }
}
