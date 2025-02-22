import 'package:dartz/dartz.dart';
import 'package:lrl_shopping/core/error/exceptions.dart';
import 'package:lrl_shopping/core/error/failures.dart';

class ReturnFailure<T> {
  Future<Either<Failure, T>> call(Exception e) async {
    if (e is ServerException) {
      return const Left(ServerFailure(error: 'Server Failure. Please try again.'));
    } else if (e is ApiException) {
      return Left(ApiFailure(error: e.error));
    } else if (e is CacheException) {
      return Left(CacheFailure());
    } else if (e is InternalException) {
      return Left(InternalFailure(error: e.error));
    } else {
      return const Left(InternalFailure(error: 'Unexpected Internal Failure.'));
    }
  }
}
