import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../login_signup page/login_model.dart';

class AuthService {
  // Base Domain
  static const String domain = "http://gnwbazaar-002-site2.qtempurl.com";

  // Endpoints
  static const String loginUrl = "$domain/GNW_Login"; // Verified working
  static const String logoutUrl = "$domain/GNW_Logout";
  static const String refreshUrl = "$domain/GNW_RefreshToken";

  // -------------------- LOGIN --------------------
  Future<bool> login(LoginRequest request) async {
    print("--- LOGIN ATTEMPT ---");
    try {
      final response = await http.post(
        Uri.parse(loginUrl),
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {
          "Email": request.email,
          "Password": request.password
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        // 1. EXTRACT DATA
        // 'accessToken' is the short-term ID card
        // 'Token' is the long-term Refresh ticket
        final String? accessToken = responseData['Value']?['accessToken'];
        final String? refreshToken = responseData['Value']?['Token'];

        // 2. SAVE TO STORAGE
        if (accessToken != null && accessToken.isNotEmpty) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', accessToken);

          if (refreshToken != null) {
            await prefs.setString('refresh_token', refreshToken);
          }

          print("✅ Login Success! Tokens saved.");
          return true;
        }
      }
      return false;
    } catch (e) {
      print("Login Error: $e");
      return false;
    }
  }

  // -------------------- LOGOUT --------------------
  Future<void> logout() async {
    print("--- LOGOUT ATTEMPT ---");
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    // 1. Call API to invalidate session on server
    try {
      if (token != null) {
        await http.post(
          Uri.parse(logoutUrl),
          headers: {
            "Authorization": "Bearer $token" // Tell server WHO is logging out
          },
        );
      }
    } catch (e) {
      print("Logout API Warning: $e"); // Continue logging out locally even if API fails
    }

    // 2. WIPE DATA (Crucial!)
    await prefs.clear();
    print("✅ Local Data Cleared. User logged out.");
  }

  // -------------------- REFRESH TOKEN --------------------
  Future<bool> tryRefreshToken() async {
    print("--- REFRESHING TOKEN ---");
    final prefs = await SharedPreferences.getInstance();
    final oldAccess = prefs.getString('auth_token');
    final oldRefresh = prefs.getString('refresh_token');

    if (oldAccess == null || oldRefresh == null) return false;

    try {
      final response = await http.post(
        Uri.parse(refreshUrl),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "AccessToken": oldAccess,
          "RefreshToken": oldRefresh
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final newAccess = data['Value']?['accessToken'];
        final newRefresh = data['Value']?['Token'];

        if (newAccess != null) {
          await prefs.setString('auth_token', newAccess);
          if (newRefresh != null) {
            await prefs.setString('refresh_token', newRefresh);
          }
          print("✅ Token Refreshed!");
          return true;
        }
      }
      return false;
    } catch (e) {
      print("Refresh Failed: $e");
      return false;
    }
  }
}

// -------------------- CONTROLLER --------------------
class AuthController extends StateNotifier<AsyncValue<void>> {
  final AuthService _authService;

  AuthController(this._authService) : super(const AsyncValue.data(null));

  Future<bool> login(String email, String password) async {
    state = const AsyncValue.loading();
    final request = LoginRequest(email: email, password: password);
    final success = await _authService.login(request);

    if (success) {
      state = const AsyncValue.data(null);
      return true;
    } else {
      state = AsyncValue.error("Invalid Email or Password", StackTrace.current);
      return false;
    }
  }

  Future<void> logout() async {
    await _authService.logout();
    // After this, your UI should check the token and redirect to Login
  }
}

// -------------------- PROVIDERS --------------------
final authServiceProvider = Provider((ref) => AuthService());

final authControllerProvider = StateNotifierProvider<AuthController, AsyncValue<void>>((ref) {
  final authService = ref.watch(authServiceProvider);
  return AuthController(authService);
});