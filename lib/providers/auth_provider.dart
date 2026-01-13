// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import '../login_signup page/login_model.dart'; // Ensure this path matches your folder name exactly
//
// // --- SERVICE LAYER (Talks to the Internet) ---
// class AuthService {
//   static const String domain = "http://gnwbazaar-002-site2.qtempurl.com";
//
//   Future<Object> login(String email, String password) async {
//     try {
//       final response = await http.post(
//         Uri.parse("$domain/GNW_Login"),
//         headers: {"Content-Type": "application/x-www-form-urlencoded"},
//         body: {
//           "Email": email,
//           "Password": password,
//         },
//       );
//       // 🖨️ PRINT LOGS
//       print("🔸 Status Code: ${response.statusCode}");
//       print("🔸 Body: ${response.body}");
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         final accessToken = data['Value']?['accessToken'];
//         final refreshToken = data['Value']?['Token'];
//
//         if (accessToken != null) {
//           final prefs = await SharedPreferences.getInstance();
//           await prefs.setString('auth_token', accessToken);
//           if (refreshToken != null) await prefs.setString('refresh_token', refreshToken);
//           // return true; // here chaninging
//           return {"success": true, "message": "Login Successful"};
//         }
//       }
//       return false;
//     } catch (e) {
//       return false;
//     }
//   }
//
//   Future<bool> signup(String name, String email, String phone, String password) async {
//     try {
//       final response = await http.post(
//         Uri.parse("$domain/GNW_Signup"),
//         headers: {"Content-Type": "application/x-www-form-urlencoded"},
//         body: {
//           "Name": name,
//           "Email": email,
//           "PhoneNumber": phone,
//           "Password": password,
//           "UserRole": "user"
//         },
//       );
//       // 🖨️ PRINT LOGS
//       print("🔸 Status Code: ${response.statusCode}");
//       print("🔸 Body: ${response.body}");
//       return response.statusCode == 200;
//     } catch (e) {
//       return false;
//     }
//   }
//
//   Future<bool> forgotPassword(String email) async {
//     try {
//       final response = await http.post(
//         Uri.parse("$domain/GNW_ForgotPassword"),
//         headers: {"Content-Type": "application/x-www-form-urlencoded"},
//         body: {
//           "Email": email,
//         },
//       );
//       return response.statusCode == 200;
//     } catch (e) {
//       return false;
//     }
//   }
//
//   Future<void> logout() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.clear();
//   }
// }
//
// // --- VIEWMODEL (The 'Brain' - Handles Validation & State) ---
// class AuthController extends StateNotifier<AsyncValue<void>> {
//   final AuthService _authService;
//
//   AuthController(this._authService) : super(const AsyncValue.data(null));
//
//   // 1. LOGIN LOGIC
//   Future<String?> login(String email, String password) async {
//     if (email.isEmpty || password.isEmpty) return "Please enter email and password";
//
//     state = const AsyncValue.loading();
//     final result = await _authService.login(email, password);
//     state = const AsyncValue.data(null);
//
// // FIX: Explicit check == true
//     if (result['success'] == true) {
//       return null;
//     } else {
//       return result['message'];
//     }  }
//
//   // 2. SIGNUP LOGIC (Validation happens here, not in UI)
//   Future<String?> signup({
//     required String name,
//     required String email,
//     required String phone,
//     required String password,
//     required String confirmPassword,
//   }) async {
//     if (name.isEmpty || email.isEmpty || phone.isEmpty || password.isEmpty) {
//       return "Please fill all fields";
//     }
//     if (password != confirmPassword) {
//       return "Passwords do not match";
//     }
//
//     state = const AsyncValue.loading();
//     final success = await _authService.signup(name, email, phone, password);
//     state = const AsyncValue.data(null);
//
//     return success ? null : "Signup Fald - Please try again.";
//   }
//
//   // 3. FORGOT PASSWORD LOGIC
//   Future<String?> forgotPassword(String email) async {
//     if (email.isEmpty) return "Please enter your email";
//
//     state = const AsyncValue.loading();
//     final success = await _authService.forgotPassword(email);
//     state = const AsyncValue.data(null);
//
//     return success ? null : "Request failed. Please verify your email.";
//   }
//
//   Future<void> logout() async {
//     await _authService.logout();
//   }
// }
//
// // --- PROVIDERS ---
// final authServiceProvider = Provider((ref) => AuthService());
//
// final authControllerProvider = StateNotifierProvider<AuthController, AsyncValue<void>>((ref) {
//   return AuthController(ref.watch(authServiceProvider));
// });



import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../login_signup page/login_model.dart';

// --- SERVICE LAYER ---
class AuthService {
  static const String domain = "http://gnwbazaar-002-site2.qtempurl.com";

  // --- LOGIN ---
  Future<Map<String, dynamic>> login(String email, String password) async {
    print("🔹 LOGIN REQUEST: $email");
    try {
      final url = Uri.parse("$domain/GNW_Login");
      final response = await http.post(
        url,
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

  // --- SIGNUP ---
  Future<Map<String, dynamic>> signup(String name, String email, String phone, String password) async {
    print("🔹 SIGNUP REQUEST: $email");
    try {
      final url = Uri.parse("$domain/GNW_Signup");
      final response = await http.post(
        url,
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

  // --- FORGOT PASSWORD ---
  Future<bool> forgotPassword(String email) async {
    try {
      final response = await http.post(
        Uri.parse("$domain/GNW_ForgotPassword"),
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {"Email": email},
      );
      print("Forgot Pass Status: ${response.statusCode}");
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

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

    // FIX: Explicit check == true
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

    // FIX: Explicit check == true (This is likely Line 101)
    if (result['success'] == true) {
      return null;
    } else {
      return result['message'];
    }
  }

  // 3. FORGOT PASSWORD
  Future<String?> forgotPassword(String email) async {
    if (email.isEmpty) return "Please enter your email";

    state = const AsyncValue.loading();
    final success = await _authService.forgotPassword(email);
    state = const AsyncValue.data(null);

    return success ? null : "Request failed. Please verify your email.";
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