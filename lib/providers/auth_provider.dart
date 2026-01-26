import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../login_signup page/login_model.dart';

class AuthService {
  static const String domain = "http://gnwbazaar-002-site2.qtempurl.com";

  // Endpoints
  static const String loginUrl = "$domain/GNW_Login";
  static const String signupUrl = "$domain/GNW_Signup";
  static const String generateOtpUrl = "$domain/GNW_GenerateOtp";
  static const String resetPassUrl = "$domain/GNW_ForgotPassword";

  // 1. LOGIN Method
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(loginUrl),
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {
          "Email": email,
          "Password": password,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final accessToken = data['Value']?['accessToken'];
        final refreshToken = data['Value']?['Token'];

        if (accessToken != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', accessToken);
          if (refreshToken != null) {
            await prefs.setString('refresh_token', refreshToken);
          }
          return {"success": true};
        }
      }

      final data = jsonDecode(response.body);
      return {
        "success": false,
        "message": data['Message'] ?? "Invalid Credentials"
      };
    } catch (e) {
      return {"success": false, "message": "Connection Error"};
    }
  }

  // 2. Signup Method
  Future<Map<String, dynamic>> signup(
      String name, String email, String phone, String password) async {
    try {
      final response = await http.post(
        Uri.parse(signupUrl),
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {
          "Name": name,
          "Email": email,
          "PhoneNumber": phone,
          "Password": password,
          "UserRole": "user"
        },
      );

      if (response.statusCode == 200) {
        return {"success": true};
      }

      final data = jsonDecode(response.body);
      return {
        "success": false,
        "message": data['Message'] ?? "Signup Failed"
      };
    } catch (e) {
      return {"success": false, "message": "Connection Error"};
    }
  }

  Future<Map<String, dynamic>> generateOtp(String email) async {
    try {
      final response = await http.post(
        Uri.parse(generateOtpUrl),
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {
          "Email": email,
          "Purpose": "PasswordReset",
        },
      );

      if (response.statusCode == 200) {
        return {"success": true};
      }

      final data = jsonDecode(response.body);
      return {
        "success": false,
        "message": data['Message'] ?? "Failed to send OTP"
      };
    } catch (e) {
      return {"success": false, "message": "Connection Error"};
    }
  }

  // 4. RESET PASSWORD (OTP + NEW PASSWORD)
  Future<Map<String, dynamic>> resetPassword({
    required String email,
    required String otp,
    required String newPassword,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(resetPassUrl),
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {
          "Email": email,
          "OtpCode": otp,
          "Password": newPassword,
          "Purpose": "PasswordReset",
        },
      );

      final data = jsonDecode(response.body);

      if (data['ResponseCode'] == 200) {
        return {"success": true};
      } else {
        return {
          "success": false,
          "message": data['Message'] ?? "Invalid OTP",
        };
      }
    } catch (e) {
      return {"success": false, "message": "Connection Error"};
    }
  }



  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}

// VIEWMODEL Architecture
class AuthController extends StateNotifier<AsyncValue<void>> {
  final AuthService _authService;

  AuthController(this._authService)
      : super(const AsyncValue.data(null));

  Future<String?> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      return "Please enter email and password";
    }

    state = const AsyncValue.loading();
    final result = await _authService.login(email, password);
    state = const AsyncValue.data(null);

    return result['success'] == true ? null : result['message'];
  }

  // SIGNUP model class
  Future<String?> signup({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String confirmPassword,
  }) async {
    if (password != confirmPassword) {
      return "Passwords do not match";
    }

    state = const AsyncValue.loading();
    final result =
    await _authService.signup(name, email, phone, password);
    state = const AsyncValue.data(null);

    return result['success'] == true ? null : result['message'];
  }

  // GENERATE OTP
  Future<String?> generateOtp(String email) async {
    if (email.isEmpty) return "Enter email address";

    state = const AsyncValue.loading();
    final result = await _authService.generateOtp(email);
    state = const AsyncValue.data(null);

    return result['success'] == true ? null : result['message'];
  }

  // RESET PASSWORD (OTP + PASSWORD)
  Future<String?> resetPassword({
    required String email,
    required String otp,
    required String newPass,
    required String confirmPass,
  }) async {
    if (otp.length != 4) return "Enter valid OTP";
    if (newPass != confirmPass) return "Passwords do not match";

    state = const AsyncValue.loading();
    final result = await _authService.resetPassword(
      email: email,
      otp: otp,
      newPassword: newPass,
    );
    state = const AsyncValue.data(null);

    return result['success'] == true ? null : result['message'];
  }

  Future<void> logout() async {
    await _authService.logout();
  }
}

//PROVIDERS
final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final authControllerProvider =
StateNotifierProvider<AuthController, AsyncValue<void>>((ref) {
  return AuthController(ref.watch(authServiceProvider));
});
