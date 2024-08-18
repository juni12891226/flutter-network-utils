class NetworkLayerConstants {
  static const int success = 200; // success with data
  static const int noContent = 201; // success with no data (no content)
  static const int badRequest = 400; // failure, API rejected request
  static const int unAuthorised = 401; // failure, user is not authorised
  static const int forbidden = 403; //  failure, API rejected request
  static const int internalServerError = 500; // failure, crash in server side
  static const int notFound = 404; // failure, not found
  static const int unknown = 9999; //unknown
  static const int responseNotValid = 8888; //response not valid
  static const int defaultInCaseOfNull = 5555; //default in case of null
  static const int noInternetConnection = 4444; //no internet connection
  static const int dioNetworkLayerException = 3333; //dio network layer exception
  static const int badCertificate = 1233; //bad certificate | No match
  static const int connectionTimeout = 1244; //connection timeout
  static const int requestCancelled = 1245; //request Cancelled
  static const int receiveTimeout = 1246;
  static const int sendTimeout = 1247;
  static const int connectionError = 1248;
}
