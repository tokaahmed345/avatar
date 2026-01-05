
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {

static const String _accessKey = 'access_token';
static const String _refreshKey = 'refresh_token';
  static const String _rememberMeKey = 'rememberMe'; 
  static const String _businessIdKey = 'businessId'; 
  static const String _userIdKey = 'userId'; 
  static const String _sessionIdKey = 'sessionId'; 

Future<void> saveAccessToken(String token) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(_accessKey, token);
}

Future<void> saveRefreshToken(String token) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(_refreshKey, token);
}
Future<void> saveBusinessId(String businessId) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(_businessIdKey, businessId);
}
Future<String> getBusinessId() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(_businessIdKey)??"";
}
Future<String?> getAccessToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(_accessKey);
}

Future<String?> getRefreshToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(_refreshKey);
}

  Future<void> removeAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessKey);
  }



  Future<void> removeRefreshToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_refreshKey);
  }
  Future<void> saveIsLoggedIn(bool value) async {
        final prefs = await SharedPreferences.getInstance();

    await prefs.setBool('isLoggedIn', value);
  }
Future<bool> isLoggedIn() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('isLoggedIn') ?? false;
}
  Future<void> saveRememberMe(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_rememberMeKey, value);
  }

  Future<bool> getRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_rememberMeKey) ?? false; 
  }
  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_accessKey);
    await prefs.remove(_businessIdKey);
 
  }

Future<void> saveUserId(String businessId) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(_userIdKey, businessId);
}

Future<String> getUserId() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(_userIdKey)??"";
}



Future<void> saveSessionId(String sessionId) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(_sessionIdKey, sessionId);
}

Future<String> getSessionId() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString(_sessionIdKey)??"";
}



}


