import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  const Failure({this.properties = const <dynamic>[]});

  final List properties;

  @override
  List<Object> get props => [properties];
}

class ServerFailure extends Failure {
  final String error;
  const ServerFailure({required this.error});
}

class ApiFailure extends Failure {
  final String error;
  const ApiFailure({required this.error});
}

class CacheFailure extends Failure {}

class InternalFailure extends Failure {
  final String error;
  const InternalFailure({required this.error});
}

class DioFailure extends Failure {
  final DioException dioException;
  final String error;

  DioFailure({required this.dioException})
      : error = _extractErrorMessage(dioException),
        super(properties: [dioException]);

  static String _extractErrorMessage(DioException dioException) {
    if (dioException.type == DioExceptionType.badResponse) {
      try {
        final responseData = dioException.response?.data;
        if (responseData != null && responseData is Map<String, dynamic>) {
          return responseData['message'] ?? 'Something went wrong!';
        }
      } catch (e) {
        return 'An unexpected error occurred.';
      }
    }
    return 'Network error occurred.';
  }

  @override
  List<Object> get props => [dioException, error];
}