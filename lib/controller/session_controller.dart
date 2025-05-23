import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../models/customer_model.dart';

class SessionController extends GetxController {
  static SessionController get to => Get.find();

  final GetStorage storage = GetStorage();
  final token = ''.obs;
  final isLoggedIn = false.obs;
  final customer = Rxn<Customer>();

  @override
  void onInit() {
    super.onInit();
    loadSession();
  }

  void saveSession(String loginToken, Customer customerData) {
    token.value = loginToken;
    isLoggedIn.value = true;
    customer.value = customerData;

    storage.write('token', loginToken);
    storage.write('customer', customerData.toJson());
  }

  void loadSession() {
    token.value = storage.read('token') ?? '';
    final customerJson = storage.read('customer');
    if (token.isNotEmpty && customerJson != null) {
      customer.value = Customer.fromJson(customerJson);
      isLoggedIn.value = true;
    }
  }

  void clearSession({bool redirectToLogin = true}) {
    token.value = '';
    isLoggedIn.value = false;
    customer.value = null;

    storage.remove('token');
    storage.remove('customer');

    if (redirectToLogin) {
      Get.snackbar(
        'Session Expired',
        'Please login again',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        duration: Duration(seconds: 2),
      );

    }
  }
}
