import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:dio/dio.dart';
import 'package:user_pagination/core/service/dio_connectivity.dart';
import 'package:user_pagination/core/service/retry_connection.dart';
import '../model/user_model/user_model.dart';

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
