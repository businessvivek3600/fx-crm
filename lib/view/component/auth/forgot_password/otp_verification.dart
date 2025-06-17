import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fx_crm/controller/auth_controller.dart';
import 'package:fx_crm/view/component/auth/forgot_password/new_password.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pinput/pinput.dart';

import '../../../../widgets/bg_container.dart';

class OtpVerificationScreen extends StatefulWidget {
  final String username;
  final String email;
  const OtpVerificationScreen({
    super.key,
    required this.username,
    required this.email,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen> {
  final TextEditingController _otpController = TextEditingController();
  final AuthController authController = Get.find<AuthController>();

  Timer? _timer;
  int _remainingTime = 60;

  @override
  void initState() {
    super.initState();
    _startCountdown();
    //  otpController.sendOtp(widget.email);
  }

  void _startCountdown() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingTime == 0) {
        timer.cancel();
      } else {
        setState(() => _remainingTime--);
      }
    });
  }

  void _verifyOtp(String otp) async {
    if (authController.isLoading.value) return;
    authController.isLoading.value = true;

    print('calling...');
    if (otp.isEmpty || otp.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter valid 6-digit OTP")),
      );
      return;
    }

    // ✅ Try verifying
    final result = await authController.verifyOtp(widget.username, otp);

    if (result != null) {
      // ✅ Navigate only if widget is still active
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => NewPasswordScreen(username: result),
        ),
      );
    } else {}
  }

  void _resendOtp() async {
    var res = await authController.getOtp(widget.email);
    if (res == null) return;
    setState(() => _remainingTime = 60);
    _startCountdown();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("OTP Resent")));
  }

  @override
  void dispose() {
    _timer?.cancel();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pinTheme = PinTheme(
      width: 50,
      height: 60,
      textStyle: const TextStyle(fontSize: 20, color: Colors.white),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade600),
      ),
    );

    final focusedPinTheme = pinTheme.copyWith(
      decoration: pinTheme.decoration!.copyWith(
        border: Border.all(
          color: Theme.of(context).colorScheme.secondary,
          width: 2,
        ),
      ),
    );

    return BackgroundContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'OTP Verification',
            style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              const Text(
                "Verify Your Identity",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "We’ve sent a 6-digit verification code to your email:",
                style: TextStyle(color: Colors.grey.shade300),
              ),
              const SizedBox(height: 6),
              Text(
                widget.username,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 30),
              Center(
                child: Pinput(
                  length: 6,
                  controller: _otpController,
                  defaultPinTheme: pinTheme,
                  focusedPinTheme: focusedPinTheme,
                  onCompleted: _verifyOtp,
                  showCursor: true,
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: Text(
                  _remainingTime > 0
                      ? "Resend OTP in $_remainingTime seconds"
                      : "Didn't receive the code?",
                  style: TextStyle(color: Colors.grey.shade400),
                ),
              ),
              if (_remainingTime == 0)
                Center(
                  child: TextButton(
                    onPressed: _resendOtp,
                    child: Text(
                      "Resend OTP",
                      style: TextStyle(color: white),
                    ),
                  ),
                ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () => _verifyOtp(_otpController.text),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    "Verify",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
