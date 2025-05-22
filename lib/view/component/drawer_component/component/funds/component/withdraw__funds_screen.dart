import 'package:flutter/material.dart';
import 'package:fx_crm/widgets/bg_container.dart';
import 'package:fx_crm/widgets/custom_text_form.dart';
import 'package:nb_utils/nb_utils.dart';

class WithdrawFundsScreen extends StatefulWidget {
  const WithdrawFundsScreen({super.key});

  @override
  _WithdrawFundsScreenState createState() => _WithdrawFundsScreenState();
}

class _WithdrawFundsScreenState extends State<WithdrawFundsScreen> {
  String _paymentType = 'Bitcoin';
  final TextEditingController _amountController = TextEditingController(text: "500");
  final TextEditingController _bitcoinAddressController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final double _processingFeePercent = 1.0;

  double get _netAmount {
    double amount = double.tryParse(_amountController.text) ?? 0.0;
    return amount - (amount * _processingFeePercent / 100);
  }

  void _getEmailOtp() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("OTP sent to registered email.")),
    );
  }

  void _submit() {
    if (_bitcoinAddressController.text.isEmpty || _otpController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please complete all fields.")),
      );
    } else {
      print("Submitting withdrawal...");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          elevation: 0,
    
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Withdraw Funds",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  fontSize: 23,
                  color: Colors.white,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
               
                
                ),
                child: const Text(
                  "\$500",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              /// Amount input
              CustomTextFormField(
                label: "Amount",
                hint: "Enter amount",
                controller: _amountController,
              ),
              const SizedBox(height: 13),

              /// Payment type dropdown
              const Padding(
                padding: EdgeInsets.all(9.0),
                child: Text(
                  "Payment Type",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
                ),
              ),
              DropdownButtonFormField<String>(
                value: _paymentType,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                items: ['Bitcoin', 'USDT', 'Bank Transfer'].map((e) {
                  return DropdownMenuItem(value: e, child: Text(e));
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _paymentType = value!;
                  });
                },
              ),
              const SizedBox(height: 16),

              /// Bitcoin address input
              CustomTextFormField(
                label: "Bitcoin Address",
                hint: "Enter your bitcoin wallet address",
                controller: _bitcoinAddressController,
              ),
              const SizedBox(height: 16),

              /// Fee & Net Amount
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Processing Fee: 1%",
                  style: TextStyle(color: white, fontWeight: fontWeightBoldGlobal, fontSize: 18),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "Net Amount: ${_netAmount.toStringAsFixed(2)}",
                  style: TextStyle(color: white, fontWeight: fontWeightBoldGlobal, fontSize: 18),
                ),
              ),
              const SizedBox(height: 12),

              /// Get OTP button
              ElevatedButton(
                onPressed: _getEmailOtp,
                child: const Text("Get Email OTP"),
              ),
              const SizedBox(height: 20),

              /// OTP input
              CustomTextFormField(
                label: "Email OTP",
                hint: "Enter the OTP sent to your email",
                controller: _otpController,
              ),
              const SizedBox(height: 20),

              /// Submit button
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shadowColor: white,
                ),
                child: const Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
