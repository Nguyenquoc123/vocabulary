import 'package:shared_preferences/shared_preferences.dart';

class User {
  static const String keyToken = "token";
  static const String keyUserId = "user_id";
  static const String keyFullName = "full_name";
  static const String keyEmail = "email";

  /// Lưu thông tin user sau khi đăng nhập
  static Future<void> saveUserData({
    required String token,
    required int userId,
    required String fullName,
    required String email,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(keyToken, token);
    await prefs.setInt(keyUserId, userId);
    await prefs.setString(keyFullName, fullName);
    await prefs.setString(keyEmail, email);
  }

  /// Lấy token
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyToken);
  }

  /// Lấy userId
  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(keyUserId);
  }

  /// Lấy tên đầy đủ
  static Future<String?> getFullName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyFullName);
  }

  /// Lấy email
  static Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(keyEmail);
  }

  /// Xóa toàn bộ thông tin (đăng xuất)
  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}

