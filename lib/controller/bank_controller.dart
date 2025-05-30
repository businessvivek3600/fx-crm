import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import '../constant/api_constants.dart';
import '../main.dart';
import '../models/bank_model.dart';

class BankController extends GetxController {


  final isLoading = false.obs;
  final otpLoading = false.obs;
  Rx<Bank?> bankDetails = Rx<Bank?>(null);

  /// Form controllers
  final bankNameController = TextEditingController();
  final bankAddressController = TextEditingController();
  final accountHolderNameController = TextEditingController();
  final accountNumberController = TextEditingController();
  final ifscCodeController = TextEditingController();
  final btcAddressController = TextEditingController();
  final bizzcoinAddressController = TextEditingController();
  final usdtAddressController = TextEditingController();
  final otpController = TextEditingController();

  /// Get Bank Data
  Future<void> getBankDetails() async {
    isLoading.value = true;

    try {
      final response = await dioClient.post(
        ApiConst.getBankDetails,
        token: true,
      );
      print('bank data');
      print(response.data);
      if (response.statusCode == 200 && response.data['status'] == 1) {
        final data = response.data['data'];
        final bank = Bank.fromJson(data);
        bankDetails.value = bank;
        // Set initial values
        bankNameController.text = bank.bank ?? '';
        bankAddressController.text = bank.address ?? '';
        accountHolderNameController.text = bank.accountHolderName ?? '';
        accountNumberController.text = bank.accountNumber ?? '';
        ifscCodeController.text = bank.ifscCode ?? '';
        btcAddressController.text = bank.btcAddress ?? '';
        bizzcoinAddressController.text = bank.bizzcoinAddress ?? '';
        usdtAddressController.text = bank.usdtAddress ?? '';
      } else {
        Get.snackbar(
          'Error',
          response.data['message'] ?? 'Failed to fetch bank details',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  /// Update Bank Data
  Future<void> updateBankDetails() async {
    isLoading.value = true;

    try {
      dio.FormData formData = dio.FormData.fromMap({
        'bank': bankNameController.text,
        'address': bankAddressController.text,
        'account_holder_name': accountHolderNameController.text,
        'account_number': accountNumberController.text,
        'ifsc_code': ifscCodeController.text,
        'btc_address': btcAddressController.text,
        'bizzcoin_address': bizzcoinAddressController.text,
        'usdt_address': usdtAddressController.text,
        'email_otp': otpController.text,
      });
      final response = await dioClient.post(
        ApiConst.updateBankDetails,
        data: formData,
      );
      if (response.statusCode == 200 && response.data['status'] == 1) {
        Get.snackbar(
          'Success',
          response.data['status'] ?? 'Bank details updated successfully',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        // Clear OTP field
        otpController.clear();
        // Optionally, refresh the bank details after updating
        await getBankDetails();
      } else {
        Get.snackbar(
          'Error',
          response.data['message'] ?? 'Failed to update bank details',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  ///Verify Email
  Future<void> verifyEmail() async {
    otpLoading.value = true;
    try {
      final response = await dioClient.post(ApiConst.bankEmail);
      print(response.data);
      if (response.statusCode == 200 && response.data['status'] == 1) {
        Get.snackbar(
          'Success',
          'OTP has successfully sent on your email',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          response.data['message'] ?? 'Failed to verify email',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      otpLoading.value = false;
    }
  }

  ///Bank/Wallet Filed Validation
  /// Bank/Wallet Field Validation with OTP Check
  bool validateBankOrWalletFields() {
    final isBankDetailsEntered =
        bankNameController.text.isNotEmpty ||
        bankAddressController.text.isNotEmpty ||
        accountHolderNameController.text.isNotEmpty ||
        accountNumberController.text.isNotEmpty ||
        ifscCodeController.text.isNotEmpty;

    final isWalletEntered =
        btcAddressController.text.isNotEmpty ||
        bizzcoinAddressController.text.isNotEmpty ||
        usdtAddressController.text.isNotEmpty;

    // Validate OTP
    if (otpController.text.isEmpty) {
      Get.snackbar(
        'Validation Error',
        'OTP is required.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return false;
    }

    // Validate Bank Details if any bank field is entered
    if (isBankDetailsEntered) {
      if (bankNameController.text.isEmpty ||
          bankAddressController.text.isEmpty ||
          accountHolderNameController.text.isEmpty ||
          accountNumberController.text.isEmpty ||
          ifscCodeController.text.isEmpty) {
        Get.snackbar(
          'Validation Error',
          'Please fill in all bank details.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
        return false;
      }
    }
    // Require at least one of bank or wallet
    else if (!isWalletEntered) {
      Get.snackbar(
        'Validation Error',
        'Please provide at least bank or wallet information.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return false;
    }

    return true;
  }
}
