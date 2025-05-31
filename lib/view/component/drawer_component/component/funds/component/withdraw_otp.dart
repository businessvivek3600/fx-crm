import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fx_crm/view/component/drawer_component/component/funds/withdraw_fund.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import '../../../../../../controller/wallet_controller.dart';
import '../../../../../../widgets/bg_container.dart';


class WithdrawOtpScreen extends StatefulWidget {
  final String requestId;
  final String amount;
  final String paymentType;

  const WithdrawOtpScreen({
    super.key,
    required this.requestId,
    required this.amount,
    required this.paymentType,
  });

  @override
  State<WithdrawOtpScreen> createState() => _WithdrawOtpScreenState();
}

class _WithdrawOtpScreenState extends State<WithdrawOtpScreen> {
  final otpController = TextEditingController();
  final controller = Get.find<WalletController>();
  Timer? _timer;
  int _secondsRemaining = 600;
  bool _canResend = false;
  late String requestId;

  @override
  void initState() {
    super.initState();
    requestId = widget.requestId;
    _startTimer();
  }

  void _startTimer() {
    _canResend = false;
    _secondsRemaining = 600;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        timer.cancel();
        setState(() => _canResend = true);
      } else {
        setState(() => _secondsRemaining--);
      }
    });
  }

  void _resendOtp() async {
    final newRequestId = await controller.withdrawRequest(
      amount: widget.amount,
      paymentType: widget.paymentType,
    );

    if (newRequestId != null) {
      setState(() {
        requestId = newRequestId;
        _startTimer();
      });
    }
  }

  void _submitOtp(String otp) async {
    final success = await controller.verifyWithdrawRequest(
      emailOtp: otp,
      requestId: requestId,
    );

    if (success) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => WithdrawFundScreen(),));
      });// Or your dashboard screen
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    otpController.dispose();
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
              Center(
                child: Pinput(
                  length: 6,
                  controller: otpController,
                  defaultPinTheme: pinTheme,
                  focusedPinTheme: focusedPinTheme,
                  onCompleted: _submitOtp,
                  showCursor: true,
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: Text(
                  _canResend
                      ? "Didn't get it? Resend OTP"
                      : "Resend OTP in ${_secondsRemaining ~/ 60}:${(_secondsRemaining % 60).toString().padLeft(2, '0')}",
                  style: TextStyle(color: Colors.grey.shade400),
                ),
              ),
              if (_canResend)
                TextButton(
                  onPressed: _resendOtp,
                  child: Text("Resend OTP"),
                ),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () => _submitOtp(otpController.text),
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
