// import 'package:dio/dio.dart';
// import 'package:pretty_dio_logger/pretty_dio_logger.dart';

// class ApiClient {
//   late final Dio dio;

//   ApiClient() {
//     dio = Dio(
//       BaseOptions(
//         baseUrl: 'https://demo.limerickbd.com/backend/public/api/',
//         headers: {'Content-Type': 'application/json'},
//       ),
//     );
//     dio.interceptors.add(PrettyDioLogger(
//         requestHeader: true,
//         requestBody: true,
//         responseBody: true,
//         responseHeader: false,
//         error: true,
//         compact: true,
//         maxWidth: 90));

//     dio.interceptors.add(
//       InterceptorsWrapper(
//         onRequest: (options, handler) {
//           handler.next(options);
//         },
//       ),
//     );
//   }
// }

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:lrl_shopping/core/services/storage_service.dart';

class ApiClient {
  final Dio dio;
  final StorageService storageService;

  ApiClient({required this.storageService})
      : dio = Dio(
          BaseOptions(
            baseUrl: 'https://demo.limerickbd.com/backend/public/api/',
            headers: {'Content-Type': 'application/json'},
            connectTimeout: const Duration(seconds: 10),
            receiveTimeout: const Duration(seconds: 10),
          ),
        ) {
    // ✅ Attach Interceptors
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        final String? token = await storageService.getToken();
        if (token != null) {
          options.headers["Authorization"] = "Bearer $token";
        }
        handler.next(options);
      },
      onResponse: (response, handler) {
        handler.next(response);
      },
      onError: (DioException e, handler) {
        handler.next(e);
      },
    ));

    // ✅ Add Logger Only in Debug Mode
    if (kDebugMode) {
      dio.interceptors.add(PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
      ));
    }
  }
}
