import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:user_pagination/core/model/user_model/user_model.dart';

abstract class IUserService<T> {
  final String baseUrl = "http://192.168.1.22:3000/getApi/Users";
  Future<List<T>> fetchUsers(int pageNumber, int limit);
}

class UserService extends IUserService<User> {
  late final Dio _dio;
  UserService._() {
    _dio = Dio();
    _dio.interceptors.add(RetryConnectionInterceptor(
        requestRetrier: DioConnectivityRequestRetrier(
            dio: _dio, connectivity: Connectivity())));
  }
  static UserService get _singleton => UserService._();
  factory UserService() => _singleton;

  final StreamController<List<User>> _userController =
      StreamController<List<User>>();
  StreamSink<List<User>> get streamSink => _userController.sink;
  Stream<List<User>> get users => _userController.stream;
  @override
  Future<List<User>> fetchUsers(int pageNumber, int limit) async {
    try {
      var responseBody =
          await _dio.get('$baseUrl?page=$pageNumber&limit=$limit');
      // log("responseBody : $responseBody");
      return ((responseBody.data) as List)
          .map((user) => User.fromJson(user))
          .cast<User>()
          .toList();
    } catch (e) {
      rethrow;
    }
  }
}

class RetryConnectionInterceptor extends Interceptor {
  final DioConnectivityRequestRetrier requestRetrier;

  RetryConnectionInterceptor({required this.requestRetrier});
  Future sendData(DioError err) async {
    return requestRetrier.scheduleRequestRetry(err.requestOptions);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) {
    if (_shouldRetry(err)) {
      try {
        log("Veri Gelmedi");
        sendData(err);
      } catch (e) {
        rethrow;
      }
    }
    sendData(err);
  }

  bool _shouldRetry(DioError error) {
    return error.error is SocketException &&
        error.type == DioErrorType.other &&
        error.error != null;
  }
}

class DioConnectivityRequestRetrier {
  final Dio dio;
  final Connectivity connectivity;

  DioConnectivityRequestRetrier(
      {required this.dio, required this.connectivity});

  Future<Response> scheduleRequestRetry(RequestOptions options) async {
    StreamSubscription? streamSubscription;
    final responseCompleter = Completer<Response>();
    streamSubscription =
        connectivity.onConnectivityChanged.listen((connectivityResult) {
      if (connectivityResult != ConnectivityResult.none) {
        streamSubscription?.cancel();
        responseCompleter.complete(dio.request(
          options.path,
          cancelToken: options.cancelToken,
          data: options.data,
          onReceiveProgress: options.onReceiveProgress,
          onSendProgress: options.onSendProgress,
        ));
      } else {
        throw DioError(requestOptions: options, error: options.data);
      }
    });
    return responseCompleter.future;
  }
}
