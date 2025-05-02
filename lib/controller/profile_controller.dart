import 'package:flutter/material.dart';
import 'package:fx_crm/constant/api_constants.dart';
import 'package:fx_crm/controller/app_controller.dart';
import 'package:fx_crm/controller/auth_controller.dart';
import 'package:fx_crm/main.dart';
import 'package:fx_crm/models/customer_model.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;

class ProfileController extends GetxController {
  AuthController authController = Get.put(AuthController(dioClient: dioClient));
  var isLoading = false.obs;
  var ProfileData = {}.obs;

  // Profile text controllers
  final firstname = TextEditingController();
  final lastname = TextEditingController();
  final nextofKin = TextEditingController();
  final email = TextEditingController();
  final country = TextEditingController();
  final customerMobile = TextEditingController();
  final dateOfBirth = TextEditingController();
  final fatherName = TextEditingController();
  final company = TextEditingController();
  final state = TextEditingController();
  final city = TextEditingController();
  final shortAddress = TextEditingController();
  final address1 = TextEditingController();
  final address2 = TextEditingController();
  final zip = TextEditingController();
  var selectedDate = Rxn<DateTime>();

  void pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      selectedDate.value = picked;
      dateOfBirth.text = selectedDate.value.toString().split(' ')[0];
    }
  }

  /// Update user profile via API using FormData
  Future<void> updateProfile() async {
    isLoading.value = true;
    try {
      final formData = dio.FormData.fromMap({
        "first_name": firstname.text,
        "last_name": lastname.text,
        "next_of_kin": nextofKin.text,
        "country": authController.selectedCountryName.value,
        "email": email.text,
        "phone": customerMobile.text,
        "customer_mobile": customerMobile.text,
        "date_of_birth": dateOfBirth.text,
        "father_name": fatherName.text,
        "company": company.text,
        "state": state.text,
        "city": city.text,
        "customer_short_address": shortAddress.text,
        "customer_address_1": address1.text,
        "customer_address_2": address2.text,
        "zip": zip.text,

        // Uncomment this part if you're uploading a file
        // "profile_image": await MultipartFile.fromFile(
        //   imageFile.path,
        //   filename: "profile.jpg",
        // ),
      });

      final response = await dioClient.post(
        ApiConst.updateProfile,
        data: formData,
        token: true,
        // options: Options(contentType: 'multipart/form-data'),
      );

      print("-------------------------------------------------------");
      print(response.data);

      if (response.statusCode == 200 && response.data['status'] == 1) {
        Customer customerData = Customer.fromJson(response.data['data']);
        AppController.to.saveCustomerData(customerData);
        Get.snackbar(
          'Success',
          'Profile updated successfully!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          response.data['message'] ?? 'Failed to update profile',
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

  void clearForm() {
    firstname.clear();
    lastname.clear();
    nextofKin.clear();
    email.clear();
    country.clear();
    customerMobile.clear();
    dateOfBirth.clear();
    fatherName.clear();
    company.clear();
    state.clear();
    city.clear();
    shortAddress.clear();
    address1.clear();
    address2.clear();
    zip.clear();
    selectedDate.value = null;
  }

  // /// Dispose controllers to avoid memory leaks
  // @override
  // void onClose() {
  //   firstname.dispose();
  //   lastname.dispose();
  //   nextofKin.dispose();
  //   email.dispose();
  //   country.dispose();
  //   customerMobile.dispose();
  //   dateOfBirth.dispose();
  //   fatherName.dispose();
  //   company.dispose();
  //   state.dispose();
  //   city.dispose();
  //   shortAddress.dispose();
  //   address1.dispose();
  //   address2.dispose();
  //   zip.dispose();
  //   super.onClose();
  // }
}

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
      final formData = dio.FormData.fromMap({
        "old_password": oldPassword.text.trim(),
        "spassword": newPassword.text.trim(),
        "repassword": confirmPassword.text.trim(),
      });

      final response = await dioClient.post(
        ApiConst.updatepassword,
        data: formData,
        token: true,
      );

      print(response.data);

      if (response.statusCode == 200 && response.data['status'] == 1) {
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
