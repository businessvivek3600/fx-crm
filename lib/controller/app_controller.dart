import 'package:get/get.dart';

import '../models/customer_model.dart';

class AppController extends GetxController {
  static AppController get to => Get.find(); // easy access with AppController.to

  RxString token = ''.obs;
  RxBool isLoggedIn = false.obs;
  Customer? customer;
  void saveToken(String newToken) {
    token.value = newToken;
  }

  void setLoginStatus(bool status) {
    isLoggedIn.value = status;
  }

  void saveCustomerData(Customer newCustomer) {
    customer = newCustomer;
  }
}
