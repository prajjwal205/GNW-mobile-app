import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/responsive_helper.dart';
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
    return Scaffold(
      backgroundColor: Colors.red,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "lib/images/GNW_WHITE_LOGO.png",
              width: ResponsiveHelper.getIconSize(context, baseSize: 180),
              height: ResponsiveHelper.getIconSize(context, baseSize: 180),
            ),
            SizedBox(height: ResponsiveHelper.getSpacing(context, baseSpacing: 20)),
            Text(
              "No.1 Search Engine in Greater Noida West",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: ResponsiveHelper.getFontSize(context, baseSize: 16),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: ResponsiveHelper.getSpacing(context, baseSpacing: 30)),
            const CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}