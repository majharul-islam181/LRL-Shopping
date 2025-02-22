import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:lrl_shopping/feature/products/data/product_api.dart';
import 'package:lrl_shopping/feature/products/data/repositories/product_repository_impl.dart';
import 'package:lrl_shopping/feature/products/domain/product_repository.dart';
import 'package:lrl_shopping/feature/products/presentation/cubit/product_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../feature/auth/data/repositories/auth_repository_impl.dart';
import '../../feature/auth/domain/repositories/auth_repository.dart';
import '../../feature/auth/domain/usecase/login_usecase.dart';
import '../../feature/auth/presentation/cubit/login_cubit.dart';
import '../network/api_client.dart';
import '../services/storage_service.dart';

final sl = GetIt.instance; // sl stands for Service Locator

void init() {
  // Register Services
  sl.registerLazySingleton<ApiClient>(() => ApiClient(storageService: sl<StorageService>()));
  sl.registerLazySingleton(() => StorageService());

  // Register Repositories
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(apiClient: sl()));

  // Register UseCases
  sl.registerLazySingleton(() => LoginUseCase(sl()));

 // ✅ Register Product API
  sl.registerLazySingleton<ProductApi>(
      () => ProductApi(apiClient: sl<ApiClient>(), storageService: sl<StorageService>())); // ✅ Fix: Use `ApiClient`

  // ✅ Register Product Repository
  sl.registerLazySingleton<ProductRepository>(
      () => ProductRepositoryImpl(productApi: sl<ProductApi>()));

  // ✅ Register Product Cubit
  //sl.registerFactory(() => ProductCubit(sl<ProductRepository>())); 

  // Register Cubits
  sl.registerFactory(() => LoginCubit(
        loginUseCase: sl(),
        storageService: sl(),
      ));

      

  // Register SharedPreferences instance for session management
  sl.registerLazySingleton(() async => await SharedPreferences.getInstance());
}
/*
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:lrl_shopping/core/blocs/theme_cubit.dart';
import 'package:lrl_shopping/feature/auth/data/repositories/auth_repository_impl.dart';
import 'package:lrl_shopping/feature/auth/domain/usecase/login_usecase.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lrl_shopping/core/services/storage_service.dart';
import 'package:lrl_shopping/feature/products/data/product_api.dart';
import 'package:lrl_shopping/feature/products/domain/product_repository.dart';
import 'package:lrl_shopping/feature/products/presentation/cubit/product_cubit.dart';
import 'package:lrl_shopping/feature/auth/domain/repositories/auth_repository.dart';
import 'package:lrl_shopping/feature/auth/presentation/cubit/login_cubit.dart';


final GetIt sl = GetIt.instance; // ✅ GetIt for Dependency Injection

Future<void> init() async {
  // ✅ Register SharedPreferences instance for session management
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  // ✅ Register Dio instance
  sl.registerLazySingleton<Dio>(() => Dio());

  // ✅ Register StorageService
  sl.registerLazySingleton<StorageService>(() => StorageService());

  // ✅ Register Product API (Fix: Pass named parameters)
  sl.registerLazySingleton<ProductApi>(
      () => ProductApi(dio: sl<Dio>(), storageService: sl<StorageService>()));

  // ✅ Register Product Repository
  sl.registerLazySingleton<ProductRepository>(
      () => ProductRepositoryImpl(sl<ProductApi>()));

  // ✅ Register Product Cubit
 sl.registerFactory(() => ProductCubit(sl<ProductRepository>())); 

  // ✅ Register Authentication Repository
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(apiClient: sl()));

  // ✅ Register Login UseCase
  sl.registerLazySingleton(() => LoginUseCase(sl()));

  // ✅ Register LoginCubit
  sl.registerFactory(() => LoginCubit(
        loginUseCase: sl(),
        storageService: sl(),
      ));

  // ✅ Register ThemeCubit (Singleton for global theme management)
  sl.registerLazySingleton<ThemeCubit>(() => ThemeCubit());
}
*/