import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefsService {
  late SharedPreferences _prefs;

  Future<void> storeToken(String tokenKey, String token) async {
    _prefs = await SharedPreferences.getInstance();
    await _prefs.setString(token, token);
  }

  Future<void> storeTokenList(String tokenKey, String token) async {
    _prefs = await SharedPreferences.getInstance();

    // Retrieve the current favorites list
    List<String>? tokenList = _prefs.getStringList(tokenKey) ?? [];

    // Add the new item to the favorites list
    if (!tokenList.contains(token)) {
      tokenList.add(token);
    }

    // Save the updated favorites list
    await _prefs.setStringList(tokenKey, tokenList);
  }

  Future<String?> getToken(String tokenKey) async {
    _prefs = await SharedPreferences.getInstance();

    return _prefs.getString(tokenKey);
  }

  Future<List<String>> getTokenList(String tokenKey) async {
    _prefs = await SharedPreferences.getInstance();

    // Retrieve the favorites list
    List<String>? tokenList = _prefs.getStringList(tokenKey) ?? [];

    return tokenList;
  }

  Future<void> removeToken(String tokenKey) async {
    _prefs = await SharedPreferences.getInstance();

    await _prefs.remove(tokenKey);
  }

  Future<void> removeFromList(String tokenKey, String token) async {
    _prefs = await SharedPreferences.getInstance();

    // Retrieve the current favorites list
    List<String>? tokenList = _prefs.getStringList(tokenKey) ?? [];

    // Remove the item from the favorites list
    tokenList.remove(token);

    // Save the updated favorites list
    await _prefs.setStringList(tokenKey, tokenList);
  }
}
