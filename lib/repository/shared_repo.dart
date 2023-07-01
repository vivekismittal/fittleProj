import 'package:fittle_ai/shared/shared_prefs.dart';

class SharedRepo {
  SharedRepo();
  final String _hashTokenKey = "hash_token";
  final String _userIdKey = "user_id";
  final String _profileIdKey = "profile_id";
  final String _isCompleteKey = "isProfileComplete";
  final SharedPrefs prefs = SharedPrefs();

  Future<void> saveHashToken(String value) async {
    await prefs.setString(_hashTokenKey, value);
  }

  Future<String?> readHashToken() async {
    return await prefs.getString(_hashTokenKey);
  }

  Future<void> saveUserId(String value) async {
    await prefs.setString(_userIdKey, value);
  }

  Future<String?> readUserId() async {
    return await prefs.getString(_userIdKey);
  }

  Future<void> saveProfileId(String value) async {
    await prefs.setString(_profileIdKey, value);
  }

  Future<String?> readProfileId() async {
    return await prefs.getString(_profileIdKey);
  }

  Future<void> saveProfileCompletionStatus(bool value) async {
    await prefs.setBool(_isCompleteKey, value);
  }

  Future<bool?> readProfileCompletionStatus() async {
    return await prefs.getBool(_isCompleteKey);
  }
   Future<bool?> clear() async {
    return await prefs.clear();
  }
}
