// ignore_for_file: avoid_print

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:lrl_shopping/feature/products/domain/product_repository.dart';
import 'package:lrl_shopping/feature/products/data/models/product_model.dart';
import 'package:lrl_shopping/core/error/failures.dart';

class ProductCubit extends Cubit<List<ProductModel>> {
  final ProductRepository productRepository;

  ProductCubit({required this.productRepository}) : super([]) {
    if (kDebugMode) {
      print("🟢 ProductCubit Created! Now calling fetchProducts...");
    }
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    if (kDebugMode) {
      print("🔹 ProductCubit: Fetching Products...");
    }

    final Either<Failure, List<ProductModel>> result =
        await productRepository.getProducts();

    result.fold(
      (failure) => print("❌ Fetch Failed: ${failure.toString()}"),
      (products) {
        if (kDebugMode) {
          print("✅ Products Loaded: ${products.length}");
        }
        emit(products);
      },
    );
  }
}
