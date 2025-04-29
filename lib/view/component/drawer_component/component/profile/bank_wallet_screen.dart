import 'package:flutter/material.dart';

import '../../../../../widgets/bg_container.dart';
import '../../../../../widgets/custom_text_form.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  BackgroundContainer(
      child:  Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          elevation: 0,
          title: const Text(
            'Bank/Wallet',
            style: TextStyle(fontWeight: FontWeight.bold,letterSpacing: 1.2),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// Input Fields
              CustomTextFormField(label: 'Bank Name', hint: 'Bank Name'),
              const SizedBox(height: 12),
              CustomTextFormField(label: 'Bank Address', hint: 'Bank Address'),
              const SizedBox(height: 12),
              CustomTextFormField(label: 'Account Holder Name', hint: 'Account Holder Name'),
              const SizedBox(height: 12),
              CustomTextFormField(label: 'Account Number', hint: 'Account Number'),
              const SizedBox(height: 12),
              CustomTextFormField(label: 'Sort Code/BIC/IFSC/Routing Number', hint: 'Sort Code/BIC/IFSC/Routing Number'),
              const SizedBox(height: 12),
              CustomTextFormField(label: 'Choose Password', hint: 'Bitcoin Address'),
              const SizedBox(height: 12),
              CustomTextFormField(label: 'Forex Address', hint: 'Forex Address'),
              const SizedBox(height: 12),
              CustomTextFormField(label: 'USDT Address (TRC20)', hint: 'USDT Address (TRC20)'),

              const SizedBox(height: 24),


              /// Get Email OTP Button
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Handle OTP sending
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Get Email OTP',
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 12),

              /// Email OTP Field
              CustomTextFormField(label: 'Email OTP', hint: 'Enter Email OTP'),


              const SizedBox(height: 24),

              /// Update Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle profile update
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Update',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
