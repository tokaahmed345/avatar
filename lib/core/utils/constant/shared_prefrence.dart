// import 'package:shared_preferences/shared_preferences.dart';

// class TokenStorage {
//   final SharedPreferences prefs;

//   static const _accessKey = 'ACCESS_TOKEN';
//   static const _refreshKey = 'REFRESH_TOKEN';

//   TokenStorage(this.prefs);

//   Future<void> saveAccessToken(String token) async {
//     await prefs.setString(_accessKey, token);
//   }

//   Future<void> saveRefreshToken(String token) async {
//     await prefs.setString(_refreshKey, token);
//   }

//   String? getAccessToken() {
//     return prefs.getString(_accessKey);
//   }

//   String? getRefreshToken() {
//     return prefs.getString(_refreshKey);
//   }

//   Future<void> clearTokens() async {
//     await prefs.remove(_accessKey);
//     await prefs.remove(_refreshKey);
//   }
// }

import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {

static const String _accessKey = 'access_token';
static const String _refreshKey = 'refresh_token';
  static const String _rememberMeKey = 'rememberMe'; 
  static const String _businessIdKey = 'businessId'; 

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

}


