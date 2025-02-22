import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:lrl_shopping/core/error/failures.dart';
import 'package:lrl_shopping/core/network/return_failure.dart';
//import 'package:lrl_shopping/core/services/return_failure.dart';
import 'package:lrl_shopping/feature/products/data/product_api.dart';
import 'package:lrl_shopping/feature/products/data/models/product_model.dart';
import 'package:lrl_shopping/feature/products/domain/product_repository.dart';
import 'package:flutter/foundation.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductApi productApi;

  ProductRepositoryImpl({required this.productApi});

  @override
  Future<Either<Failure, List<ProductModel>>> getProducts() async {
    try {
      final List<ProductModel> products = await productApi.fetchProducts();

      if (kDebugMode) {
        print("✅ Successfully Fetched Products: ${products.length}");
      }

      return Right(products);
    } on DioException catch (e) {
      print("❌ DioException: ${e.message}");
      return Left(DioFailure(dioException: e));
    } catch (e) {
      print("❌ General Exception: $e");
      return await ReturnFailure<List<ProductModel>>().call(e as Exception);
    }
  }
}
