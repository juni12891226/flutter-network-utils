import 'package:network_utils_pack/network/util/imports_util.dart';

abstract class Decodable<T> {
  T decode(dynamic data);
}

abstract class GenericObject<T> {
  CreateModelClassCallback<Decodable>? create;

  GenericObject({this.create});

  T genericObject(dynamic data) {
    final item = create!();
    return item.decode(data);
  }
}

class TypeDecodable<T> implements Decodable<TypeDecodable<T>> {
  T? value;

  TypeDecodable({this.value});

  @override
  TypeDecodable<T> decode(dynamic data) {
    value = data;
    return this;
  }
}
