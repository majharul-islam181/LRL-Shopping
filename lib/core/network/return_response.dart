import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:lrl_shopping/core/error/exceptions.dart';

class ReturnResponse<T> {
  T call(Response<dynamic> response, Function(dynamic) fromJsonFunc) {
    if (response.statusCode! >= 200 && response.statusCode! <= 299) {
      debugPrint("✅ API Response: ${response.data}");
      return fromJsonFunc(response.data) as T;
    } else if (response.statusCode! >= 400 && response.statusCode! < 500) {
      throw ApiException(error: "Client error: ${response.statusCode}");
    } else if (response.statusCode! >= 500) {
      throw ServerException();
    } else {
      throw Exception("Unexpected response code: ${response.statusCode}");
    }
  }
}
