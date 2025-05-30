import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constant/api_constants.dart';
import '../main.dart';
import '../models/customer_model.dart';

class DashBoardController extends GetxController {

  var isLoading = false.obs;
  var dashboardData = {}.obs;
  var termsHtml = ''.obs;
  Rx<Customer?> profileData = Rx<Customer?>(null);


  /// Fetch Dashboard Data
  Future<void> getDashboardData() async {
    try {
      isLoading.value = true;
      final response = await dioClient.post(ApiConst.home);
      if (response.statusCode == 200 && response.data != null) {
        dashboardData.value = response.data;
      } else {
        Get.snackbar('Error', 'Failed to fetch dashboard data');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e');
    } finally {
      isLoading.value = false;
    }
  }

  /// Fetch Terms & Conditions
  Future<void> getTermsAndCondition() async {
    try {
      isLoading.value = true;
      final response = await dioClient.post(ApiConst.termAndCondition);
      if (response.statusCode == 200 && response.data['status'] == 1) {
        termsHtml.value = response.data['data'] ?? '';
      } else {
        Get.snackbar(
          'Error',
          response.data['message'] ??
              'Failed to fetch Terms & Conditions details',
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

  /// Fetch User Profile
  Future<void> getUserProfile() async {
    try {
      isLoading.value = true;
      final response = await dioClient.post(ApiConst.userProfile);
      log("Profile Data: ${response.data}");
      if (response.statusCode == 200 && response.data != null) {
        log("Profile Data: ${response.data}");
        profileData.value = Customer.fromJson(response.data['data']);
      } else {
        Get.snackbar("Error", "Failed to fetch profile");
      }
    } catch (e) {
      Get.snackbar("Error", "Something went wrong: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
