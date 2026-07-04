import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gnw/Models/Sponsor_model.dart';
import 'package:gnw/Models/category_model.dart';
import 'package:gnw/Models/client_model.dart';
import 'package:gnw/Models/doctor_model.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gnw/Models/healthcare_model.dart';

import '../Models/Profile_Model_class.dart';
import '../Models/SubCategoryModel.dart';
// import '../pages/ProfilePage.dart';

class AuthService {
  static const String domain = "https://gnwbazaar.in/apigateway";

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
  static const String sponsorUrl = "$domain/GetAll_Sponsor";
  static const String SubCategory = "$domain/GetAll_SubCategoryMaster";
  static const String validateOtpUrl = "$domain/GNW_ValidateOtp"; // Naya endpoint
  static const String premiumSpotlight = "$domain/GetByCategoryMaster_Sponsor";
  static const String profilePage = "$domain/Get_User";



  Future<Map<String, dynamic>> login(
      String email,
      String password,
      ) async {
    try {
      // 1. LOGIN KI API CALL
      final response = await http.post(
        Uri.parse(loginUrl),
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {"Email": email, "Password": password},
      );

      if (response.body.isEmpty) return {"success": false, "message": "Empty response"};
      final data = jsonDecode(response.body);

      if (data["ResponseCode"] == 200) {
        final accessToken = data["Value"]["accessToken"];
        final refreshToken = data["Value"]["Token"];

        // Yahan se humein User ki ID mil gayi (Jaise 2)
        final UserId = data["Value"]["Id"].toString();

        final prefs = await SharedPreferences.getInstance();
        if(UserId != "null") await prefs.setString("user_id", UserId);
        await prefs.setString("auth_token", accessToken);
        if (refreshToken != null) await prefs.setString("refresh_token", refreshToken);

        try {
          final profileUrl = "$domain/Get_User/$UserId";
          final profileResponse = await http.get(
              Uri.parse(profileUrl),
              headers: {
                "Content-Type": "application/json",
                "Authorization": "Bearer $accessToken"
              }
          );

          if (profileResponse.statusCode == 200) {
            final profileData = jsonDecode(profileResponse.body);
            if (profileData["ResponseCode"] == 200 && profileData["Value"] != null) {
              final val = profileData["Value"];

              // ✅ AB YAHAN SE ASLI DETAILS SAVE HONGI
              await prefs.setString("user_name", val["Name"] ?? "");
              await prefs.setString("user_email", val["Email"] ?? "");

              // Asli PhoneNumber save ho raha hai!
              await prefs.setString("user_phone", val["PhoneNumber"] ?? "");
            }
          }
        } catch (profileError) {
        }

        return {"success": true};
      }
      return {"success": false, "message": data["Message"]};
    } catch (e) {
      return {"success": false, "message": e.toString()};
    }
  }

  Future<bool> AutoLogin() async{
    try{
      const String guestEmail = "gnwbazaar@gmail.com";
      const String Password = "Noida@1234";
      final  result = await login(guestEmail, Password);
      if (result['success'] == true){
        return true;
      }
      else{
        return false;
      }
    } catch(e){
      return false;
    }
  }

   Future<bool> refreshToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final oldRefreshToken = prefs.getString('refresh_token') ?? '';

      if (oldRefreshToken.isEmpty) {
        return false;
      }


      final response = await http.post(
        Uri.parse(refreshUrl),
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        body: {
          // ('Token', 'token', 'refreshToken', ya  aur)
          "Token": oldRefreshToken,
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['ResponseCode'] == 200) {
          final newAccessToken = data['Value']?['accessToken'];
          final newRefreshToken = data['Value']?['Token'];

          if (newAccessToken != null) {
            await prefs.setString('auth_token', newAccessToken);
          }

          if (newRefreshToken != null) {
            await prefs.setString('refresh_token', newRefreshToken);
          }

          return true;
        } else {

          return false;
        }
      } else {
        return false;
      }
    } catch (e) {
      // print(" Exception in refreshToken logic: $e");
      return false;
    }
   }


   Future<http.Response> authorizedGet(String url) async {
    final prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('auth_token') ?? '';
    // print("TOKEN : = ${token}, end");


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
        // print("TOKEN : = ${token}, end");


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
        // print("🔥🔥 BACKEND RESPONSE: ${phone}");

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
          "Purpose": "ForgotPassword",
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

   Future<Map<String, dynamic>> validateOtp(String email, String otp) async {
    try {
      final response = await http.post(
        Uri.parse(validateOtpUrl),
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {
          "Email": email,
          "Otp": otp,
          "Purpose": "ForgotPassword",
        },
      );
      final data = jsonDecode(response.body);
      // Backend 'Value' mein true/false bhej raha hai
      return {"success": data["ResponseCode"] == 200 && data["Value"] == true, "message": data["Message"]};
    } catch (e) { return {"success": false, "message": "Connection Error"}; }
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
      // print("Error fetching categories: $e");
      return [];
    }
    }

   static Future<String> fetchUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_name') ?? "GNW";
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
    // required String otp,
    required String newPassword,
  }) async {
    try {
      final response = await http.post(
        Uri.parse(resetPassUrl),
        headers: {"Content-Type": "application/x-www-form-urlencoded"},
        body: {
          "Email": email,
          // "OtpCode": otp,
          "Password": newPassword,
          "Purpose": "ForgotPassword",
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


 static Future<List<ClientModel>> ClientData(int subCategoryId) async{
    try{
      final auth = AuthService();
      final String url = "$clientUrl?subCategoryId=$subCategoryId";
      final res = await auth.authorizedGet(url);
      if(res.statusCode == 200){
        final data = jsonDecode(res.body);
        if(data['Value'] != null && data['Value'] is List){
          final list = data['Value'] as List;
          return  list
              .map((e) => ClientModel.fromJson(e))
              .where((client) => client.subCategoryIds.contains(subCategoryId))
              .toList();
        }
      }
      return [];
    } catch (e){
      // print("Error fetching clients: $e");
      return [];
    }
}


// FETCH ALL CLIENTS (Global Search ke liye)
  static Future<List<ClientModel>> fetchAllClients() async {
    try {
      final auth = AuthService();

      // clientUrl upar define hai: "$domain/GetAll_Client"
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
      // print("Error fetching all clients: $e");
      return [];
    }
  }


  static Future<Map<String, String>?> fetchAndSyncUserProfile() async {
    final prefs = await SharedPreferences.getInstance();

    // Memory se ID aur Token nikal rahe hain
    final String? userId = prefs.getString("user_id");
    final String? token = prefs.getString("auth_token");

    if (userId == null || token == null) return null;

    try {
      final url = "$profilePage/$userId";
      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token", // Token bhej rahe hain security ke liye
        },
      );

      if (response.statusCode == 200) {
        final data = ProfileResponseModel.fromJson(jsonDecode(response.body));

        if (data.responseCode == 200 && data.value != null) {
          final user = data.value!;

          // API se aayi asali values
          final name = user.name;
          final email = user.email;
          final phone = user.phoneNumber;

          // Backend data ko local memory me update karo
          await prefs.setString("user_name", name);
          await prefs.setString("user_email", email);
          await prefs.setString("user_phone", phone);

          return {
            "name": name,
            "email": email,
            "phone": phone
          };
        }
      }
    } catch (e) {
      // print("Profile Fetch Error: $e");
    }
    return null;
  }

  // 2. Local Memory se data nikalna (Taaki profile page instantly load ho jaye)
  static Future<Map<String, String>> getLocalProfileData() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      "name": prefs.getString("user_name") ?? "",
      "email": prefs.getString("user_email") ?? "",
      "phone": prefs.getString("user_phone") ?? "",
      "gender": prefs.getString("gender") ?? "Male",
      "image": prefs.getString("profile_image") ?? "",
    };
  }

  // 3. User ka naya data (Gender, Image) phone ki memory me save karna
  static Future<void> saveLocalProfileData(String gender, String? imagePath) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("gender", gender);
    if (imagePath != null) {
      await prefs.setString("profile_image", imagePath);
    }
  }

  // 4. Logout Logic (Sara user data clear karne ke liye)
  static Future<void> clearDataOnLogout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }


  static Future<List<SubCategoryModel>> fetchAllSubCategories() async {
    try {
      final auth = AuthService();
      // Calling the base SubCategory endpoint to get all of them
      final response = await auth.authorizedGet(SubCategory);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['Value'] != null && data['Value'] is List) {
          final list = data['Value'] as List;
          return list.map((e) => SubCategoryModel.fromJson(e)).toList();
        }
      }
      return [];
    } catch (e) {
      // print("Error fetching all subcategories: $e");
      return [];
    }
  }
// baki categories ki sub category ki hai ye
  static Future<List<SubCategoryModel>> OtherSubCategory(int categoryMasterId) async{
    try{
      final auth = AuthService();
      final String url = "$SubCategory?categoryId=$categoryMasterId";
      final res = await auth.authorizedGet(url);
      if(res.statusCode == 200){
        final data = jsonDecode(res.body);
        if(data['Value'] !=null && data['Value'] is List){
          final list = data['Value'] as List;
          return list
              .map((e) => SubCategoryModel.fromJson(e))
              .where((sub) => sub.categoryMasterId == categoryMasterId)
              .toList();        }
      }
      return[];
    }catch (e) {
      // print("Error fetching subcategories: $e");
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


  static Future<List<SponsorModel>> fetchSponsor() async{
    try {
      final auth = AuthService();
      final response = await auth.authorizedGet(sponsorUrl);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (response.statusCode != 200) {
          throw Exception("Server Error");
        }
        if (data['Value'] != null && data['Value'] is List) {
          final list = data['Value'] as List;
          final DateTime now = DateTime.now();
          List<SponsorModel> validSponsors = [];
          for (var item in list) {
            try {
              SponsorModel sponsor = SponsorModel.fromJson(item);
              if (!sponsor.isActive) continue;
              if (sponsor.startDate != null && sponsor.endDate != null) {
                bool isStarted = now.isAfter(sponsor.startDate!) ||
                    now.isAtSameMomentAs(sponsor.startDate!);
                bool isNotExpired = now.isBefore(sponsor.endDate!);
                if (!isStarted || !isNotExpired) continue;
              }
              validSponsors.add(sponsor);
            } catch (modelError) {
              // Agar ek specific item parse karne me error aaye, to pura app crash na ho
              // print("Error Showing single sponsor image: $modelError");
            }
          }
          return validSponsors;
        }
        return [];
      } else if (response.statusCode == 401) {
        throw Exception("Session Expired. Please login again.");
      } else {
        throw Exception("Server Error: ${response.statusCode}");
      }
    }catch (e) {
      // print(" Error fetching sponsors: $e");
      rethrow;
    }
  }




  // ... (Aapka fetchSponsor() method yahan par hai) ...

  // 🚀 NAYA METHOD: Category ID ke hisaab se Sponsors fetch karne ke liye
  static Future<List<SponsorModel>> fetchSponsorsByCategory(int categoryId) async {
    try {
      final auth = AuthService();
      // Ocelot Gateway ka Upstream Path use kar rahe hain
      final String url = "$domain/GetByCategoryMaster_Sponsor/$categoryId";
      final response = await auth.authorizedGet(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['Value'] != null && data['Value'] is List) {
          final list = data['Value'] as List;

          final DateTime now = DateTime.now();
          List<SponsorModel> validSponsors = [];

          for (var item in list) {
            try {
              SponsorModel sponsor = SponsorModel.fromJson(item);
              // Agar active nahi hai toh chhod do
              if (!sponsor.isActive) continue;

              // Date filter
              if (sponsor.startDate != null && sponsor.endDate != null) {
                bool isStarted = now.isAfter(sponsor.startDate!) || now.isAtSameMomentAs(sponsor.startDate!);
                bool isNotExpired = now.isBefore(sponsor.endDate!);
                if (!isStarted || !isNotExpired) continue;
              }
              validSponsors.add(sponsor);
            } catch (e) {
              // Ignore single item error
            }
          }
          return validSponsors;
        }
      }
      return [];
    } catch (e) {
      return [];
    }
  }




  static Future<List<SponsorModel>> fetchSponsorCategory(int categoryId) async {
    try {
      final auth = AuthService();
      final String url = "$premiumSpotlight/$categoryId";
      final res = await auth.authorizedGet(url);
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (data['Value'] != null && data['Value'] is List) {
          final list = data['Value'] as List;
          final DateTime now = DateTime.now();
          List<SponsorModel> validSponsors = [];
          for (var item in list) {
            try {
              SponsorModel sponsor = SponsorModel.fromJson(item);
              if (!sponsor.isActive) continue;

              if (sponsor.startDate != null && sponsor.endDate != null) {
                bool isStarted = now.isAfter(sponsor.startDate!) ||
                    now.isAtSameMomentAs(sponsor.startDate!);
                bool isNotExpired = now.isBefore(sponsor.endDate!);
                if (!isStarted || !isNotExpired) continue;
              }
              validSponsors.add(sponsor);
            } catch (e) {
              // Ignore single item error
            }
          }
          return validSponsors;
        }
      }
      return [];
    }
    catch (e) {
      return [];
    }
  }
  // ... (iske neeche aapka logout() method hai) ...
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

    return result['success'] == true ? null : result['messagen'];
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


  Future<bool>AutoLogin() async{
    state = const AsyncValue.loading();
    final isSucess = await _authService.AutoLogin();
    state = const AsyncValue.data(null);
    return isSucess;
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
      // otp: otp,
      newPassword: newPass,
    );
    state = const AsyncValue.data(null);
    return result['success'] == true ? null : result['message'];
  }

  Future<void> logout() async {
    await _authService.logout();
  }

  Future<String?> validateOtp(
      {required String email, required String otp}) async {
    state = const AsyncValue.loading();
    final result = await _authService.validateOtp(email, otp);
    state = const AsyncValue.data(null);
    return result['success'] == true ? null : result['message'];
  }

}

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final authControllerProvider =
StateNotifierProvider<AuthController, AsyncValue<void>>((ref) {
  return AuthController(ref.watch(authServiceProvider));
});
