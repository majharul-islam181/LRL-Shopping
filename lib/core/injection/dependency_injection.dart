import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
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
  sl.registerLazySingleton(() => ApiClient());
  sl.registerLazySingleton(() => StorageService());

  // Register Repositories
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(apiClient: sl()));

  // Register UseCases
  sl.registerLazySingleton(() => LoginUseCase(sl()));

  // Register Cubits
  sl.registerFactory(() => LoginCubit(
        loginUseCase: sl(),
        storageService: sl(),
      ));

  // Register SharedPreferences instance for session management
  sl.registerLazySingleton(() async => await SharedPreferences.getInstance());
}
