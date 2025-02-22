// import 'package:flutter_bloc/flutter_bloc.dart';
// import '../../data/product_model.dart';
// import '../../domain/product_repository.dart';
// import 'product_state.dart';

// class ProductCubit extends Cubit<ProductState> {
//   final ProductRepository productRepository;

//   ProductCubit(this.productRepository) : super(ProductInitial());

//   Future<void> loadProducts() async {
//     emit(ProductLoading());
//     try {
//       final products = await productRepository.getProducts();
//       emit(ProductLoaded(products));
//     } catch (e) {
//       emit(ProductError("Failed to load products: $e"));
//     }
//   }
// }



// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:dartz/dartz.dart';
// import 'package:lrl_shopping/feature/products/domain/product_repository.dart';
// import 'package:lrl_shopping/feature/products/presentation/cubit/product_state.dart';

// class ProductCubit extends Cubit<ProductState> {
//   final ProductRepository productRepository;

//   ProductCubit(this.productRepository) : super(ProductInitial());

//   Future<void> loadProducts() async {
//     emit(ProductLoading());
//     final result = await productRepository.getProducts();

//     result.fold(
//       (failure) => emit(ProductError("Failed to load products: ${failure.toString()}")),
//       (products) => emit(ProductLoaded(products)),
//     );
//   }
// }

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:lrl_shopping/feature/products/domain/product_repository.dart';
import 'package:lrl_shopping/feature/products/data/models/product_model.dart';
import 'package:lrl_shopping/core/error/failures.dart';
import 'package:flutter/foundation.dart';

class ProductCubit extends Cubit<List<ProductModel>> {
  final ProductRepository productRepository;

  ProductCubit({required this.productRepository}) : super([]) {
    print("🟢 ProductCubit Created! Now calling fetchProducts...");
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    print("🔹 ProductCubit: Fetching Products...");

    final Either<Failure, List<ProductModel>> result =
        await productRepository.getProducts();

    result.fold(
      (failure) => print("❌ Fetch Failed: ${failure.toString()}"),
      (products) {
        print("✅ Products Loaded: ${products.length}");
        emit(products);
      },
    );
  }
}
