import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:fx_crm/controller/session_controller.dart';
import 'package:fx_crm/routes/route_path.dart';
import 'package:fx_crm/routes/route_settings.dart';
import 'package:fx_crm/utils/theme.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:nb_utils/nb_utils.dart' hide DialogType;

import '../constant/api_constants.dart';
import '../database/dio/dio/dio_client.dart';
import '../models/country_model.dart';
import '../models/customer_model.dart';
import '../view/component/auth/login_screen.dart';
import 'app_controller.dart';

class AuthController extends GetxController {
  final GetStorage storage = GetStorage();
  final DioClient dioClient;
  AuthController({required this.dioClient});

  ///Controllers
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  ///Variables
  var isLoading = false.obs;
  var isPasswordHidden = true.obs;

  ///REGISTER VARIABLES
  final RxList<Country> countryList = <Country>[].obs;
  final RxString selectedCountryName = ''.obs;
  final RxString countryError = ''.obs;
  final RxString selectedCountryCode = ''.obs;
  final RxString selectedCountryId = ''.obs;

  ///Select Country
  void setSelectedCountry(String name, String phoneCode, [String? id]) {
    selectedCountryName.value = name;
    selectedCountryCode.value = phoneCode;

    final matchedCountry = countryList.firstWhereOrNull(
      (c) => c.name.toLowerCase() == name.toLowerCase(),
    );

    selectedCountryId.value = matchedCountry?.id.toString() ?? '';
  }

  /// ------ Login APIs Functions
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
        ApiConst.login,
        token: false,
        data: loginData,
      );

      /// 🛑 DEBUG: Print API Response
      print("------------------------------------------");
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
            "You're all set to continue",
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: Duration(seconds: 1),
          );

          router.push(Paths.dashboard);
        } else if (response.data['is_login'] == 2) {
          String message =
              response.data['message'] ?? 'Please verify your email address!';
          String username = response.data['username'] ?? '';

          Get.rawSnackbar(
            messageText: Row(
              children: [
                Expanded(
                  child: Text(message, style: TextStyle(color: Colors.white)),
                ),
                TextButton(
                  onPressed: () {
                    usernameController.text = username;
                    Get.back(); // close snackbar if open

                    AwesomeDialog(
                      context: Get.context!,
                      dialogType: DialogType.info,
                      animType: AnimType.rightSlide,
                      title: 'Email Verification',
                      titleTextStyle: TextStyle(
                        color: ThemeUtils.primaryColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                      closeIcon: Icon(Icons.clear),
                      desc:
                          'We are sending you a new verification link. Please check your registered email inbox.',
                      btnOkText: "Send Link",
                      btnOkOnPress: () async {
                        await verifyEmail(); // call existing verifyEmail method
                      },
                    ).show();
                  },
                  child: Text(
                    "Verify",
                    style: TextStyle(color: Colors.yellowAccent),
                  ),
                ),
              ],
            ),
            backgroundColor: Colors.redAccent,
            snackPosition: SnackPosition.BOTTOM,
            duration: Duration(seconds: 8),
            margin: EdgeInsets.all(16),
            borderRadius: 8,
          );
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

  /// Register User APIs Function
  Future<void> register({
    required String firstName,
    required String lastName,
    required String customerEmail,
    required String countryCode,
    required String customerMobile,
    required String accountType,
  }) async {
    isLoading.value = true;

    try {
      dio.FormData formData = dio.FormData.fromMap({
        'first_name': firstName,
        'last_name': lastName,
        'customer_email': customerEmail,
        'country_code': countryCode,
        'customer_mobile': customerMobile,
        'account_type': accountType,
      });

      final response = await dioClient.post(
        ApiConst.register,
        data: formData,
        token: false,
      );

      if (response.statusCode == 200 && response.data['status'] == 1) {
        Get.snackbar(
          'Registration Successful',
          response.data["message"],
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: Duration(seconds: 2),
        );

        Get.to(() => LoginScreen());
      } else {
        Get.snackbar(
          'Registration Failed',
          response.data['message'] ?? 'Something went wrong',
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

  ///Get CountryList
  /// @override

  Future<void> getCountryList() async {
    try {
      isLoading.value = true;

      final response = await dioClient.get(
        ApiConst.country,
      ); // Replace with actual endpoint

      print("response Country ----${response.data}");
      if (response.statusCode == 200 && response.data['status'] == 1) {
        final List countriesData = response.data['countries'] ?? [];

        countryList.value =
            countriesData
                .map((countryJson) => Country.fromJson(countryJson))
                .toList();
      } else {
        Get.snackbar(
          'Failed to Fetch Countries',
          response.data['message'] ?? 'Something went wrong',
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

  ///-----------VERIFY EMAIL
  Future<void> verifyEmail() async {
    if (usernameController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your email address',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    try {
      dio.FormData formData = dio.FormData.fromMap({
        'username': usernameController.text,
      });
      final response = await dioClient.post(
        ApiConst.verifyEmail,
        data: formData,
        token: false,
      );
      if (response.statusCode == 200 && response.data['status'] == 1) {
        Get.snackbar(
          'Success',
          response.data['message'] ?? 'Verification email sent',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Verification Failed',
          response.data['message'] ?? 'Something went wrong',
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
    }
  }

  //Forget password
  Future<String?> getOtp(String username) async {
    if (username.isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter your username or email',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return null;
    }

    isLoading.value = true;
    try {
      dio.FormData formData = dio.FormData.fromMap({'username': username});

      final response = await dioClient.post(
        ApiConst.send_code,
        data: formData,
        token: false,
      );

      if (response.statusCode == 200 && response.data['status'] == 1) {
        Get.snackbar(
          'Success',
          response.data['message'] ?? 'OTP sent successfully',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Optionally: Store the username or navigate to OTP page
        String? username = response.data['username'];
        if (username.validate().isNotEmpty) {
          isLoading.value = false;
          return username;
        } else {
          Get.snackbar(
            'Error',
            'Username not found',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          'Failed',
          response.data['message'] ?? 'Unable to send OTP',
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
    return null;
  }

  //Verify Password
  Future<String?> verifyOtp(String username, String otp) async {
    try {
      isLoading.value = true;
      dio.FormData formData = dio.FormData.fromMap({
        'username': username,
        'otp': otp,
      });
      final response = await dioClient.post(
        ApiConst.verify_code,
        data: formData,
        token: false,
      );
      if (response.statusCode == 200) {
        isLoading.value = false;
        return username;
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
    return null;
  }

  Future<bool> changePassword(
    String username,
    String pass,
    String confPass,
  ) async {
    try {
      isLoading.value = true;
      dio.FormData formData = dio.FormData.fromMap({
        'username': username,
        'password': pass,
        "confirm_password": confPass,
      });
      final response = await dioClient.post(
        ApiConst.change_password,
        data: formData,
        token: false,
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

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
