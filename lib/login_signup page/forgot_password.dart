import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart';
import '../../utils/responsive_helper.dart';

class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final _emailController = TextEditingController();

  void handleReset() async {
    // 1. Delegate Logic to ViewModel
    final String? error = await ref.read(authControllerProvider.notifier).forgotPassword(
        _emailController.text.trim()
    );

    // 2. Handle UI Result
    if (mounted) {
      if (error == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Reset Link Sent! Check your email."), backgroundColor: Colors.green),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final inputBorder = OutlineInputBorder(borderRadius: BorderRadius.circular(30));

    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent, elevation: 0, iconTheme: const IconThemeData(color: Colors.black)),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.screenWidth(context) * 0.05),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Image.asset("lib/images/GNW_RED_LOGO.png", height: 100),
                  const SizedBox(height: 20),
                  const Text("Forgot Password", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red)),
                  const SizedBox(height: 10),
                  const Text("Enter your email to receive a reset link", textAlign: TextAlign.center),
                  const SizedBox(height: 40),

                  TextField(controller: _emailController, decoration: InputDecoration(labelText: "Email Address", border: inputBorder)),
                  const SizedBox(height: 30),

                  authState.isLoading
                      ? const CircularProgressIndicator(color: Colors.red)
                      : ElevatedButton(
                    onPressed: handleReset,
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        minimumSize: const Size(double.infinity, 50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))
                    ),
                    child: const Text("Send Reset Link", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
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