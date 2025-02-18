import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:lrl_shopping/feature/auth/domain/entites/user.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/return_failure.dart';
import '../../../../core/network/return_response.dart';
import '../../domain/entites/user.dart' as domain_user;
import '../../domain/repositories/auth_repository.dart';
import '../models/login_response.dart';

/*
class AuthRepositoryImpl implements AuthRepository {
  final ApiClient apiClient;

  AuthRepositoryImpl({required this.apiClient});

  @override
  Future<Either<Failure, domain_user.User>> login(String email, String password) async {
    try {
      final response = await apiClient.dio.post('/login', data: {
        "email": email,
        "password": password,
      });

      final loginResponse = ReturnResponse<LoginResponse>()
          .call(response, (data) => LoginResponse.fromJson(data));

      final user = domain_user.User(
        id: loginResponse.data.id,
        name: loginResponse.data.name,
        email: loginResponse.data.email,
        mobile: loginResponse.data.mobile,
      );

      return Right(user);
    } catch (e) {
      return ReturnFailure<domain_user.User>().call(e as Exception);
    }
  }
}
*/


class AuthRepositoryImpl implements AuthRepository {
  final ApiClient apiClient;

  AuthRepositoryImpl({required this.apiClient});

  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    try {
      final response = await apiClient.dio.post('/login', data: {
        "email": email,
        "password": password,
      });

      final loginResponse = ReturnResponse<LoginResponse>()
          .call(response, (data) => LoginResponse.fromJson(data));

      final user = User(
        id: loginResponse.data.id,
        name: loginResponse.data.name,
        email: loginResponse.data.email,
        mobile: loginResponse.data.mobile,
      );

      return Right(user);
    } catch (e) {
      return ReturnFailure<User>().call(e as Exception);
    }
  }
}

