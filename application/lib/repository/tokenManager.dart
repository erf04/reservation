import 'package:application/repository/sharedPreferences.dart';

class TokenManager {

  
  static Future<void> saveTokens(
      String accessToken, String refreshToken) async {
    await SharedPreferencesManager.instance
        .setString('accessToken', accessToken);
    await SharedPreferencesManager.instance
        .setString('refreshToken', refreshToken);
  }

  static Future<String?> getAccessToken() async {
    return await SharedPreferencesManager.instance.getString('accessToken');
  }

  static Future<String?> getRefreshToken() async {
    return await SharedPreferencesManager.instance.getString('refreshToken');
  }

  static Future<void> setAccessToken(String token) async {
    await SharedPreferencesManager.instance.setString('accessToken', token);
    return;
  }

  static Future<void> setRefreshToken(String token) async {
    SharedPreferencesManager.instance.setString('refreshToken', token);
  }

  static Future<void> clearTokens() async {
    await SharedPreferencesManager.instance.remove('accessToken');
    await SharedPreferencesManager.instance.remove('refreshToken');
  }

}
