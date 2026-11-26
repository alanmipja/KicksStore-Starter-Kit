import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService extends GetxService {
  static AuthService get to => Get.find<AuthService>();

  static const String _keyIsLoggedIn = 'auth_is_logged_in';
  static const String _keyUserEmail = 'auth_user_email';

  late final SharedPreferences _prefs;
  FirebaseAuth? _auth;
  StreamSubscription<User?>? _authSubscription;
  final isLoggedIn = false.obs;
  final currentUserEmail = ''.obs;
  final currentUserId = ''.obs;
  String? redirectRoute;

  Future<AuthService> init({
    SharedPreferences? prefs,
    FirebaseAuth? auth,
  }) async {
    _prefs = prefs ?? await SharedPreferences.getInstance();
    try {
      _auth = auth ?? FirebaseAuth.instance;
      _authSubscription = _auth!.authStateChanges().listen((user) {
        isLoggedIn.value = user != null;
        currentUserEmail.value = user?.email ?? '';
        currentUserId.value = user?.uid ?? '';
      });
      final user = _auth!.currentUser;
      isLoggedIn.value = user != null;
      currentUserEmail.value =
          user?.email ?? _prefs.getString(_keyUserEmail) ?? '';
      currentUserId.value = user?.uid ?? '';
    } catch (_) {
      isLoggedIn.value = _prefs.getBool(_keyIsLoggedIn) ?? false;
      currentUserEmail.value = _prefs.getString(_keyUserEmail) ?? '';
    }
    return this;
  }

  Future<void> login(String email, String password) async {
    if (_auth != null) {
      final credential = await _auth!.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = credential.user;
      isLoggedIn.value = user != null;
      currentUserEmail.value = user?.email ?? email.trim();
      currentUserId.value = user?.uid ?? '';
    } else {
      isLoggedIn.value = true;
      currentUserEmail.value = email.trim();
    }
    await _prefs.setBool(_keyIsLoggedIn, true);
    await _prefs.setString(_keyUserEmail, email);
  }

  Future<void> register(String email, String password) async {
    if (_auth != null) {
      final credential = await _auth!.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
      final user = credential.user;
      isLoggedIn.value = user != null;
      currentUserEmail.value = user?.email ?? email.trim();
      currentUserId.value = user?.uid ?? '';
    } else {
      isLoggedIn.value = true;
      currentUserEmail.value = email.trim();
    }
    await _prefs.setBool(_keyIsLoggedIn, true);
    await _prefs.setString(_keyUserEmail, email.trim());
  }

  Future<void> logout() async {
    if (_auth != null) await _auth!.signOut();
    isLoggedIn.value = false;
    currentUserEmail.value = '';
    currentUserId.value = '';
    redirectRoute = null;
    await _prefs.remove(_keyIsLoggedIn);
    await _prefs.remove(_keyUserEmail);
  }

  static String mapFirebaseAuthError(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'user-not-found':
          return 'Akun dengan email ini tidak ditemukan.';
        case 'wrong-password':
        case 'invalid-credential':
          return 'Kata sandi atau email yang Anda masukkan salah.';
        case 'email-already-in-use':
          return 'Email ini sudah terdaftar. Silakan gunakan email lain atau langsung login.';
        case 'invalid-email':
          return 'Format alamat email tidak valid.';
        case 'weak-password':
          return 'Kata sandi terlalu lemah. Minimal gunakan 6 karakter.';
        case 'network-request-failed':
          return 'Koneksi internet bermasalah. Periksa sambungan data perangkat Anda.';
        case 'too-many-requests':
          return 'Terlalu banyak percobaan gagal. Silakan tunggu beberapa saat lagi.';
        case 'operation-not-allowed':
          return 'Metode login Email/Password belum diaktifkan di Firebase Console.';
        default:
          return error.message ??
              'Terjadi kesalahan autentikasi (${error.code}).';
      }
    }
    return error.toString();
  }

  @override
  void onClose() {
    _authSubscription?.cancel();
    super.onClose();
  }
}
