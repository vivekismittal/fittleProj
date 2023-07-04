import 'package:fittle_ai/shared/shared_prefs.dart';

class SharedRepo {
  SharedRepo();
  final String _hashTokenKey = "hash_token";
  final String _userIdKey = "user_id";
  final String _profileIdKey = "profile_id";
  final String _profileIndexKey = "_profileIndexKey";
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

    Future<void> saveProfileIndex(int value) async {
    await prefs.setInt(_profileIndexKey, value);
  }

  Future<int?> readProfileIndex() async {
    return await prefs.getInt(_profileIndexKey);
  }
   Future<bool?> clear() async {
    return await prefs.clear();
  }
}
