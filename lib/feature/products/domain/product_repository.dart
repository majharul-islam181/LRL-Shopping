import 'package:dartz/dartz.dart';
import 'package:lrl_shopping/core/error/failures.dart';
import 'package:lrl_shopping/feature/products/data/models/product_model.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<ProductModel>>> getProducts(); // ✅ Fix return type
}
