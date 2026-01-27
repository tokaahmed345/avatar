import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static const String _accessKey = 'access_token';
  static const String _refreshKey = 'refresh_token';
  static const String _rememberMeKey = 'rememberMe'; 
  static const String _businessIdKey = 'businessId'; 
  static const String _userIdKey = 'userId'; 
  static const String _sessionIdKey = 'sessionId'; 
  static const String _avatarPreviewKey = 'avatar_preview_url'; 
  static const String _avatarIdKey = 'avatar_Id'; 
  static const String _voiceIdKey = 'voice_Id'; 
  static const String _contextIdKey = 'context_id'; 
  static const String _ApiKey = 'Api_key'; 
  static const String _sessionToken = 'sessionToken'; 
  static const String _logoKey = 'logo'; 


  // ==================== Avatar Preview ====================
  Future<void> saveAvatarPreviewUrl(String url) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_avatarPreviewKey, url);
  }

  Future<String?> getAvatarPreviewUrl() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_avatarPreviewKey);
  }

  Future<void> removeAvatarPreviewUrl() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_avatarPreviewKey);
  }
   Future<void> removelogo() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_logoKey);
  }
  Future<void> removeAvatarId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_avatarIdKey);
  }
    Future<void> removeContextId() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_contextIdKey);
  }
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
    return prefs.getString(_businessIdKey) ?? "";
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
//===================================

  Future<void> saveUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userIdKey, userId);
  }

  Future<String> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey) ?? "";
  }
//===================================

  Future<void> saveSessionId(String sessionId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_sessionIdKey, sessionId);
  }

  Future<String> getSessionId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_sessionIdKey) ?? "";
  }

//===================================

    Future<void> saveAvatarId(String avatarId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_avatarIdKey, avatarId);
  }

  Future<String> getAvatarId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_avatarIdKey) ?? "";
  }
//===================================

  //     Future<void> saveVoiceId(String voiceId) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setString(_avatarIdKey, voiceId);
  // }

  // Future<String> getVoiceId() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   return prefs.getString(_voiceIdKey) ?? "";
  // }

//===================================

    Future<void> saveContextId(String contextId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_contextIdKey, contextId);
  }

  Future<String> getContextId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_contextIdKey) ?? "";
  }
//===================================


  //   Future<void> saveApiKey(String apiKey) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   await prefs.setString(_contextIdKey, apiKey);
  // }

  // Future<String> getApikey() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   return prefs.getString(_ApiKey) ?? "";
  // }


      Future<void> saveSessionToken(String sessionToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_sessionToken, sessionToken);
  }

  Future<String> getSessionToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_sessionToken) ?? "";
  }
     Future<void> saveVoiceId(String voiceId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_voiceIdKey, voiceId);
  }

  Future<String> getVoiceId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_voiceIdKey) ?? "";
  }

     Future<void> saveLogo(String logo) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_logoKey, logo);
  }

  Future<String> getLogo() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_logoKey) ?? "";
  }

}







