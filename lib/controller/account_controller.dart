

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constant/api_constants.dart';
import '../database/dio/dio/dio_client.dart';
import '../models/account_type_model.dart';


class AccountController extends GetxController {
  final DioClient dioClient;

  AccountController({required this.dioClient});

  static AccountController get to => Get.find();

  final RxBool isLoading = false.obs;

  final accountPlans = <Map<String, dynamic>>[].obs;
  final leverageOptions = <String>[].obs;
  final selectedAccountName = ''.obs;

  final accountTypes = <String>[].obs;
  final selectedAccountType = ''.obs;


  void updateSelectedAccount(String name) {
    selectedAccountName.value = name;

    final selected = accountPlans.firstWhereOrNull((e) => e['name'] == name);
    if (selected != null && selected['leverage'] is List) {
      final List<String> levers = List<String>.from(selected['leverage']);
      leverageOptions.value = levers.map((e) => '1:$e').toList();
    } else {
      leverageOptions.clear();
    }
  }

  Future<void> getAccountPlans() async {
    isLoading.value = true;
    try {
      final response = await dioClient.post(ApiConst.accountPlans);
      if (response.statusCode == 200 && response.data['status'] == 1) {
        final data = List<Map<String, dynamic>>.from(response.data['data']);
        accountPlans.value = data;

        // Extract and deduplicate account types
        final types = List<String>.from(response.data['account_type'] ?? []);
        accountTypes.value = types;
        print("Account Types: ${accountTypes.value}");

      } else {
        Get.snackbar(
          'Error',
          response.data['message'] ?? 'Failed to fetch account types',
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







  ///--------------Currently this module is not used in the app-------------------
  final RxInt isKyc = 0.obs;
  final RxInt completeProfile = 0.obs;

  Future<void> getActivateDetails() async {
    isLoading.value = true;
    try {
      final response = await dioClient.post(ApiConst.activate);
      if (response.statusCode == 200 && response.data['status'] == 1) {
        final data = response.data['data'];
        isKyc.value = int.tryParse(data['is_kyc'].toString()) ?? 0;
        completeProfile.value = int.tryParse(data['complete_profile'].toString()) ?? 0;
      } else {
        Get.snackbar(
          'Error',
          response.data['message'] ?? 'Failed to fetch Activate details',
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
