import 'package:flutter/material.dart';
import 'package:fx_crm/main.dart';
import 'package:fx_crm/models/customer_model.dart';
import 'package:get/get.dart';
import 'package:fx_crm/constant/api_constants.dart';
import 'package:fx_crm/controller/app_controller.dart';
import 'package:fx_crm/database/dio/dio/dio_client.dart';

class ProfileController extends GetxController {
  var isLoading = false.obs;
  var ProfileData = {}.obs;

  // Profile text controllers
  final firstname = TextEditingController();
  final lastname = TextEditingController();
  final email = TextEditingController();
  final phone = TextEditingController();

  Future<void> fetchProfile() async {
    isLoading.value = true;
    try {
      final response = await dioClient.post(
        ApiConst.updateProfile, // Replace with actual API endpoint
        token: true,
      );

      if (response.statusCode == 200 && response.data['status'] == 1) {
        final data = response.data['data'];
        final fetchedProfile = Customer.fromJson(data);
        ProfileData.value = response.data;

        // Update text controllers
        firstname.text = fetchedProfile.firstName ?? '';
        lastname.text = fetchedProfile.lastName ?? '';
        email.text = fetchedProfile.customerEmail ?? '';
        // company.text = fetchedProfile.company ?? '';
      } else {
        Get.snackbar(
          'Error',
          response.data['message'] ?? 'Failed to fetch profile',
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

  /// Update user profile via API
  Future<void> updateProfile() async {
    isLoading.value = true;
    try {
      final body = {
        "first_name": firstname.text,
        "last_name": lastname.text,
        "email": email.text,
        "phone": phone.text,
      };
      print(body);

      final response = await dioClient.post(
        ApiConst.updateProfile, // Replace with actual update endpoint
        data: body,
        token: true,
      );
      print(response.data);

      if (response.statusCode == 200 && response.data['status'] == 1) {
        Get.snackbar(
          'Success',
          'Profile updated successfully!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        await fetchProfile(); // Optionally refresh profile
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
}
