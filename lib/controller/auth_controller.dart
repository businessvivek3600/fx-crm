import 'package:flutter/material.dart';
import 'package:fx_crm/controller/session_controller.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../constant/api_constants.dart';
import '../database/dio/dio/dio_client.dart';
import '../models/customer_model.dart';
import '../view/dashboard_screen.dart';
import 'app_controller.dart';

class AuthController extends GetxController {
  final GetStorage storage = GetStorage();
  final DioClient dioClient;
  AuthController({required this.dioClient});
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  var isLoading = false.obs;
  var isPasswordHidden = true.obs;

  Future<void> login() async {
    if (usernameController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter username and password',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;

      Map<String, dynamic> loginData = {
        'username': usernameController.text,
        'password': passwordController.text,
      };

      /// 🛑 DEBUG: Print POST Body

      // Hitting the login API
      final response = await dioClient.post(
        ApiConst.login, // "login" endpoint
        data: loginData,
      );

      /// 🛑 DEBUG: Print API Response

      print(response.data);
      if (response.statusCode == 200) {
        int isSuccess = response.data['status'] ?? 0;

        if (isSuccess == 1) {
          /// 🛑 Save the login token locally
          String loginToken = response.data['customer']['login_token'] ?? '';
          Customer customerData = Customer.fromJson(response.data['customer']);
          AppController.to.saveCustomerData(customerData);
          SessionController.to.saveSession(loginToken, customerData);

          /// Save in AppController
          AppController.to.saveToken(loginToken);
          AppController.to.setLoginStatus(true);
          Get.snackbar(
            'Login Successfully',
            "You're all set to continue" ,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: Duration(seconds: 1)
          );

          Get.offAll(() => DashboardScreen());
        } else {
          Get.snackbar(
            'Login Failed',
            response.data['message'] ?? 'Unknown error',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          'Error',
          'Server Error: ${response.statusCode}',
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
  }

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
