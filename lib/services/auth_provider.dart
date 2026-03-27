import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gnw/Models/category_model.dart';
import 'package:gnw/Models/doctor_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gnw/Models/healthcare_model.dart';

import '../Models/client_model.dart';

class AuthService {
  static const String domain = "https://gnwbazaar-002-site2.qtempurl.com";

  // Endpoints
  static const String loginUrl = "$domain/GNW_Login";
  static const String signupUrl = "$domain/GNW_Signup";
  static const String refreshUrl = "$domain/GNW_RefreshToken";
  static const String generateOtpUrl = "$domain/GNW_GenerateOtp";
  static const String resetPassUrl = "$domain/GNW_ForgotPassword";
  static const String categoryUrl = "$domain/GetAll_CategoryMaster";
  static const String healthcareUrl = "$domain/GetAll_HealthCare_Category";
  static const String clientUrl = "$domain/GetAll_Client";
  static const String doctorUrl = "$domain/GetAll_Doctor";

  // 1. LOGIN Method
  Future<Map<String, dynamic>> login(
      String email,
      String password,
      ) async {
    try {

      final response = await http.post(
        Uri.parse(loginUrl),
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: {
          "Email": email,
          "Password": password,
        },
      );
      print("STATUS = ${response.statusCode}");
      print("BODY = ${response.body}");
      if (response.body.isEmpty) {
        return {
          "success": false,
          "message": "Empty response",
        };
      }
      final data = jsonDecode(response.body);
      if (data["ResponseCode"] == 200) {
        final accessToken = data["Value"]["accessToken"];
        final refreshToken = data["Value"]["Token"];
        print("ACCESS TOKEN = $accessToken");
        print("REFRESH TOKEN = $refreshToken");
        final prefs =
        await SharedPreferences.getInstance();
        await prefs.setString(
            "auth_token", accessToken);
        if (refreshToken != null) {
          await prefs.setString(
              "refresh_token", refreshToken);
        }
        await prefs.setString(
            "user_name",
            data["Value"]["Name"] ?? "");

        return {"success": true};
      }
      return {
        "success": false,
        "message": data["Message"],
      };
    } catch (e) {
      print("LOGIN ERROR = $e");

      return {
        "success": false,
        "message": e.toString(),
      };
    }
  }


  Future<bool> refreshToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final oldRefreshToken = prefs.getString('refresh_token') ?? '';

      print("=== REFRESH TOKEN PROCESS STARTED ===");
      print("OLD REFRESH TOKEN: $oldRefreshToken");

      if (oldRefreshToken.isEmpty) {
        print("❌ Refresh token is empty in SharedPreferences. Cannot refresh.");
        return false;
      }

      // 🚀 FIX 1: Using standard http.post instead of MultipartRequest (Matches your Login method)
      final response = await http.post(
        Uri.parse(refreshUrl),
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: {
          // ⚠️ DHYAN DEIN: Apne backend developer se confirm karein ki unhe yahan kya key chahiye.
          // ('Token', 'token', 'refreshToken', ya kuch aur)
          "Token": oldRefreshToken,
        },
      );

      print("REFRESH API HTTP STATUS: ${response.statusCode}");
      print("REFRESH API RESPONSE BODY: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // 🚀 FIX 2: Checking custom ResponseCode just like Login
        if (data['ResponseCode'] == 200) {
          final newAccessToken = data['Value']?['accessToken'];
          final newRefreshToken = data['Value']?['Token'];

          print("✅ SUCCESSFULLY REFRESHED!");
          print("NEW ACCESS TOKEN: $newAccessToken");

          if (newAccessToken != null) {
            await prefs.setString('auth_token', newAccessToken);
          }

          if (newRefreshToken != null) {
            await prefs.setString('refresh_token', newRefreshToken);
          }

          return true;
        } else {
          // Agar API ne 200 diya par andar se Token invalid bola
          print("❌ Backend rejected refresh token: ${data['Message']}");
          return false;
        }
      } else {
        print("❌ Refresh API HTTP Error: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("❌ Exception in refreshToken logic: $e");
      return false;
    }
  }

  // Future<bool> refreshToken() async {
  //   try {
  //     final prefs = await SharedPreferences.getInstance();
  //     final refreshToken = prefs.getString('refresh_token') ?? '';
  //
  //     if (refreshToken.isEmpty) return false;
  //
  //     var request = http.MultipartRequest(
  //       'POST',
  //       Uri.parse(refreshUrl),
  //     );
  //
  //     request.fields['token'] = refreshToken;
  //
  //     var response = await request.send();
  //
  //     if (response.statusCode == 200) {
  //       var res = await http.Response.fromStream(response);
  //       final data = jsonDecode(res.body);
  //
  //       final newAccessToken = data['Value']?['accessToken'];
  //       final newRefreshToken = data['Value']?['Token'];
  //
  //       if (newAccessToken != null) {
  //         await prefs.setString('auth_token', newAccessToken);
  //       }
  //
  //       if (newRefreshToken != null) {
  //         await prefs.setString('refresh_token', newRefreshToken);
  //       }
  //
  //       return true;
  //     }
  //
  //     return false;
  //   } catch (e) {
  //     print("Refresh error: $e");
  //     return false;
  //   }
  // }
  Future<http.Response> authorizedGet(String url) async {
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('auth_token') ?? '';
    print("TOKEN : = ${token}, end");


    var response = await http.get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 401) {
      bool refreshed = await refreshToken();

      if (refreshed) {
        token = prefs.getString('auth_token') ?? '';


        response = await http.get(
          Uri.parse(url),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer $token",
          },
        );
      } else {
        // refresh failed → logout
        await logout();
      }
    }

    return response;
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
      final auth = AuthService();

      final response = await auth.authorizedGet(categoryUrl);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['Value'] != null && data['Value'] is List) {
          final list = data['Value'] as List;
          return list.map((e) => CategoryModel.fromJson(e)).toList();
        }
      }

      return [];
    } catch (e) {
      print("Error fetching categories: $e");
      return [];
    }
  }

  static Future<String> fetchUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_name') ?? "Prajjwal";
  }



  static Future<List<HealthcareCategoryModel>> fetchHealthcareCategories() async {
    try {
      final auth = AuthService();

      final response = await auth.authorizedGet(healthcareUrl);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['Value'] != null && data['Value'] is List) {
          final list = data['Value'] as List;
          return list
              .map((item) => HealthcareCategoryModel.fromJson(item))
              .toList();
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
      final auth = AuthService();

      final response = await auth.authorizedGet(clientUrl);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['Value'] != null && data['Value'] is List) {
          final list = data['Value'] as List;
          return list.map((e) => ClientModel.fromJson(e)).toList();
        }
      }

      return [];
    } catch (e) {
      return [];
    }
  }


  // fetch doctors

  static Future<List<DoctorModel>> fetchDoctor() async {
    try {
      final auth = AuthService();

      final response = await auth.authorizedGet(doctorUrl);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['Value'] != null && data['Value'] is List) {
          final list = data['Value'] as List;
          return list.map((e) => DoctorModel.fromJson(e)).toList();
        }
      }

      return [];
    } catch (e) {
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

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final authControllerProvider =
StateNotifierProvider<AuthController, AsyncValue<void>>((ref) {
  return AuthController(ref.watch(authServiceProvider));
});


//
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:gnw/Models/category_model.dart';
// import 'package:gnw/Models/doctor_model.dart';
// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:gnw/Models/healthcare_model.dart';
// import '../Models/client_model.dart';
//
// class AuthService {
//   static const String domain = "https://gnwbazaar-002-site2.qtempurl.com";
//
//   // Endpoints
//   static const String loginUrl = "$domain/GNW_Login";
//   static const String signupUrl = "$domain/GNW_Signup";
//   static const String refreshUrl = "$domain/GNW_RefreshToken";
//   static const String generateOtpUrl = "$domain/GNW_GenerateOtp";
//   static const String resetPassUrl = "$domain/GNW_ForgotPassword";
//   static const String categoryUrl = "$domain/GetAll_CategoryMaster";
//   static const String healthcareUrl = "$domain/GetAll_HealthCare_Category";
//   static const String clientUrl = "$domain/GetAll_Client";
//   static const String doctorUrl = "$domain/GetAll_Doctor";
//
//   // ===========================================================================
//   // 1. LOGIN
//   // ===========================================================================
//   Future<Map<String, dynamic>> login(String email, String password) async {
//     try {
//       final response = await http.post(
//         Uri.parse(loginUrl),
//         headers: {
//           "Content-Type": "application/x-www-form-urlencoded",
//         },
//         body: {
//           "Email": email,
//           "Password": password,
//         },
//       );
//
//       if (response.body.isEmpty) {
//         return {"success": false, "message": "Empty response"};
//       }
//
//       final data = jsonDecode(response.body);
//
//       if (data["ResponseCode"] == 200) {
//         final accessToken = data["Value"]["accessToken"];
//         final refreshToken = data["Value"]["Token"];
//         // Extract UserId from backend (Adjust key if backend uses 'Id' instead of 'UserId')
//         final userId = data["Value"]["UserId"] ?? data["Value"]["Id"];
//
//         // 🚀 CONSOLE PRINTS FOR POSTMAN TESTING
//         print("\n=== 🟢 LOGIN SUCCESS: TOKENS FOR POSTMAN ===");
//         print("ACCESS_TOKEN: $accessToken");
//         print("REFRESH_TOKEN: $refreshToken");
//         print("USER_ID: $userId");
//         print("============================================\n");
//
//         final prefs = await SharedPreferences.getInstance();
//
//         await prefs.setString("auth_token", accessToken ?? "");
//         if (refreshToken != null) {
//           await prefs.setString("refresh_token", refreshToken);
//         }
//         if (userId != null) {
//           await prefs.setString("user_id", userId.toString());
//         }
//         await prefs.setString("user_name", data["Value"]["Name"] ?? "");
//
//         return {"success": true};
//       }
//
//       return {"success": false, "message": data["Message"]};
//     } catch (e) {
//       print("LOGIN ERROR = $e");
//       return {"success": false, "message": e.toString()};
//     }
//   }
//
//   // ===========================================================================
//   // 2. REFRESH TOKEN (Fixed with UserId)
//   // ===========================================================================
//   Future<bool> refreshToken() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       final oldRefreshToken = prefs.getString('refresh_token') ?? '';
//       final userIdStr = prefs.getString('user_id') ?? '';
//
//       print("\n=== 🔄 ATTEMPTING REFRESH TOKEN ===");
//       print("SENDING USER_ID: $userIdStr");
//       print("SENDING OLD TOKEN: $oldRefreshToken");
//
//       if (oldRefreshToken.isEmpty || userIdStr.isEmpty) {
//         print("❌ Cannot refresh: Missing token or UserId in local storage.");
//         return false;
//       }
//
//       final response = await http.post(
//         Uri.parse(refreshUrl),
//         headers: {
//           "Content-Type": "application/x-www-form-urlencoded",
//         },
//         body: {
//           "UserId": userIdStr,
//           "Token": oldRefreshToken,
//         },
//       );
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//
//         if (data['ResponseCode'] == 200) {
//           final newAccessToken = data['Value']?['accessToken'];
//           final newRefreshToken = data['Value']?['Token'];
//
//           print("✅ REFRESH SUCCESS! NEW TOKENS FOR POSTMAN:");
//           print("NEW ACCESS_TOKEN: $newAccessToken");
//           print("NEW REFRESH_TOKEN: $newRefreshToken");
//           print("===================================\n");
//
//           if (newAccessToken != null) {
//             await prefs.setString('auth_token', newAccessToken);
//           }
//           if (newRefreshToken != null) {
//             await prefs.setString('refresh_token', newRefreshToken);
//           }
//           return true;
//         } else {
//           print("❌ Backend rejected refresh token: ${data['Message']}");
//         }
//       } else {
//         print("❌ Refresh API failed with Status: ${response.statusCode}");
//       }
//       return false;
//     } catch (e) {
//       print("❌ Refresh error: $e");
//       return false;
//     }
//   }
//
//   // ===========================================================================
//   // 3. AUTHORIZED GET (Handles 401 Auto-Refresh)
//   // ===========================================================================
//   Future<http.Response> authorizedGet(String url) async {
//     final prefs = await SharedPreferences.getInstance();
//     String token = prefs.getString('auth_token') ?? '';
//
//     print("🌐 API GET CALL: $url");
//     print("🔑 USING TOKEN: $token");
//
//     var response = await http.get(
//       Uri.parse(url),
//       headers: {
//         "Content-Type": "application/json",
//         "Authorization": "Bearer $token",
//       },
//     );
//
//     if (response.statusCode == 401) {
//       print("⚠️ 401 Unauthorized! Triggering Refresh Token...");
//       bool refreshed = await refreshToken();
//
//       if (refreshed) {
//         token = prefs.getString('auth_token') ?? '';
//         print(" Retrying API GET call with NEW token...");
//         response = await http.get(
//           Uri.parse(url),
//           headers: {
//             "Content-Type": "application/json",
//             "Authorization": "Bearer $token",
//           },
//         );
//       } else {
//         print("🚨 Refresh failed! Logging user out.");
//         await logout();
//       }
//     }
//
//     return response;
//   }
//
//   // ===========================================================================
//   // 4. FETCH METHODS (Strict Error Handling Added)
//   // ===========================================================================
//
//   static Future<List<CategoryModel>> fetchCategories() async {
//     try {
//       final auth = AuthService();
//       final response = await auth.authorizedGet(categoryUrl);
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         if (data['ResponseCode'] != null && data['ResponseCode'] != 200) {
//           throw Exception(data['Message'] ?? "API Error");
//         }
//         if (data['Value'] != null && data['Value'] is List) {
//           return (data['Value'] as List).map((e) => CategoryModel.fromJson(e)).toList();
//         }
//         return [];
//       } else if (response.statusCode == 401) {
//         throw Exception("Session Expired. Please login again.");
//       } else {
//         throw Exception("Server Error: ${response.statusCode}");
//       }
//     } catch (e) {
//       print("❌ Error fetching categories: $e");
//       rethrow; // Forces Riverpod into Error State
//     }
//   }
//
//   static Future<List<HealthcareCategoryModel>> fetchHealthcareCategories() async {
//     try {
//       final auth = AuthService();
//       final response = await auth.authorizedGet(healthcareUrl);
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         if (data['ResponseCode'] != null && data['ResponseCode'] != 200) {
//           throw Exception(data['Message'] ?? "API Error");
//         }
//         if (data['Value'] != null && data['Value'] is List) {
//           return (data['Value'] as List).map((item) => HealthcareCategoryModel.fromJson(item)).toList();
//         }
//         return [];
//       } else if (response.statusCode == 401) {
//         throw Exception("Session Expired. Please login again.");
//       } else {
//         throw Exception("Server Error: ${response.statusCode}");
//       }
//     } catch (e) {
//       print("❌ Error fetching healthcare: $e");
//       rethrow;
//     }
//   }
//
//   static Future<List<ClientModel>> fetchAllClients() async {
//     try {
//       final auth = AuthService();
//       final response = await auth.authorizedGet(clientUrl);
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         if (data['ResponseCode'] != null && data['ResponseCode'] != 200) {
//           throw Exception(data['Message'] ?? "API Error");
//         }
//         if (data['Value'] != null && data['Value'] is List) {
//           return (data['Value'] as List).map((e) => ClientModel.fromJson(e)).toList();
//         }
//         return [];
//       } else if (response.statusCode == 401) {
//         throw Exception("Session Expired. Please login again.");
//       } else {
//         throw Exception("Server Error: ${response.statusCode}");
//       }
//     } catch (e) {
//       print("❌ Error fetching clients: $e");
//       rethrow;
//     }
//   }
//
//   static Future<List<DoctorModel>> fetchDoctor() async {
//     try {
//       final auth = AuthService();
//       final response = await auth.authorizedGet(doctorUrl);
//
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         if (data['ResponseCode'] != null && data['ResponseCode'] != 200) {
//           throw Exception(data['Message'] ?? "API Error");
//         }
//         if (data['Value'] != null && data['Value'] is List) {
//           return (data['Value'] as List).map((e) => DoctorModel.fromJson(e)).toList();
//         }
//         return [];
//       } else if (response.statusCode == 401) {
//         throw Exception("Session Expired. Please login again.");
//       } else {
//         throw Exception("Server Error: ${response.statusCode}");
//       }
//     } catch (e) {
//       print("❌ Error fetching doctors: $e");
//       rethrow;
//     }
//   }
//
//   // ===========================================================================
//   // 5. OTHER AUTH METHODS
//   // ===========================================================================
//
//   static Future<String> fetchUserName() async {
//     final prefs = await SharedPreferences.getInstance();
//     return prefs.getString('user_name') ?? "Prajjwal";
//   }
//
//   Future<Map<String, dynamic>> signup(String name, String email, String phone, String password) async {
//     try {
//       final response = await http.post(
//         Uri.parse(signupUrl),
//         headers: {"Content-Type": "application/x-www-form-urlencoded"},
//         body: {
//           "Name": name, "Email": email, "PhoneNumber": phone,
//           "Password": password, "UserRole": "user"
//         },
//       );
//       if (response.statusCode == 200) {
//         final prefs = await SharedPreferences.getInstance();
//         await prefs.setString('user_name', name);
//         await prefs.setString('user_email', email);
//         await prefs.setString('user_phone', phone);
//         return {"success": true};
//       }
//       final data = jsonDecode(response.body);
//       return {"success": false, "message": data['Message'] ?? "Signup Failed"};
//     } catch (e) {
//       return {"success": false, "message": "Connection Error"};
//     }
//   }
//
//   Future<Map<String, dynamic>> generateOtp(String email) async {
//     try {
//       final response = await http.post(
//         Uri.parse(generateOtpUrl),
//         headers: {"Content-Type": "application/x-www-form-urlencoded"},
//         body: {"Email": email, "Purpose": "PasswordReset"},
//       );
//       if (response.statusCode == 200) {
//         return {"success": true};
//       }
//       final data = jsonDecode(response.body);
//       return {"success": false, "message": data['Message'] ?? "Failed to send OTP"};
//     } catch (e) {
//       return {"success": false, "message": "Connection Error"};
//     }
//   }
//
//   Future<Map<String, dynamic>> resetPassword({required String email, required String otp, required String newPassword}) async {
//     try {
//       final response = await http.post(
//         Uri.parse(resetPassUrl),
//         headers: {"Content-Type": "application/x-www-form-urlencoded"},
//         body: {"Email": email, "OtpCode": otp, "Password": newPassword, "Purpose": "PasswordReset"},
//       );
//       final data = jsonDecode(response.body);
//       if (data['ResponseCode'] == 200) {
//         return {"success": true};
//       } else {
//         return {"success": false, "message": data['Message'] ?? "Invalid OTP"};
//       }
//     } catch (e) {
//       return {"success": false, "message": "Connection Error"};
//     }
//   }
//
//   Future<void> logout() async {
//     final prefs = await SharedPreferences.getInstance();
//     await prefs.clear();
//   }
// }
//
// // ===========================================================================
// // VIEWMODEL ARCHITECTURE (Riverpod)
// // ===========================================================================
// class AuthController extends StateNotifier<AsyncValue<void>> {
//   final AuthService _authService;
//
//   AuthController(this._authService) : super(const AsyncValue.data(null));
//
//   Future<String?> login(String email, String password) async {
//     if (email.isEmpty || password.isEmpty) return "Please enter email and password";
//     state = const AsyncValue.loading();
//     final result = await _authService.login(email, password);
//     state = const AsyncValue.data(null);
//     return result['success'] == true ? null : result['message'];
//   }
//
//   Future<String?> signup({required String name, required String email, required String phone, required String password, required String confirmPassword}) async {
//     if (password != confirmPassword) return "Passwords do not match";
//     state = const AsyncValue.loading();
//     final result = await _authService.signup(name, email, phone, password);
//     state = const AsyncValue.data(null);
//     return result['success'] == true ? null : result['message'];
//   }
//
//   Future<String?> generateOtp(String email) async {
//     if (email.isEmpty) return "Enter email address";
//     state = const AsyncValue.loading();
//     final result = await _authService.generateOtp(email);
//     state = const AsyncValue.data(null);
//     return result['success'] == true ? null : result['message'];
//   }
//
//   Future<String?> resetPassword({required String email, required String otp, required String newPass, required String confirmPass}) async {
//     if (otp.length != 4) return "Enter valid OTP";
//     if (newPass != confirmPass) return "Passwords do not match";
//     state = const AsyncValue.loading();
//     final result = await _authService.resetPassword(email: email, otp: otp, newPassword: newPass);
//     state = const AsyncValue.data(null);
//     return result['success'] == true ? null : result['message'];
//   }
//
//   Future<void> logout() async {
//     await _authService.logout();
//   }
// }
//
// final authServiceProvider = Provider<AuthService>((ref) {
//   return AuthService();
// });
//
// final authControllerProvider = StateNotifierProvider<AuthController, AsyncValue<void>>((ref) {
//   return AuthController(ref.watch(authServiceProvider));
// });