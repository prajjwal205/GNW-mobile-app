import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../login_signup page/login_model.dart'; // Ensure this matches your folder structure

// --- SERVICE LAYER ---
class AuthService {
  static const String domain = "http://gnwbazaar-002-site2.qtempurl.com";

  // Endpoints
  static const String loginUrl = "$domain/GNW_Login";
  static const String signupUrl = "$domain/GNW_Signup";

  // Forgot Password Flow Endpoints
  static const String generateOtpUrl = "$domain/GNW_GenerateOtp";
  static const String validateOtpUrl = "$domain/GNW_ValidateOtp";
  static const String resetPassUrl = "$domain/GNW_ForgotPassword";

  // --- 1. LOGIN ---
  Future<Map<String, dynamic>> login(String email, String password) async {
    print("🔹 LOGIN REQUEST: $email");
    try {
      final response = await http.post(
        Uri.parse(loginUrl),
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {
          "Email": email,
          "Password": password,
        },
      );

      print("🔸 Status Code: ${response.statusCode}");
      print("🔸 Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final accessToken = data['Value']?['accessToken'];
        final refreshToken = data['Value']?['Token'];

        if (accessToken != null) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setString('auth_token', accessToken);
          if (refreshToken != null) await prefs.setString('refresh_token', refreshToken);

          return {"success": true, "message": "Login Successful"};
        }
      }

      try {
        final errorData = jsonDecode(response.body);
        return {"success": false, "message": errorData['Message'] ?? "Invalid Credentials"};
      } catch (_) {
        return {"success": false, "message": "Server Error: ${response.statusCode}"};
      }

    } catch (e) {
      print("❌ Error: $e");
      return {"success": false, "message": "Connection Error: $e"};
    }
  }

  // --- 2. SIGNUP ---
  Future<Map<String, dynamic>> signup(String name, String email, String phone, String password) async {
    print("🔹 SIGNUP REQUEST: $email");
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

      print("🔸 Status Code: ${response.statusCode}");
      print("🔸 Body: ${response.body}");

      if (response.statusCode == 200) {
        return {"success": true, "message": "Signup Successful"};
      } else {
        final data = jsonDecode(response.body);
        return {
          "success": false,
          "message": data['Message'] ?? "Signup Failed (Code: ${response.statusCode})"
        };
      }
    } catch (e) {
      print("❌ Error: $e");
      return {"success": false, "message": "Connection Error: $e"};
    }
  }

  // --- 3. GENERATE OTP (Step 1 of Forgot Password) ---
  // --- 3. GENERATE OTP (Step 1) ---
  Future<Map<String, dynamic>> generateOtp(String email) async {
    try {
      final response = await http.post(
        Uri.parse(generateOtpUrl),
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {
          "Email": email,
          "Purpose": "PasswordReset"
        },
      );

      print("Generate OTP Status: ${response.statusCode}");
      print("Response Body: ${response.body}"); // Debugging

      // SUCCESS
      if (response.statusCode == 200) {
        return {"success": true, "message": "OTP Sent Successfully"};
      }

      // UNAUTHORIZED (401)
      if (response.statusCode == 401) {
        return {"success": false, "message": "Server Error: Unauthorized (401). API might be protected."};
      }

      // OTHER ERRORS
      // Safely try to decode JSON, otherwise return status code
      try {
        if (response.body.isNotEmpty) {
          final data = jsonDecode(response.body);
          return {"success": false, "message": data['Message'] ?? "Server Error: ${response.statusCode}"};
        }
      } catch (_) {}

      return {"success": false, "message": "Server Error: ${response.statusCode}"};

    } catch (e) {
      return {"success": false, "message": "Connection Error: $e"};
    }
  }

  // --- 4. VALIDATE OTP (Step 2 of Forgot Password) ---
  Future<Map<String, dynamic>> validateOtp(String email, String otp) async {
    try {
      final response = await http.post(
        Uri.parse(validateOtpUrl),
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {
          "Email": email,
          "OtpCode": otp
        },
      );

      print("Validate OTP Status: ${response.statusCode}");

      if (response.statusCode == 200) {
        return {"success": true, "message": "OTP Verified"};
      }
      final data = jsonDecode(response.body);
      return {"success": false, "message": data['Message'] ?? "Invalid OTP"};
    } catch (e) {
      return {"success": false, "message": "Connection Error: $e"};
    }
  }

  // --- 5. RESET PASSWORD (Step 3 of Forgot Password) ---
  Future<Map<String, dynamic>> resetPassword(String email, String newPassword) async {
    try {
      final response = await http.post(
        Uri.parse(resetPassUrl),
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {
          "Email": email,
          "NewPassword": newPassword
        },
      );

      print("Reset Password Status: ${response.statusCode}");

      if (response.statusCode == 200) {
        return {"success": true, "message": "Password Reset Successful"};
      }
      final data = jsonDecode(response.body);
      return {"success": false, "message": data['Message'] ?? "Reset Failed"};
    } catch (e) {
      return {"success": false, "message": "Connection Error: $e"};
    }
  }

  // --- LOGOUT ---
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}

// --- VIEWMODEL ---
class AuthController extends StateNotifier<AsyncValue<void>> {
  final AuthService _authService;

  AuthController(this._authService) : super(const AsyncValue.data(null));

  // 1. LOGIN
  Future<String?> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) return "Please enter email and password";

    state = const AsyncValue.loading();
    final result = await _authService.login(email, password);
    state = const AsyncValue.data(null);

    if (result['success'] == true) {
      return null;
    } else {
      return result['message'];
    }
  }

  // 2. SIGNUP
  Future<String?> signup({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String confirmPassword,
  }) async {
    if (name.isEmpty || email.isEmpty || phone.isEmpty || password.isEmpty) {
      return "Please fill all fields";
    }
    if (password != confirmPassword) {
      return "Passwords do not match";
    }

    state = const AsyncValue.loading();
    final result = await _authService.signup(name, email, phone, password);
    state = const AsyncValue.data(null);

    if (result['success'] == true) {
      return null;
    } else {
      return result['message'];
    }
  }

  // 3. GENERATE OTP (Step 1)
  Future<String?> generateOtp(String email) async {
    if (email.isEmpty) return "Enter email address";
    state = const AsyncValue.loading();
    final result = await _authService.generateOtp(email);
    state = const AsyncValue.data(null);

    return result['success'] == true ? null : result['message'];
  }

  // 4. VALIDATE OTP (Step 2)
  Future<String?> validateOtp(String email, String otp) async {
    if (otp.length != 4) return "OTP must be 4 digits";
    state = const AsyncValue.loading();
    final result = await _authService.validateOtp(email, otp);
    state = const AsyncValue.data(null);

    return result['success'] == true ? null : result['message'];
  }

  // 5. RESET PASSWORD (Step 3)
  Future<String?> resetPassword(String email, String newPass, String confirmPass) async {
    if (newPass.isEmpty || confirmPass.isEmpty) return "Enter new password";
    if (newPass != confirmPass) return "Passwords do not match";

    state = const AsyncValue.loading();
    final result = await _authService.resetPassword(email, newPass);
    state = const AsyncValue.data(null);

    return result['success'] == true ? null : result['message'];
  }

  Future<void> logout() async {
    await _authService.logout();
  }
}

// --- PROVIDERS ---
final authServiceProvider = Provider((ref) => AuthService());

final authControllerProvider = StateNotifierProvider<AuthController, AsyncValue<void>>((ref) {
  return AuthController(ref.watch(authServiceProvider));
});