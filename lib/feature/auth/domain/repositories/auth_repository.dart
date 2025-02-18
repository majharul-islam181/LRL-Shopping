import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entites/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> login(String email, String password);
}
