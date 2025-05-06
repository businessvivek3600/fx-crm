import 'package:flutter/material.dart';
import 'package:fx_crm/constant/api_constants.dart';
import 'package:fx_crm/controller/app_controller.dart';
import 'package:fx_crm/controller/auth_controller.dart';
import 'package:fx_crm/controller/session_controller.dart';
import 'package:fx_crm/main.dart';
import 'package:fx_crm/models/customer_model.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:collection/collection.dart'; // For firstWhereOrNull


class ProfileController extends GetxController {
  final AuthController authController = Get.put(AuthController(dioClient: dioClient));

  var isLoading = false.obs;
  var ProfileData = {}.obs;

  final RxString selectedCountryName = ''.obs;
  final RxString countryError = ''.obs;
  final RxString selectedCountryCode = ''.obs;
  final RxString selectedCountryId = ''.obs;

  // Profile text controllers
  final firstname = TextEditingController();
  final lastname = TextEditingController();
  final nextofKin = TextEditingController();
  final email = TextEditingController();
  final country = TextEditingController();
  final customerMobile = TextEditingController();
  final dateOfBirth = TextEditingController();
  final fatherName = TextEditingController();
  final company = TextEditingController();
  final state = TextEditingController();
  final city = TextEditingController();
  final shortAddress = TextEditingController();
  final address1 = TextEditingController();
  final address2 = TextEditingController();
  final zip = TextEditingController();

  var selectedDate = Rxn<DateTime>();

  void pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000, 1, 1),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      selectedDate.value = picked;
      dateOfBirth.text = picked.toIso8601String().split('T')[0];
    }
  }

  void setSelectedCountry(String name, String phoneCode) {
    selectedCountryName.value = name;
    selectedCountryCode.value = phoneCode;

    final matchedCountry = authController.countryList.firstWhereOrNull(
          (c) => c.name.toLowerCase() == name.toLowerCase(),
    );

    if (matchedCountry != null) {
      selectedCountryId.value = matchedCountry.id.toString();
    } else {
      countryError.value = 'Invalid country selected';
    }
  }

  /// Update user profile via API using FormData
  Future<void> updateProfile() async {
    isLoading.value = true;
    try {
      final formData = dio.FormData.fromMap({
        "first_name": firstname.text,
        "last_name": lastname.text,
        "next_of_kin": nextofKin.text,
        "phone": customerMobile.text,
        "customer_mobile": customerMobile.text,
        "date_of_birth": dateOfBirth.text,
        "father_name": fatherName.text,
        "company": company.text,
        "state": state.text,
        "city": city.text,
        "customer_short_address": shortAddress.text,
        "customer_address_1": address1.text,
        "customer_address_2": address2.text,
        "zip": zip.text,
        "country": selectedCountryId.value,
      });

      final response = await dioClient.post(
        ApiConst.updateProfile,
        data: formData,
        token: true,
      );

      if (response.statusCode == 200 && response.data['status'] == 1) {
        final customerData = Customer.fromJson(response.data['data']);
        AppController.to.saveCustomerData(customerData);
        SessionController.to.saveSession(SessionController.to.token.value, customerData);

        Get.snackbar(
          'Success',
          'Profile updated successfully!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
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

  void clearForm() {
    firstname.clear();
    lastname.clear();
    nextofKin.clear();
    email.clear();
    country.clear();
    customerMobile.clear();
    dateOfBirth.clear();
    fatherName.clear();
    company.clear();
    state.clear();
    city.clear();
    shortAddress.clear();
    address1.clear();
    address2.clear();
    zip.clear();
    selectedDate.value = null;
  }

  @override
  void onClose() {
    firstname.dispose();
    lastname.dispose();
    nextofKin.dispose();
    email.dispose();
    country.dispose();
    customerMobile.dispose();
    dateOfBirth.dispose();
    fatherName.dispose();
    company.dispose();
    state.dispose();
    city.dispose();
    shortAddress.dispose();
    address1.dispose();
    address2.dispose();
    zip.dispose();
    super.onClose();
  }
}
