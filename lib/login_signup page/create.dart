import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/auth_provider.dart'; // Go up 2 levels to find providers
import '../../utils/responsive_helper.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  // Only UI Controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isConfirmVisible = false;

  InputDecoration _buildInputDecoration(String label) {
    return InputDecoration(
      label: RichText(
        text: TextSpan(
          text: label,
          style: TextStyle(color: Colors.grey[700], fontSize: 16),
          children: const [
            TextSpan(
              text: ' *',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
    );
  }

  void handleSignup() async {
    final String? error = await ref.read(authControllerProvider.notifier).signup(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      password: _passwordController.text,
      confirmPassword: _confirmController.text,
    );

    if (mounted) {
      if (error == null) {
        Future<void> showSuccessDialog() async {
          await showDialog(
              context: context,
              barrierDismissible: false, // User cannot click outside to close
              builder: (ctx) {
                Future.delayed(const Duration(seconds: 3), () {
                  if (ctx.mounted) {
                    Navigator.of(ctx).pop();
                  }
                });

                return Dialog(
                  backgroundColor: CupertinoColors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal: 20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // The Animated Checkmark Circle
                        TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.0, end: 1.0),
                          duration: const Duration(milliseconds: 800),
                          curve: Curves.elasticOut, // Gives it the "pop" effect
                          builder: (context, value, child) {
                            return Transform.scale(
                              scale: value,
                              child: Container(
                                height: 80,
                                width: 80,
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.check_rounded,
                                  color: Colors.white,
                                  size: 50,
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 25),
                        const Text(
                          "Success!",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Account created",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                );
              }
          );
        }

        await showSuccessDialog();

        // After dialog closes, navigate back to Login page
        if (mounted) {
          Navigator.pop(context);
        }

      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(error), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch state to show spinner
    final authState = ref.watch(authControllerProvider);
    final inputBorder = OutlineInputBorder(borderRadius: BorderRadius.circular(30));

    return Scaffold(
      backgroundColor: CupertinoColors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: ResponsiveHelper.screenWidth(context) * 0.05),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Image.asset("lib/images/GNW_RED_LOGO.png", height: 100),
                  const SizedBox(height: 20),

                  const Text("Create Account", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red)),
                  const SizedBox(height: 30),

                  // Inputs
                  TextField(controller: _nameController, decoration: _buildInputDecoration("Full Name"),),
                  const SizedBox(height: 15),
                  TextField(controller: _emailController, keyboardType: TextInputType.emailAddress,
                    decoration: _buildInputDecoration("Email"),),
                  const SizedBox(height: 15),
                  TextField(
                    controller: _phoneController,
                    maxLength: 10,
                    keyboardType: TextInputType.phone,
                    decoration: _buildInputDecoration("Mobile").copyWith(counterText: ""),
                  ),                  const SizedBox(height: 15),

                  // Passwords
                  TextField(
                    controller: _passwordController,
                    obscureText: !_isPasswordVisible,
                    decoration: _buildInputDecoration("Password").copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(_isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () => setState(
                                () => _isPasswordVisible = !_isPasswordVisible),
                      ),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // 5. CONFIRM PASSWORD
                  TextField(
                    controller: _confirmController,
                    obscureText: !_isConfirmVisible,
                    decoration: _buildInputDecoration("Confirm Password").copyWith(
                      suffixIcon: IconButton(
                        icon: Icon(_isConfirmVisible
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () => setState(
                                () => _isConfirmVisible = !_isConfirmVisible),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  authState.isLoading
                      ? const CircularProgressIndicator(color: Colors.red)
                      : ElevatedButton(
                    onPressed: handleSignup,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    child: const Text("Sign Up", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account?"),
                      TextButton(onPressed: () => Navigator.pop(context), child: const Text("Login", style: TextStyle(color: Colors.blueAccent))),
                    ],
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