import 'package:flutter/material.dart';
import 'package:fx_crm/main.dart';
import 'package:fx_crm/models/customer_model.dart';
import 'package:get/get.dart';
import 'package:fx_crm/constant/api_constants.dart';
import 'package:fx_crm/controller/app_controller.dart';
import 'package:fx_crm/database/dio/dio/dio_client.dart';

class ProfileController extends GetxController {
  var isLoading = false.obs;
  var ProfileData = {}.obs;

  // Profile text controllers
  final firstname = TextEditingController();
  final lastname = TextEditingController();
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

  // Future<void> fetchProfile() async {
  //   isLoading.value = true;
  //   try {
  //     final response = await dioClient.post(
  //       ApiConst.updateProfile, // Replace with actual API endpoint
  //       token: true,
  //     );

  //     if (response.statusCode == 200 && response.data['status'] == 1) {
  //       final data = response.data['data'];
  //       final fetchedProfile = Customer.fromJson(data);
  //       ProfileData.value = response.data;

  //       // Update text controllers
  //       firstname.text = fetchedProfile.firstName ?? '';
  //       lastname.text = fetchedProfile.lastName ?? '';
  //       email.text = fetchedProfile.customerEmail ?? '';
  //       country.text = fetchedProfile.countryText ?? '';
  //       customerMobile.text = fetchedProfile.customerMobile ?? '';
  //       dateOfBirth.text = fetchedProfile.dateOfBirth ?? '';
  //       fatherName.text = fetchedProfile.fatherName ?? '';
  //       company.text = fetchedProfile.company ?? '';
  //       state.text = fetchedProfile.state ?? '';
  //       city.text = fetchedProfile.city ?? '';
  //       shortAddress.text = fetchedProfile.customerShortAddress ?? '';
  //       address1.text = fetchedProfile.customerAddress1 ?? '';
  //       address2.text = fetchedProfile.customerAddress2 ?? '';
  //       zip.text = fetchedProfile.zip ?? '';

  //       // company.text = fetchedProfile.company ?? '';
  //     } else {
  //       Get.snackbar(
  //         'Error',
  //         response.data['message'] ?? 'Failed to fetch profile',
  //         snackPosition: SnackPosition.TOP,
  //         backgroundColor: Colors.redAccent,
  //         colorText: Colors.white,
  //       );
  //     }
  //   } catch (e) {
  //     Get.snackbar(
  //       'Error',
  //       e.toString(),
  //       snackPosition: SnackPosition.BOTTOM,
  //       backgroundColor: Colors.redAccent,
  //       colorText: Colors.white,
  //     );
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  /// Update user profile via API
  Future<void> updateProfile() async {
    isLoading.value = true;
    try {
      final body = {
        "first_name": firstname.text,
        "last_name": lastname.text,
        "country": country.text,
        "email": email.text,
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
      };
      print(body);
      print('Address 1: ${address1.text}');
      print('Address 2: ${address2.text}');
      print('ZIP: ${zip.text}');
      print('State: ${state.text}');
      print('country: ${country.text}');

      final response = await dioClient.post(
        ApiConst.updateProfile, // Replace with actual update endpoint
        data: body,
        token: true,
      );
      print(body);

      if (response.statusCode == 200 && response.data['status'] == 1) {
        Get.snackbar(
          'Success',
          'Profile updated successfully!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        // await fetchProfile(); // Optionally refresh profile
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
}
