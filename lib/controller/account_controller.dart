import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:fx_crm/models/account_model.dart';
import 'package:fx_crm/models/account_type_model.dart';
import 'package:fx_crm/view/component/drawer_component/component/account/account_screen.dart';
import 'package:get/get.dart';

import '../constant/api_constants.dart';
import '../database/dio/dio/dio_client.dart';

class AccountController extends GetxController {
  final DioClient dioClient;

  AccountController({required this.dioClient});

  static AccountController get to => Get.find();

  final RxBool isLoading = false.obs;

  final accountPlans = <AccountPlanModel>[].obs;
  final leverageOptions = <String>[].obs;
  final selectedAccountName = ''.obs;

  final accountTypes = <String>[].obs;
  final selectedAccountType = ''.obs;
  final initialDeposit = <String>[].obs;
  var accountList = <AccountModel>[].obs;

  void updateSelectedAccount(String code) {
    print("selected Plan: $code");
    selectedAccountName.value = code;
    final selected = accountPlans.firstWhereOrNull((e) => e.name.toLowerCase() == code.toLowerCase());

    if (selected != null) {
      leverageOptions.value = selected.leverage.map((e) => '1:$e').toList();
      initialDeposit.value = selected.initialFund;
    } else {
      leverageOptions.clear();
      initialDeposit.clear();
    }
  }

  Future<void> getAccountPlans() async {
    isLoading.value = true;
    try {
      final response = await dioClient.post(ApiConst.accountPlans);
      if (response.statusCode == 200 && response.data['status'] == 1) {
        final data = List<Map<String, dynamic>>.from(response.data['data']);
        accountPlans.value = data.map((e) => AccountPlanModel.fromJson(e)).toList();

        final types = List<String>.from(response.data['account_type'] ?? []);
        accountTypes.value = types;

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

  ///----------------------------CREATE ACCOUNT-----------------------------
  Future<void> createAccount({
    required String accountPlanName,
    required String leverageText,
    required String initialFund,
    required String accountType,
  }) async {
    isLoading.value = true;

    try {
      // Extract the selected account plan code
      final selectedPlan = accountPlans.firstWhere(
            (e) => e.name.toLowerCase() == accountPlanName.toLowerCase(),
        orElse: () => AccountPlanModel(
          code: '',
          name: '',
          leverage: [],
          initialFund: [],
        ),
      );

      final planCode = selectedPlan.code;


      if (planCode == null) {
        throw Exception('Invalid Account Plan selected.');
      }

      dio.FormData payload = dio.FormData.fromMap({
        'account_plan': planCode,
        'leverage': leverageText.split(':').last,
        'initial_fund': initialFund,
        'account_type': accountType,
      });
      print(payload.fields);
      final response = await dioClient.post(
        ApiConst.createAccount,
        data: payload,
      );

      print(response.data['message']);
      if (response.statusCode == 200 && response.data['status'] == 1) {
        Get.snackbar(
          'Success',
          response.data['message'] ?? 'Account created successfully!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        Get.to(() => AccountScreen());
      } else {
        Get.snackbar(
          'Error',
          response.data['message'] ?? 'Failed to create account',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print(e.toString());
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
///--------------Change Leverage-------------------
  Future<void> changeLeverage({
    required String accountNo,
    required String leverage,
  }) async {
    isLoading.value = true;
    dio.FormData formData = dio.FormData.fromMap({
      'account_no': accountNo,
      'leverage': leverage.split(':').last,
    });
    print(formData.fields);
    try {
      final response = await dioClient.post(
        ApiConst.changeLeverage, // Make sure this endpoint is defined in ApiConst
       data: formData,
      );

      if (response.statusCode == 200 && response.data['status'] == 1) {
        Get.snackbar(
          'Success',
          response.data['message'] ?? 'Leverage updated successfully',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          response.data['message'] ?? 'Failed to update leverage',
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


  // My Account
  Future<void> fetchAccounts() async {
    try {
      isLoading.value = true;
      final response = await dioClient.post(ApiConst.accounts);
      if (response.statusCode == 200 && response.data['status'] == 1) {
        List data = response.data['data'];
        accountList.value =
            data
                .map((e) => AccountModel.fromJson(e))
                .cast<AccountModel>()
                .toList();
      } else {
        Get.snackbar("Error", "Failed to load accounts");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  //change account password
  Future<bool> changeAccountPassword(
    String accountNumber,
    String newpass,
    String confPass,
    String passwordType,
  ) async {
    try {
      isLoading.value = true;
      dio.FormData formData = dio.FormData.fromMap({
        'account_no': accountNumber,
        'new_password': newpass,
        "confirm_password": confPass,
        "password_type": passwordType,
      });
       print('POST Body:--------------- ${formData.fields}');

      final response = await dioClient.post(
        ApiConst.change_acc_password,
        data: formData,
      );

      if (response.statusCode == 200) {
        isLoading.value = false;
        Get.snackbar(
          'Success',
          response.data['message'] ?? 'Password changed successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        return true;
      } else {
        Get.snackbar(
          'Error',
          response.data['message'] ?? 'Unknown error',
          snackPosition: SnackPosition.BOTTOM,
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
    return false;
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
        completeProfile.value =
            int.tryParse(data['complete_profile'].toString()) ?? 0;
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
