import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gnw/Models/category_model.dart';
import 'package:gnw/Models/doctor_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gnw/Models/healthcare_model.dart';

import '../Models/client_model.dart';

class AuthService {
  static const String domain = "http://gnwbazaar-002-site2.qtempurl.com";

  // Endpoints
  static const String loginUrl = "$domain/GNW_Login";
  static const String signupUrl = "$domain/GNW_Signup";
  static const String generateOtpUrl = "$domain/GNW_GenerateOtp";
  static const String resetPassUrl = "$domain/GNW_ForgotPassword";
  static const String categoryUrl = "$domain/GetAll_CategoryMaster";
  static const String healthcareUrl = "$domain/GetAll_HealthCare_Category";
  static const String clientUrl = "$domain/GetAll_Client";
  static const String doctorUrl = "$domain/GetAll_Doctor";

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
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_name', name);
        await prefs.setString('user_email', email);
        await prefs.setString('user_phone', phone);

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



  static Future<List<CategoryModel>> fetchCategories() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String token = prefs.getString('auth_token') ?? '';

      print("Using Token: $token");

      final response = await http.get(
        Uri.parse(categoryUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      print("Categories Status: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['Value'] != null && data['Value'] is List) {
          final list = data['Value'] as List;
          return list.map((item) => CategoryModel.fromJson(item)).toList();
        }
        return [];
        }
        else {
        throw Exception("Server Error: ${response.statusCode} - ${response.reasonPhrase}");        }
    } catch (e) {
      print("Error fetching categories: $e");
      throw e;
    }
  }

  static Future<String> fetchUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_name') ?? "Prajjwal";
  }



  static Future<List<HealthcareCategoryModel>> fetchHealthcareCategories() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String token = prefs.getString('auth_token') ?? '';

      final response = await http.get(
        Uri.parse(healthcareUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['Value'] != null && data['Value'] is List) {
          final list = data['Value'] as List;
          return list.map((item) => HealthcareCategoryModel.fromJson(item)).toList();
        }
      }
      return [];
    } catch (e) {
      return [];
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

  static Future<List<ClientModel>> fetchAllClients() async {
    try {
      // 1. Get the Token
      final prefs = await SharedPreferences.getInstance();
      final String token = prefs.getString('auth_token') ?? '';

      // 2. Send Request WITH Token
      final response = await http.get(
        Uri.parse(clientUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token", // <--- THIS IS CRITICAL
        },
      );

      print("Client API Status: ${response.statusCode}"); // Debug Print
      print("Client API Body: ${response.body}");         // Debug Print

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['Value'] != null && data['Value'] is List) {
          final list = data['Value'] as List;
          return list.map((item) => ClientModel.fromJson(item)).toList();
        }
      }
      return [];
    } catch (e) {
      print("Error fetching clients: $e");
      return [];
    }
  }


  // fetch doctors

  static Future<List<DoctorModel>> fetchDoctor() async{
    try{
      final prefs = await SharedPreferences.getInstance();
      final String token = prefs.getString('auth_token')??'';

      final response = await http.get(
        Uri.parse(doctorUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        }
      );
      print("Doctor API status ${response.statusCode}");
      if(response.statusCode == 200){
        final data = jsonDecode(response.body);
        print(" Doctors list: ${response.body}");

        if(data['Value'] != null && data['Value'] is List){
          final List<dynamic> rawList = data['Value'];
          return rawList.map((item)=> DoctorModel.fromJson(item)).toList();
        }
        print(" Doctors list: ${response.body}");

      }
    return [];
    }
    catch (e) {
    print("Error fetching doctors: $e");
    return [];
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
