import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// 🚀 Niche apne login page ka exact path update kar lijiye
import '../login_signup page/create.dart';
import '../login_signup page/login.dart';

class LoginCheck {
  // 🚀 Class aur file ka naam aapke hisaab se update kar diya
  static Future<void> executeIfLoggedIn(BuildContext context, VoidCallback action) async {
    final prefs = await SharedPreferences.getInstance();

    // Yahan apni Token key check kar lijiye
    final token = prefs.getString('token'); // Ya jo bhi key aap use kar rahe hain

    if (token != null && token.isNotEmpty) {
      // ✅ User logged in hai, uska click kiya hua action chalne do
      action();
    } else {
      // ❌ User logged in NAHI hai
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Please Login / Signup to connect!"),
            backgroundColor: Colors.orange,
            duration: Duration(seconds: 2),
          ),
        );

        // Seedha Login Page par bhej do
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SignupPage()),
        );
      }
    }
  }
}