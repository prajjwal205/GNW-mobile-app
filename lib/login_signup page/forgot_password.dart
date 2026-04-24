import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/auth_provider.dart';
import '../login_signup page/login.dart';
import '../utils/responsive_helper.dart';

class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final _emailController = TextEditingController();
  final List<TextEditingController> _otpControllers = List.generate(4, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());

  final _newPassController = TextEditingController();
  final _confirmPassController = TextEditingController();

  bool _otpSent = false;
  bool _otpVerified = false;
  bool _loading = false;
  bool _success = false;

  Timer? _timer;
  int _start = 300;

  String? _message;
  Color _messageColor = Colors.red;

  // 🚀 MODERN ADVANCED UI BORDERS
  final _border = OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
  );
  final _focusedBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(12),
    borderSide: const BorderSide(color: Colors.grey, width: 2),
  );

  void startTimer() {
    _timer?.cancel();
    _start = 300;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() => timer.cancel());
      } else {
        setState(() => _start--);
      }
    });
  }

  String get timerText {
    int minutes = _start ~/ 60;
    int seconds = _start % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  Future<void> _sendOtp() async {
    if (_emailController.text.isEmpty) return;
    setState(() { _loading = true; _message = null; });

    final error = await ref.read(authControllerProvider.notifier).generateOtp(_emailController.text.trim());

    setState(() {
      _loading = false;
      if (error == null) {
        _otpSent = true;
        _message = "OTP sent to your email";
        _messageColor = Colors.green;
        startTimer();
      } else {
        _message = error;
        _messageColor = Colors.red;
      }
    });
  }

  Future<void> _verifyOtp() async {
    String enteredOtp = _otpControllers.map((e) => e.text.trim()).join();
    if (enteredOtp.length < 4) return;

    setState(() { _loading = true; _message = null; });

    final error = await ref.read(authControllerProvider.notifier).validateOtp(
      email: _emailController.text.trim(),
      otp: enteredOtp,
    );

    setState(() {
      _loading = false;
      if (error == null) {
        _otpVerified = true;
        _message = "OTP Verified!";
        _messageColor = Colors.green;
      } else {
        _message = error;
        _messageColor = Colors.red;
      }
    });
  }

  Future<void> _resetPassword() async {
    setState(() { _loading = true; _message = null; });

    final error = await ref.read(authControllerProvider.notifier).resetPassword(
      email: _emailController.text.trim(),
      otp: _otpControllers.map((e) => e.text.trim()).join(),
      newPass: _newPassController.text.trim(),
      confirmPass: _confirmPassController.text.trim(),
    );

    if (error == null) {
      setState(() => _success = true);
      Timer(const Duration(seconds: 2), () {
        if (mounted) {
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => LoginPage()), (_) => false);
        }
      });
    } else {
      setState(() { _loading = false; _message = error; _messageColor = Colors.red; });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_success) return _successScreen();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ================= LOGO =================
              Center(
                child: Column(
                  children: [
                    SizedBox(height: 80,),
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
                    const SizedBox(height: 35),

                    const Text("Forgot Password", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.red)),
                    const SizedBox(height: 5),
                    const SizedBox(height: 25),
                  ],
                ),
              ),



              // ================= STEP 1: EMAIL ROW =================
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 52, // Fixed height for perfect alignment
                      child: TextField(
                        controller: _emailController,
                        enabled: !_otpSent,
                        decoration: InputDecoration(
                          hintText: "Enter Email ID",
                          hintStyle: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                          // prefixIcon: const Icon(Icons.email_outlined, color: Colors.grey),
                          filled: true,
                          fillColor: _otpSent ? Colors.grey.shade200 : Colors.grey.shade50,
                          contentPadding: const EdgeInsets.symmetric(vertical: 0),
                          border: _border,
                          enabledBorder: _border,
                          focusedBorder: _focusedBorder,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  SizedBox(
                    height: 52, // Match TextField height
                    width: 100,
                    child: ElevatedButton(
                      onPressed: (_loading || _otpSent) ? null : _sendOtp,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _otpSent ? Colors.grey : Colors.red,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: _loading && !_otpSent
                          ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                          : Text(_otpSent ? "SENT" : "SEND OTP", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                    ),
                  ),
                ],
              ),

              // ================= STEP 2: OTP ROW =================
              if (_otpSent && !_otpVerified) ...[
                const SizedBox(height: 20),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(4, (index) => _otpBox(index)),
                      ),
                    ),
                    const SizedBox(width: 10),
                    SizedBox(
                      height: 52, // Identical height to Send OTP button
                      width: 100, // Identical width to Send OTP button
                      child: ElevatedButton(
                        onPressed: _start == 0 ? null : _verifyOtp,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          elevation: 0,
                        ),
                        child: const Text("VERIFY", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13)),
                      ),
                    ),
                  ],
                ),

                // TIMER & RESEND ROW
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Expires in: $timerText", style: const TextStyle(color: Colors.red, fontWeight: FontWeight.w600, fontSize: 13)),
                    TextButton(
                      onPressed: _start == 0 ? _sendOtp : null,
                      style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: const Size(50, 30), tapTargetSize: MaterialTapTargetSize.shrinkWrap),
                      child: const Text("Resend OTP", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                    ),
                  ],
                ),
              ],

              // ================= STEP 3: NEW PASSWORD =================
              if (_otpVerified) ...[
                const SizedBox(height: 25),
                TextField(
                    controller: _newPassController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "New Password",
                      prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
                      filled: true, fillColor: Colors.grey.shade50,
                      border: _border, enabledBorder: _border, focusedBorder: _focusedBorder,
                    )
                ),
                const SizedBox(height: 12),
                TextField(
                    controller: _confirmPassController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "Confirm Password",
                      prefixIcon: const Icon(Icons.lock_outline, color: Colors.grey),
                      filled: true, fillColor: Colors.grey.shade50,
                      border: _border, enabledBorder: _border, focusedBorder: _focusedBorder,
                    )
                ),
                const SizedBox(height: 25),
                ElevatedButton(
                  onPressed: _loading ? null : _resetPassword,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    minimumSize: const Size(double.infinity, 52),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 0,
                  ),
                  child: const Text("RESET PASSWORD", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                ),
              ],

              // STATUS MESSAGE
              if (_message != null) ...[
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(12),
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(_messageColor == Colors.green ? Icons.check_circle : Icons.error_outline, color: _messageColor, size: 20),
                      const SizedBox(width: 8),
                      Expanded(child: Text(_message!, style: TextStyle(color: _messageColor, fontWeight: FontWeight.w600, fontSize: 13))),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  // 🚀 MODERN OTP BOX
  Widget _otpBox(int index) {
    return SizedBox(
      width: 45, // Adjusted to fit screen beautifully next to the button
      height: 52, // Matched with button height
      child: TextField(
        controller: _otpControllers[index],
        focusNode: _focusNodes[index],
        textAlign: TextAlign.center,
        keyboardType: TextInputType.number,
        maxLength: 1,
        style: const TextStyle(fontSize: 22, color: Colors.green),
        decoration: InputDecoration(
          counterText: "",
          filled: true,
          fillColor: Colors.grey.shade50,
          contentPadding: EdgeInsets.zero,
          border: _border, enabledBorder: _border, focusedBorder: _focusedBorder,
        ),
        onChanged: (value) {
          if (value.isNotEmpty && index < 3) {
            _focusNodes[index + 1].requestFocus();
          } else if (value.isEmpty && index > 0) {
            _focusNodes[index - 1].requestFocus();
          }
        },
      ),
    );
  }

  Widget _successScreen() {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.verified_user_rounded, color: Colors.green, size: 90),
            SizedBox(height: 20),
            Text("Password Changed!", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87)),
            SizedBox(height: 8),
            Text("Redirecting to login securely...", style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }
}