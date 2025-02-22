// import 'package:shared_preferences/shared_preferences.dart';
// import '../../feature/auth/domain/entites/user.dart';

// class StorageService {
//   Future<void> saveToken(String token) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('auth_token', token);
//   }

//   Future<void> saveUserData(User user) async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.setString('user_name', user.name);
//     await prefs.setString('user_email', user.email);
//     await prefs.setString('user_mobile', user.mobile);
//   }

//   Future<String?> getToken() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('auth_token');
//   }

//   Future<Map<String, String?>> getUserData() async {
//     final prefs = await SharedPreferences.getInstance();
//     return {
//       "name": prefs.getString('user_name'),
//       "email": prefs.getString('user_email'),
//       "mobile": prefs.getString('user_mobile'),
//     };
//   }
// }

import 'package:lrl_shopping/feature/auth/domain/entites/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class StorageService {
  static const String _tokenKey = 'token';
  static const String _userKey = 'user';

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
    print("✅ Token Saved: $token");
  }

Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_tokenKey);
    print("🔹 Retrieved Token: $token"); // ✅ Debugging Output
    return token;
  }

  Future<void> saveUserData(User user) async {
    final prefs = await SharedPreferences.getInstance();
    String userJson = jsonEncode({
      'id': user.id,
      'name': user.name,
      'token': user.token,
      'email': user.email,
      'mobile': user.mobile,
    });
    await prefs.setString(_userKey, userJson);
  }

  // Future<User?> getUserData() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   String? userJson = prefs.getString(_userKey);
  //   if (userJson != null) {
  //     Map<String, dynamic> userMap = jsonDecode(userJson);
  //     return User(
  //       id: userMap['id'],
  //       token: userMap['token'],
  //       name: userMap['name'],
  //       email: userMap['email'],
  //       mobile: userMap['mobile'],
  //     );
  //   }
  //   return null;
  // }

  Future<User?> getUserData() async {
  final prefs = await SharedPreferences.getInstance();
  String? userJson = prefs.getString(_userKey);

  if (userJson != null) {
    Map<String, dynamic> userMap = jsonDecode(userJson);
    return User(
      id: userMap['id'],
      token: userMap['token'] ?? '', // ✅ Fix: Provide a default empty string
      name: userMap['name'],
      email: userMap['email'],
      mobile: userMap['mobile'],
    );
  }
  return null;
}


  Future<void> clearData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
