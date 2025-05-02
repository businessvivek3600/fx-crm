
import 'package:fx_crm/utils/theme.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
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
  File? idImageFile;
  File? selfieImageFile;


  Future<void> getKycDetails() async {
    isLoading.value = true;
    try {
      final response = await dioClient.post(ApiConst.getKyc);
      print("ApiConst.getKyc response data---------");
      print(response.data);
      if (response.statusCode == 200 && response.data['status'] == 1) {
        final data = response.data['data'];

        if (data != null && data is Map<String, dynamic>) {
          final kyc = KycModel.fromJson(data);
          kycData.value = kyc;
        } else {
          kycData.value = null;
        }
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
  ///Upload Kyc
  Future<void> uploadKyc() async {
    if (idImageFile == null || selfieImageFile == null) {
      Get.snackbar(
        'Missing Files',
        'Please select both ID and Selfie images.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    try {
      int idType = 0;
      if (documentController.text == "GovernmentID") {
        idType = 1;
      } else if (documentController.text == "Passport") {
        idType = 2;
      }
     dio.FormData formData = dio.FormData.fromMap({
        'id_type':idType.toString(),
        'upload_first_proof': await dio.MultipartFile.fromFile(
          idImageFile!.path,
          filename: idImageFile!.path.split('/').last,
        ),
        'upload_second_proof': await dio.MultipartFile.fromFile(
          selfieImageFile!.path,
          filename: selfieImageFile!.path.split('/').last,
        ),
      });
      final response = await dioClient.post(
        ApiConst.uploadKyc,
        data: formData,
      );

      if (response.statusCode == 200 && response.data['status'] == 1) {
        Get.snackbar(
          'Success',
          response.data['message'] ?? 'KYC submitted successfully.',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        // Clear selected image files
        idImageFile = null;
        selfieImageFile = null;

        // Refresh data and UI
        await getKycDetails();
        update();
      } else {
        Get.snackbar(
          'Upload Failed',
          response.data['message'] ?? 'Something went wrong.',
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



  ///Image Picker

  Future<void> pickFile(bool isSelfie) async {
    final picker = ImagePicker();

    await Get.bottomSheet(
      Container(
        decoration:  BoxDecoration(
          color: ThemeUtils.primaryColor.withOpacity(0.6),
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.all(20),
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt,color: Colors.white70,),
              title: const Text('Open Camera',style: TextStyle(letterSpacing: 1.4,color: Colors.white70,),),
              onTap: () async {
                final pickedFile = await picker.pickImage(source: ImageSource.camera);
                if (pickedFile != null) {
                  if (isSelfie) {
                    selfieImageFile = File(pickedFile.path);
                  } else {
                    idImageFile = File(pickedFile.path);
                  }
                }
                update(); // Notify UI
                Get.back();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo,color: Colors.white70,),
              title: const Text('Choose from Gallery',style: TextStyle(letterSpacing: 1.4,color: Colors.white70,),),
              onTap: () async {
                final pickedFile = await picker.pickImage(source: ImageSource.gallery);
                if (pickedFile != null) {
                  if (isSelfie) {
                    selfieImageFile = File(pickedFile.path);
                  } else {
                    idImageFile = File(pickedFile.path);
                  }
                }
                update(); // Notify UI
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
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

