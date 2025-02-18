import 'package:shared_preferences/shared_preferences.dart';
import '../../feature/auth/domain/entites/user.dart';

class StorageService {
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  Future<void> saveUserData(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', user.name);
    await prefs.setString('user_email', user.email);
    await prefs.setString('user_mobile', user.mobile);
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<Map<String, String?>> getUserData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      "name": prefs.getString('user_name'),
      "email": prefs.getString('user_email'),
      "mobile": prefs.getString('user_mobile'),
    };
  }
}
