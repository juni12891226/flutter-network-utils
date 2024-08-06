import 'package:network_utils_pack/network/util/imports_util.dart';

class APIObjectTypeResponse<T> extends GenericObject<T>
    implements Decodable<APIObjectTypeResponse<T>> {
  int? responseCode;
  String? responseMessage;
  String? status;
  T? data;

  APIObjectTypeResponse({CreateModelClassCallback<Decodable>? create})
      : super(create: create);

  @override
  APIObjectTypeResponse<T> decode(dynamic json) {
    responseCode = json['responseCode'] ?? -1;
    responseMessage = json['responseMessage'] ?? '';
    status = json['status'] ?? '';

    data = (json as Map<String, dynamic>).containsKey('data')
        ? json['data'] == null
            ? null
            : genericObject(json['data'])
        : null;
    return this;
  }
}

class APIListTypeResponse<T> extends GenericObject<T>
    implements Decodable<APIListTypeResponse<T>> {
  int? responseCode;
  String? responseMessage;
  String? status;
  List<T>? data;

  APIListTypeResponse({CreateModelClassCallback<Decodable>? create})
      : super(create: create);

  @override
  APIListTypeResponse<T> decode(dynamic json) {
    responseCode = json['responseCode'] ?? -1;
    responseMessage = json['responseMessage'] ?? "";
    status = json['status'] ?? '';
    data = [];
    if ((json as Map<String, dynamic>).containsKey('data') &&
        json["data"] != null) {
      json['data'].forEach((item) {
        data!.add(genericObject(item));
      });
    }

    return this;
  }
}

class ErrorResponse implements Exception {
  String? message;

  ErrorResponse({this.message});

  factory ErrorResponse.fromJson(Map<String, dynamic> json) {
    return ErrorResponse(
        message: json['responseMessage'] ?? "Response Wrapper Error.");
  }

  @override
  String toString() {
    return message!;
  }
}
