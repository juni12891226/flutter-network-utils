import 'package:network_utils_pack/network/util/imports_util.dart';

///completion callback, that is when the api is completed will get called
typedef RequestCompletionCallback = void Function(
    RequestCompletionHelperModel? requestCompletionHelperModel);

typedef CreateModelClassCallback<T> = T Function();
