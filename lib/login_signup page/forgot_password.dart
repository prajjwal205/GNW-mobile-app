import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/auth_provider.dart';
import '../login_signup page/login.dart';
import '../utils/responsive_helper.dart';

class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() =>
      _ForgotPasswordPageState();
}

class _ForgotPasswordPageState
    extends ConsumerState<ForgotPasswordPage> {

  final _emailController = TextEditingController();
  final _otpController = TextEditingController();
  final _newPassController = TextEditingController();
  final _confirmPassController = TextEditingController();

  bool _otpSent = false;
  bool _loading = false;
  bool _success = false;

  String? _message;
  Color _messageColor = Colors.red;

  final _border =
  OutlineInputBorder(borderRadius: BorderRadius.circular(8));

  //  SEND OTP
  Future<void> _sendOtp() async {
    setState(() {
      _loading = true;
      _message = null;
    });

    final error = await ref
        .read(authControllerProvider.notifier)
        .generateOtp(_emailController.text.trim());

    setState(() {
      _loading = false;
      if (error == null) {
        _otpSent = true;
        _message = "OTP sent to your email";
        _messageColor = Colors.green;
      } else {
        _message = error;
        _messageColor = Colors.red;
      }
    });
  }

  Future<void> _resetPassword() async {
    setState(() {
      _loading = true;
      _message = null;
    });

    final error = await ref
        .read(authControllerProvider.notifier)
        .resetPassword(
      email: _emailController.text.trim(),
      otp: _otpController.text.trim(),
      newPass: _newPassController.text,
      confirmPass: _confirmPassController.text,
    );

    if (error == null) {
      setState(() => _success = true);

      Timer(const Duration(seconds: 2), () {
        if (mounted) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => LoginPage()),
                (_) => false,
          );
        }
      });
    } else {
      setState(() {
        _loading = false;
        _message = error;
        _messageColor = Colors.red;
      });
    }
  }

  // ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    if (_success) {
      return _successScreen();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [

              Column(
                children: [
                  const SizedBox(height: 30),
                  Image.asset(
                    "lib/images/GNW_RED_LOGO.png",
                    height: ResponsiveHelper.screenHeight(context) * 0.10,
                    width: ResponsiveHelper.screenWidth(context) * 0.4,
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "No.1 Search Engine in \n Greater Noida West",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),

              const SizedBox(height: 30),

              const Text(
                "Forgot Password",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),

              const SizedBox(height: 20),

              // EMAIL + SEND OTP
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: "Email ID",
                        border: _border,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: _loading ? null : _sendOtp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "SEND OTP",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // OTP FIELD
              if (_otpSent)
                TextField(
                  controller: _otpController,
                  keyboardType: TextInputType.number,
                  maxLength: 4,
                  decoration: InputDecoration(
                    hintText: "Enter OTP",
                    counterText: "",
                    border: _border,
                  ),
                ),

              const SizedBox(height: 10),

              if (_message != null)
                Text(
                  _message!,
                  style: TextStyle(
                    color: _messageColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),

              const SizedBox(height: 20),

              if (_otpSent)
                Column(
                  children: [
                    TextField(
                      controller: _newPassController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "New Password",
                        border: _border,
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _confirmPassController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Confirm Password",
                        border: _border,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _loading ? null : _resetPassword,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        minimumSize:
                        const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "RESET PASSWORD",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _successScreen() {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.check_circle,
                color: Colors.green, size: 80),
            SizedBox(height: 20),
            Text(
              "Password Changed Successfully",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Redirecting to login...",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
