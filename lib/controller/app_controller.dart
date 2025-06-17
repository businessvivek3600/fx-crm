import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constant/api_constants.dart';
import '../controller/session_controller.dart';
import '../main.dart';
import '../models/app_info_model.dart';
import '../models/customer_model.dart';
import '../models/download_model.dart';

class AppController extends GetxController {
  static AppController get to => Get.find();

  // Reactive Variables
  final RxString token = ''.obs;
  final RxBool isLoggedIn = false.obs;
  final Rxn<Customer> customer = Rxn<Customer>();
  final Rxn<Company> company = Rxn<Company>();
  final RxList<Setting> settings = <Setting>[].obs;
  final Rxn<DownloadDataModel> downloadDataModel = Rxn<DownloadDataModel>();
  final RxBool isLoading = false.obs;

  AppInfoModel? appInfoModel;

  // 🔔 Notification Count
  RxInt notificationCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    getAppInfo();
  }

  // 🔔 Notification Logic
  void incrementNotification() => notificationCount++;
  void resetNotification() => notificationCount.value = 0;

  // Session Sync
  void syncWithSession() {
    final sessionCustomer = SessionController.to.customer.value;
    if (sessionCustomer != null) {
      customer.value = sessionCustomer;
      token.value = SessionController.to.token.value;
      isLoggedIn.value = SessionController.to.isLoggedIn.value;
    }
  }

  void saveToken(String newToken) => token.value = newToken;
  void setLoginStatus(bool status) => isLoggedIn.value = status;
  void saveCustomerData(Customer newCustomer) => customer.value = newCustomer;

  Future<void> getAppInfo() async {
    isLoading.value = true;
    try {
      final response = await dioClient.get(ApiConst.appInfo);

      if (response.statusCode == 200 && response.data['status'] == 1) {
        final jsonData = response.data['data'];
        appInfoModel = AppInfoModel.fromJson(jsonData);

        if (appInfoModel?.company != null) {
          company.value = appInfoModel!.company!;
        }
        if (appInfoModel?.setting != null) {
          settings.assignAll(appInfoModel!.setting!);
        }
      } else {
        _showErrorSnackbar(
          response.data['message'] ?? 'Failed to fetch app info',
        );
      }
    } catch (e) {
      _showErrorSnackbar(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchDownloadData() async {
    isLoading.value = true;
    try {
      final response = await dioClient.post(ApiConst.downloads);
      if (response.statusCode == 200) {
        final data = DownloadDataModel.fromJson(response.data);
        downloadDataModel.value = data;

        if (data.status != 1) {
          _showErrorSnackbar(data.message);
        }
      } else {
        _showErrorSnackbar('Server error: ${response.statusCode}');
      }
    } catch (e) {
      _showErrorSnackbar(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void _showErrorSnackbar(String message) {
    Future.delayed(Duration.zero, () {
      if (Get.context != null) {
        Get.snackbar(
          'Error',
          message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      } else {
        debugPrint("⚠ Snackbar context not available.");
      }
    });
  }
}
