// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import '../login_signup page/login.dart';
// import '../homepage.dart';
//
// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});
//
//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     _checkSession();
//   }
//
//   Future<void> _checkSession() async {
//     await Future.delayed(const Duration(seconds: 2));
//     final prefs = await SharedPreferences.getInstance();
//
//     if (mounted) {
//       // One-line logic: If token exists -> Home, else -> Login
//       Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//           builder: (_) => prefs.getString('auth_token') != null
//               ? const Homepage()
//               : LoginPage(),
//         ),
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     return Scaffold(
//       backgroundColor: Colors.red,
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.asset(
//               "lib/images/GNW_WHITE_LOGO.png",
//               width: size.width * 0.45,
//               height: size.width * 0.45,
//               fit: BoxFit.contain,
//             ),
//             // SizedBox(height: ResponsiveHelper.getSpacing(context, baseSpacing: 5)),
//             SizedBox(height: size.height * 0.02),
//         Text(
//           "No.1 Search App for\nGreater Noida West",
//           textAlign: TextAlign.center,
//           style: TextStyle(
//             // Scales font size based on screen width
//             fontSize: size.width * 0.048,
//             fontWeight: FontWeight.bold,
//             color: Colors.white,
//             fontStyle: FontStyle.italic,
//             height: 1.2, // Adjusts the gap between the two lines
//           ),
//         ),
//             // SizedBox(height: ResponsiveHelper.getSpacing(context, baseSpacing: 30)),
//             // const CircularProgressIndicator(color: Colors.white),
//           ],
//         ),
//       ),
//     );
//   }
// }




import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // 🚀 Added Riverpod
import 'package:shared_preferences/shared_preferences.dart';

import '../homepage.dart';
import '../services/auth_provider.dart';
// 🚀 DHYAN DEIN: Apni AuthService/Provider wali file yahan zaroor import karein
// import '../services/auth_provider.dart'; // Path apne hisaab se adjust kar lein

// 🚀 StatefulWidget ko ConsumerStatefulWidget mein badla hai taaki 'ref' use kar sakein
class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _performAutoLogin();
  }

  Future<void> _performAutoLogin() async {
    // 2 second ka delay taaki user ko Splash Screen ka design dikhe
    await Future.delayed(const Duration(seconds: 1));

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    // Agar token nahi hai (matlab naya user hai), toh background me Guest Login call karo
    if (token == null || token.isEmpty) {
      try {
        // Apne provider ka naam check kar lena agar alag ho toh
        await ref.read(authControllerProvider.notifier).AutoLogin();
      } catch (e) {
        print("Splash Screen Auto Login Error: $e");
      }
    }

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Homepage()),
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
            SizedBox(height: size.height * 0.02),
            Text(
              "No.1 Search App for\nGreater Noida West",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: size.width * 0.048,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontStyle: FontStyle.italic,
                height: 1.2,
              ),
            ),
            // Agar aap loading indicator dikhana chahte hain toh isko uncomment kar sakte hain
            // SizedBox(height: size.height * 0.05),
            // const CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}