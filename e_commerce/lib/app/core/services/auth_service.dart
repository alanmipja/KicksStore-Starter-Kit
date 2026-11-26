import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService extends GetxService {
  static AuthService get to => Get.find<AuthService>();

  static const String _keyIsLoggedIn = 'auth_is_logged_in';
  static const String _keyUserEmail = 'auth_user_email';

  late final SharedPreferences _prefs;
  final isLoggedIn = false.obs;
  final currentUserEmail = ''.obs;
  String? redirectRoute;

  Future<AuthService> init({SharedPreferences? prefs}) async {
    _prefs = prefs ?? await SharedPreferences.getInstance();
    isLoggedIn.value = _prefs.getBool(_keyIsLoggedIn) ?? false;
    currentUserEmail.value = _prefs.getString(_keyUserEmail) ?? '';
    return this;
  }

  Future<void> login(String email, String password) async {
    isLoggedIn.value = true;
    currentUserEmail.value = email;
    await _prefs.setBool(_keyIsLoggedIn, true);
    await _prefs.setString(_keyUserEmail, email);
  }

  Future<void> logout() async {
    isLoggedIn.value = false;
    currentUserEmail.value = '';
    redirectRoute = null;
    await _prefs.remove(_keyIsLoggedIn);
    await _prefs.remove(_keyUserEmail);
  }
}
