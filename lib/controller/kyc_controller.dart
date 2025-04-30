

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constant/api_constants.dart';
import '../database/dio/dio/dio_client.dart';
import '../models/kyc_model.dart';

class KycController extends GetxController {
  final DioClient dioClient;

  KycController({required this.dioClient});

  final isLoading = false.obs;

  Rx<KycModel?> kycData = Rx<KycModel?>(null);
  final documentController = TextEditingController(text: 'GovernmentID');
  final GlobalKey documentKey = GlobalKey();
  String? idFileName;
  String? selfieFileName;

  Future<void> getKycDetails() async {
    isLoading.value = true;
    try {
      final response = await dioClient.post(ApiConst.getKyc);
print(response.data);
      if (response.statusCode == 200 && response.data['status'] == 1) {
        final data = response.data['data'];
        final kyc = KycModel.fromJson(data);
        kycData.value = kyc;
      } else {
        Get.snackbar(
          'Error',
          response.data['message'] ?? 'Failed to fetch KYC details',
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

  Future<void> pickFile(bool isSelfie) async {
    final result = await FilePicker.platform.pickFiles();
    if (result != null) {
      if (isSelfie) {
        selfieFileName = result.files.single.name;
      } else {
        idFileName = result.files.single.name;
      }
    }
  }

  void selectDocument() async {
    final options = ["GovernmentID", "Passport"];
    final selected = await showMenu<String>(
      context: Get.context!,
      position: RelativeRect.fromLTRB(
        0, 0, 0, 0, // Adjust as needed
      ),
      items: options.map((option) {
        return PopupMenuItem<String>(value: option, child: Text(option));
      }).toList(),
    );

    if (selected != null) {
      documentController.text = selected;
    }
  }
}

