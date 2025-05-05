import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constant/api_constants.dart';
import '../main.dart';
import '../models/app_info_model.dart';
import '../models/customer_model.dart';

class AppController extends GetxController {
  static AppController get to => Get.find();
  RxString token = ''.obs;
  RxBool isLoggedIn = false.obs;
  Customer? customer;
  AppInfoModel? appInfoModel;
  final Rxn<Company> company = Rxn<Company>();
  final RxList<Setting> settings = <Setting>[].obs;


  @override
  void onInit() {
    super.onInit();
    getAppInfo(); // Safe to call here
  }
  void saveToken(String newToken) {
    token.value = newToken;
  }

  void setLoginStatus(bool status) {
    isLoggedIn.value = status;
  }

  void saveCustomerData(Customer newCustomer) {
    customer = newCustomer;
  }
  final isLoading = false.obs;
  Future<void> getAppInfo() async {

    isLoading.value = true;
    try {
      final response = await dioClient.get(ApiConst.appInfo);

      if (response.statusCode == 200 && response.data['status'] == 1) {
        final jsonData = response.data['data'];
        appInfoModel = AppInfoModel.fromJson(jsonData);

        // Store separately
        if (appInfoModel?.company != null) {
          company.value = appInfoModel!.company!;
        }

        if (appInfoModel?.setting != null) {
          settings.assignAll(appInfoModel!.setting!);
        }
      } else {
        Future.delayed(Duration.zero, () {
          if (Get.context != null) {
            Get.snackbar(
              'Error',
              response.data['message'] ?? 'Failed to fetch KYC details',
              snackPosition: SnackPosition.TOP,
              backgroundColor: Colors.redAccent,
              colorText: Colors.white,
            );
          } else {
            debugPrint("⚠ Snackbar context is not available.");
          }
        });
      }
    } catch (e) {
      Future.delayed(Duration.zero, () {
        print(e.toString());
        if (Get.context != null) {
          Get.snackbar(
            'Error',
            e.toString(),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
          );
        } else {
          debugPrint("⚠ Snackbar context is not available.");
        }
      });
    } finally {
      isLoading.value = false;
    }
  }


}
