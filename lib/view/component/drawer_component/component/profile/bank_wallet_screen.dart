import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fx_crm/main.dart';

import '../../../../../controller/bank_controller.dart';
import '../../../../../widgets/bg_container.dart';
import '../../../../../widgets/custom_text_form.dart';
import '../../../../../widgets/text_field_shimmer.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({super.key});

  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  late final BankController bankController;

  @override
  void initState() {
    super.initState();
    bankController = Get.put(
      BankController(dioClient: dioClient),
    ); // Provide dioClient
    bankController.getBankDetails();
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            'Bank/Wallet',
            style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
          centerTitle: true,
        ),
        body: Obx(() {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Bank Details',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                bankController.isLoading.value
                    ? const ShimmerTextField() // Shimmer effect
                    : CustomTextFormField(
                      label: 'Bank Name',
                      hint: 'Bank Name',
                      controller: bankController.bankNameController,
                    ),
                const SizedBox(height: 12),
                bankController.isLoading.value
                    ? const ShimmerTextField()
                    : CustomTextFormField(
                      label: 'Bank Address',
                      hint: 'Bank Address',
                      controller: bankController.bankAddressController,
                    ),
                const SizedBox(height: 12),
                bankController.isLoading.value
                    ? const ShimmerTextField()
                    : CustomTextFormField(
                      label: 'Account Holder Name',
                      hint: 'Account Holder Name',
                      controller: bankController.accountHolderNameController,
                    ),
                const SizedBox(height: 12),
                bankController.isLoading.value
                    ? const ShimmerTextField()
                    : CustomTextFormField(
                      label: 'Account Number',
                      hint: 'Account Number',
                      controller: bankController.accountNumberController,
                    ),
                const SizedBox(height: 12),
                bankController.isLoading.value
                    ? const ShimmerTextField()
                    : CustomTextFormField(
                      label: 'Sort Code/BIC/IFSC/Routing Number',
                      hint: 'Sort Code/BIC/IFSC/Routing Number',
                      controller: bankController.ifscCodeController,
                    ),
                const SizedBox(height: 15),
                const Text(
                  'Wallet',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                bankController.isLoading.value
                    ? const ShimmerTextField()
                    : CustomTextFormField(
                      label: 'Bitcoin Address',
                      hint: 'Bitcoin Address',
                      controller: bankController.btcAddressController,
                    ),
                const SizedBox(height: 12),
                bankController.isLoading.value
                    ? const ShimmerTextField()
                    : CustomTextFormField(
                      label: 'Forex Address',
                      hint: 'Forex Address',
                      controller: bankController.bizzcoinAddressController,
                    ),
                const SizedBox(height: 12),
                bankController.isLoading.value
                    ? const ShimmerTextField()
                    : CustomTextFormField(
                      label: 'USDT Address (TRC20)',
                      hint: 'USDT Address (TRC20)',
                      controller: bankController.usdtAddressController,
                    ),
                const SizedBox(height: 24),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      bankController.verifyEmail();
                    },
                    child: Center(
                      child:
                          bankController.otpLoading.value
                              ? SizedBox(
                                height: 25,
                                width: 25,
                                child: CircularProgressIndicator(color: Colors.white54,),
                              )
                              : Text('Get Email OTP'),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Divider(),
                const SizedBox(height: 12),
                bankController.isLoading.value
                    ? const ShimmerTextField()
                    : CustomTextFormField(
                      label: 'Email OTP',
                      hint: 'Enter Email OTP',
                      controller: bankController.otpController,
                    ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (bankController.validateBankOrWalletFields()) {
                        bankController.updateBankDetails();
                      }
                    },
                    child: const Text('Update'),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
