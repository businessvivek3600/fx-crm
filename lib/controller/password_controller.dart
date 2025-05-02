import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fx_crm/constant/api_constants.dart';
import 'package:fx_crm/main.dart';

class ChangePasswordController extends GetxController {
  var isLoading = false.obs;

  final oldPassword = TextEditingController();
  final newPassword = TextEditingController(); // spassword
  final confirmPassword = TextEditingController(); // repassword

  /// Validates the password format
  bool validatePassword(String password) {
    final hasMinLength = password.length >= 8;
    final hasSpecialChar = RegExp(r'[!@#\$&*~]').hasMatch(password);
    final startsWithUppercase = RegExp(r'^[A-Z]').hasMatch(password);

    return hasMinLength && hasSpecialChar && startsWithUppercase;
  }

  /// Validate and call API to change password
  Future<void> changePassword() async {
    if (oldPassword.text.isEmpty ||
        newPassword.text.isEmpty ||
        confirmPassword.text.isEmpty) {
      Get.snackbar(
        'Error',
        'All fields are required.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    if (newPassword.text != confirmPassword.text) {
      Get.snackbar(
        'Error',
        'New password and confirm password do not match.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    if (!validatePassword(newPassword.text)) {
      Get.snackbar(
        'Invalid Password',
        'Password must start with an uppercase letter, contain at least one special character (!@#\$&*~), and be at least 8 characters long.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    try {
      final body = {
        "old_password": oldPassword.text.trim(),
        "spassword": newPassword.text.trim(),
        "repassword": confirmPassword.text.trim(),
      };

      final response = await dioClient.post(
        ApiConst.updatepassword,
        data: body,
        token: true,
      );
      print(response.data);

      if (response.statusCode == 200 && response.data['status'] == 1) {
        ;
        Get.snackbar(
          'Success',
          response.data['message'] ?? 'Password changed successfully.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        resetFields();
      } else {
        Get.snackbar(
          'Error',
          response.data['message'] ?? 'Failed to change password.',
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

  void resetFields() {
    oldPassword.clear();
    newPassword.clear();
    confirmPassword.clear();
  }

  /// Dispose controllers to avoid memory leaks
  @override
  void onClose() {
    oldPassword.dispose();
    newPassword.dispose();
    confirmPassword.dispose();
    super.onClose();
  }
}
