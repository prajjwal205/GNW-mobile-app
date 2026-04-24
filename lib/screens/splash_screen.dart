import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../login_signup page/login.dart';
import '../homepage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    await Future.delayed(const Duration(seconds: 2));
    final prefs = await SharedPreferences.getInstance();

    if (mounted) {
      // One-line logic: If token exists -> Home, else -> Login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => prefs.getString('auth_token') != null
              ? const Homepage()
              : LoginPage(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.red,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "lib/images/GNW_WHITE_LOGO.png",
              width: size.width * 0.45,
              height: size.width * 0.45,
              fit: BoxFit.contain,
            ),
            // SizedBox(height: ResponsiveHelper.getSpacing(context, baseSpacing: 5)),
            SizedBox(height: size.height * 0.02),
        Text(
          "No.1 Search App for\nGreater Noida West",
          textAlign: TextAlign.center,
          style: TextStyle(
            // Scales font size based on screen width
            fontSize: size.width * 0.048,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontStyle: FontStyle.italic,
            height: 1.2, // Adjusts the gap between the two lines
          ),
        ),
            // SizedBox(height: ResponsiveHelper.getSpacing(context, baseSpacing: 30)),
            // const CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}