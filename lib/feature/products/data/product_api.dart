import 'package:dio/dio.dart';
import 'package:lrl_shopping/core/network/api_client.dart';
import 'package:lrl_shopping/core/services/storage_service.dart';
import 'package:lrl_shopping/feature/products/data/models/product_model.dart';
import 'package:flutter/foundation.dart';

class ProductApi {
  final ApiClient apiClient;
  final StorageService storageService;

  ProductApi({required this.apiClient, required this.storageService});

  Future<List<ProductModel>> fetchProducts() async {
    print("🔹 ProductApi: fetchProducts() called...");
    final String? token = await storageService.getToken();
     print("✅ Bearer Token: $token");

    try {
      // ✅ Retrieve token from storage
      final String? token = await storageService.getToken();

      if (token == null) {
        throw Exception("❌ No authentication token found. Please log in.");
      }

      final response = await apiClient.dio.get(
        '/fg-with-stock',
        options: Options(
           headers: {"Authorization": "Bearer $token"}, ),
      );

      // ✅ Debugging Output
      if (kDebugMode) {
        print("✅ API Request: ${apiClient.dio.options.baseUrl}/fg-with-stock");
        print("✅ Bearer Token: $token");
        print("✅ Response Status: ${response.statusCode}");
        print("✅ Response Data: ${response.data}");
      }

      if (response.statusCode == 200) {
        List<dynamic> jsonData = response.data;
        return jsonData.map((json) => ProductModel.fromJson(json)).toList();
      } else {
        throw Exception("❌ Server Error: ${response.statusCode}");
      }
    } on DioException catch (e) {
      if (e.response != null) {
        print("❌ API Error (${e.response!.statusCode}): ${e.response!.data}");
        throw Exception("API Error (${e.response!.statusCode}): ${e.response!.data}");
      } else {
        print("❌ Network Error: ${e.message}");
        throw Exception("Network Error: ${e.message}");
      }
    } catch (e) {
      print("❌ Unexpected Error: $e");
      throw Exception("Unexpected Error: $e");
    }
  }
}
