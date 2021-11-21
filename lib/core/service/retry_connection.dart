
import 'dart:io';

import 'package:dio/dio.dart';

import 'dio_connectivity.dart';

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
