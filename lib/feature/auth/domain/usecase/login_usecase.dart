import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/use_cases/use_cases.dart';
import '../entites/user.dart';
import '../repositories/auth_repository.dart';


class LoginUseCase implements UseCase<User, LoginParams> {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  @override
  Future<Either<Failure, User>> call(LoginParams params) {
    return repository.login(params.email, params.password);
  }
}

class LoginParams {
  final String email;
  final String password;

  LoginParams({required this.email, required this.password});
}
