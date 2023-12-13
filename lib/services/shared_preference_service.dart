import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceService {
  late SharedPreferences _prefs;
  final String _authToken = 'authToken';

  SharedPreferenceService(this._prefs);

  static final SharedPreferenceService _preferenceService =
      SharedPreferenceService._();

  SharedPreferenceService._();

  static SharedPreferenceService instance() {
    return _preferenceService;
  }

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<bool> setString(String key, String value) async {
    return await _prefs.setString(key, value);
  }

  String? getString(String key) {
    return _prefs.getString(key);
  }

  Future<bool> setBool(String key, bool value) async {
    return await _prefs.setBool(key, value);
  }

  bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  Future<bool> setAuthToken(String value) async {
    return await setString(_authToken, value);
  }

  String? getAuthToken() {
    return getString(_authToken);
  }

  Future<void> clearData() async {
    await _prefs.clear();
  }
}
