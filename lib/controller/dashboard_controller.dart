import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../database/dio/dio/dio_client.dart';
import '../constant/api_constants.dart';

class DashBoardController extends GetxController {
  final DioClient dioClient;

  DashBoardController({required this.dioClient});

  var isLoading = false.obs;
  var dashboardData = {}.obs;
  var termsHtml = ''.obs;
  Future<void> getDashboardData() async {
    try {
      isLoading.value = true;

      final response = await dioClient.post(ApiConst.home);
      print("-------------------------------");
      print(response.data);
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
  ///terms and condition..................
  Future<void> getTermsAndCondition() async {
    isLoading.value = true;
    try {
      final response = await dioClient.post(ApiConst.termAndCondition);
      if (response.statusCode == 200 && response.data['status'] == 1) {
        termsHtml.value = response.data['data'] ?? '';
      } else {
        Get.snackbar(
          'Error',
          response.data['message'] ?? 'Failed to fetch Terms & Conditions details',
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
