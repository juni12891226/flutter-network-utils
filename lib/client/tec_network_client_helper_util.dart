import 'package:sudani_network_layer/utils/imports/tec_network_layer_imports_util.dart';
import 'package:sudani_network_layer/utils/log/debug_util.dart';

class TeCNetworkClientHelperUtil {
  /// private constructor
  TeCNetworkClientHelperUtil._();

  /// the one and only instance of this singleton
  static final instance = TeCNetworkClientHelperUtil._();

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
  Dio getClient({
    required int connectTimeoutSecs, //default is 30 seconds
    required int sendTimeoutSecs, //default is 30 seconds
    required int receiveTimeoutSecs, //default is 30 seconds
    required TeCNetworkRequestCompletionCallback
    requestCompletionCallback, //request completion callback
    required String apiEndPoint, //the baseURL appended with the endpoint
    required Map<String, dynamic>
    requestHeaders, //request headers to be send along the request
    required TeCNetworkRequestMethodType
    requestMethod, // method to be specified in the caller method of the api
    required String baseURL,
    bool showRawLogs = false,
    required bool showSSLPiningKeyInLogs,
    List<Interceptor>? dioInterceptors,
  }) {
    var options = BaseOptions(
      baseUrl: baseURL,
      // baseURL without the endpoint
      responseType: ResponseType.json,
      //response type of the request, now only JSON
      method:
          requestMethod == TeCNetworkRequestMethodType.post ? "post" : "get",
      //request method that is POST or GET
      sendTimeout: _getAPITimeoutDuration(
        givenAPITimeoutInSeconds: sendTimeoutSecs,
      ),
      connectTimeout: _getAPITimeoutDuration(
        givenAPITimeoutInSeconds: connectTimeoutSecs,
      ),
      receiveTimeout: _getAPITimeoutDuration(
        givenAPITimeoutInSeconds: receiveTimeoutSecs,
      ),
      headers: requestHeaders,
      receiveDataWhenStatusError: true,
      followRedirects: false,

      validateStatus: (status) {
        return (status ?? 0) <= 501;
      },
    );

    var dio = Dio(options);
    if (!kIsWeb && TeCDMPNetworkConstants.instance.validateThroughSSL) {
      (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {
        return HttpClient()
          ..badCertificateCallback = ((
            X509Certificate cert,
            String host,
            int port,
          ) {
            if (_verifySSL(
              cert,
              appSSLConfigsList: TeCDMPNetworkConstants.instance.appSSLConfigs,
              showSSLPiningKeyInLogs: showSSLPiningKeyInLogs,
            )) {
              return true;
            } else {
              return false;
            }
          });
      };
    }
    if (dioInterceptors != null && dioInterceptors.isNotEmpty) {
      dio.interceptors.addAll(dioInterceptors);
    }
    if (showRawLogs) {
      dio.interceptors.add(TeCLoggerInterceptor());
    }
    return dio;
  }

  bool _verifySSL(
    X509Certificate certToVerify, {
    List<String>? appSSLConfigsList,
    required bool showSSLPiningKeyInLogs,
  }) {
    List<String> appSSLConfigs = [];
    if (appSSLConfigsList != null) {
      appSSLConfigs = appSSLConfigsList;
    }
    try {
      ASN1Parser p = ASN1Parser(certToVerify.der);
      ASN1Sequence signedCert = p.nextObject() as ASN1Sequence;
      ASN1Sequence cert = signedCert.elements[0] as ASN1Sequence;
      ASN1Sequence pubKeyElement = cert.elements[6] as ASN1Sequence;
      ASN1BitString pubKeyBits = pubKeyElement.elements[1] as ASN1BitString;

      List<int> list = pubKeyBits.stringValue;
      Uint8List bytes = Uint8List.fromList(list);
      ASN1Parser rsaParser = ASN1Parser(bytes);
      ASN1Sequence keySeq = rsaParser.nextObject() as ASN1Sequence;
      ASN1Integer modulus = keySeq.elements[0] as ASN1Integer;

      String certPublic =
          modulus.valueAsBigInteger.toRadixString(16).toString();
      if (showSSLPiningKeyInLogs) {
        NetworkDebugUtils.debugLog(
          "SSLx:::Public Key::: $certPublic",
          logLevel: LogLevel.warning,
        );
      }
      bool isValidCertificate = false;
      for (var element in appSSLConfigs) {
        if (element.toLowerCase() == certPublic.toLowerCase()) {
          isValidCertificate = true;
          break;
        }
      }

      return isValidCertificate;
    } catch (e) {
      NetworkDebugUtils.debugLog(
        "SSLx:::TeC Network Layer: Verify SSL Exception::: $e",
        logLevel: LogLevel.error,
      );
    }
    return false;
  }

  ///Get the timeout in Duration Object
  Duration _getAPITimeoutDuration({required int givenAPITimeoutInSeconds}) {
    return Duration(
      seconds: givenAPITimeoutInSeconds > 0 ? givenAPITimeoutInSeconds : 60,
    );
  }
}
