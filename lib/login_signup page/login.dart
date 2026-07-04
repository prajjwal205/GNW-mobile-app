
import 'package:flutter/cupertino.dart'; // 🚀 Cupertino import for iOS widgets
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gnw/login_signup%20page/create.dart';
import 'package:gnw/login_signup%20page/forgot_password.dart';
import '../homepage.dart';
import '../services/auth_provider.dart';
import '../utils/responsive_helper.dart';

class LoginPage extends ConsumerStatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  bool _isPasswordVisible = false;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // 🚀 Native iOS Style Alert Dialog Helper
  void _showIOSAlert(String title, String message) {
    if (!mounted) return;
    showCupertinoDialog(
      context: context,
      builder: (context) => CupertinoAlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          CupertinoDialogAction(
            isDefaultAction: true,
            child: const Text("OK", style: TextStyle(color: Colors.blue)),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  void handleLogin() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showIOSAlert("Missing Details", "Please enter both email and password.");
      return;
    }

    bool isEmailValid = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);

    if (!isEmailValid) {
      _showIOSAlert("Invalid Email", "Please double check your Email address.");
      return;
    }

    final String? error = await ref.read(authControllerProvider.notifier).login(email, password);
    if (mounted) {
      if (error == null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const Homepage()),
        );
      } else {
        _showIOSAlert("Login Failed", error);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    ref.listen(authControllerProvider, (previous, next) {
      if (next.hasError) {
        _showIOSAlert("Error", next.error.toString());
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: ResponsiveHelper.screenWidth(context) * 0.05,
          ),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Column(
                    children: [
                      Image.asset(
                        "lib/images/GNW_RED_LOGO.png",
                        height: ResponsiveHelper.screenHeight(context) * 0.150,
                        width: ResponsiveHelper.screenWidth(context) * 0.4,
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        "No.1 Search APP for \n Greater Noida West",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),

                  SizedBox(height: ResponsiveHelper.screenHeight(context) * 0.04),
                  const Text(
                    "Login here",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "Welcome back you've \n been missed!",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: ResponsiveHelper.screenHeight(context) * 0.03),

                  // 🚀 iOS Style Email Field
            TextFormField(
                    controller: emailController,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.emailAddress,
                    autofillHints: const [AutofillHints.email], // Google Auto-fill support
                    decoration: InputDecoration(
                      labelText: "Email", // Changed from Mobile to Email
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                  SizedBox(height:ResponsiveHelper.screenHeight(context) * 0.03),

                  TextFormField(
                    controller: passwordController,
                    obscureText: !_isPasswordVisible,
                    textInputAction: TextInputAction.done, // Keyboard mein 'Done/Submit' button aayega
                    onFieldSubmitted: (value) => handleLogin(),// Keyboard se enter marne par direct login
                    decoration: InputDecoration(
                      labelText: "Password",

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(builder: (context) => const SignupPage()), // iOS transition
                          );
                        },
                        child: const Text(
                          "New User?",
                          style: TextStyle(color: CupertinoColors.activeBlue, fontSize: 14),
                        ),
                      ),
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        onPressed: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(builder: (context) => const ForgotPasswordPage()), // iOS transition
                          );
                        },
                        child: const Text(
                          "Forgot your password?",
                          style: TextStyle(color: CupertinoColors.systemGrey, fontSize: 14),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: ResponsiveHelper.screenHeight(context) * 0.03),

                  // 🚀 iOS Style Button & Loading Indicator
                  authState.isLoading
                      ? const CupertinoActivityIndicator(radius: 16) // Native iOS Spinner
                      : SizedBox(
                    width: double.infinity,
                    child: CupertinoButton(
                      color: Colors.red, // GNW Theme Color
                      borderRadius: BorderRadius.circular(30),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      onPressed: handleLogin,
                      child: const Text(
                        "Sign in",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}