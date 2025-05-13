
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../controller/kyc_controller.dart';
import '../../../../../main.dart';
import '../../../../../widgets/bg_container.dart';
import '../../../../../widgets/drop_down_text_field.dart';
import 'widgets/kyc_widgets.dart';

class KycUploadScreen extends StatefulWidget {
  const KycUploadScreen({super.key});

  @override
  State<KycUploadScreen> createState() => _KycUploadScreenState();
}

class _KycUploadScreenState extends State<KycUploadScreen> {
  late final KycController kycController;
  @override
  void initState() {
    super.initState();
    kycController = Get.put(
      KycController(dioClient: dioClient),
    ); // Provide dioClient
    kycController.getKycDetails();
  }
  @override
  void dispose() {
    // Clear selected files
    kycController.idImageFile = null;
    kycController.selfieImageFile = null;
    kycController.update();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {

    final String kycStatus = kycController.kycData.value?.status?.toLowerCase() ?? '';
    return BackgroundContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            'KYC',
            style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 2),
          ),
          centerTitle: true,
        ),
        body: Obx(() {
          if (kycController.isLoading.value) {
            return buildShimmer();
          }

          final status =
              int.tryParse(kycController.kycData.value?.status ?? '') ?? 0;
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  buildStatusBanner(status),
                  const SizedBox(height: 24),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade900.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "📄 KYC Upload",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            buildHeader(status),
                          ],
                        ),
                        const SizedBox(height: 20),
                        DropDownTextFormField(
                          key: kycController.documentKey,
                          colors: Colors.white,
                          label: 'Document Type',
                           style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.2,
                        ),
                          hint: 'Select Document',
                          controller: kycController.documentController,
                          readOnly: kycStatus == 1 || kycStatus == 3,
                          onTap: kycStatus == 1 || kycStatus == 3 ? null : kycController.selectDocument,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          "Upload ID",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),


                        const SizedBox(height: 20),
                        GetBuilder<KycController>(
                          builder: (_) {
                            if (kycController.idImageFile != null) {
                              return Stack(
                                children: [
                                  Image.file(
                                    kycController.idImageFile!,
                                    height: 120,
                                    width: 120,
                                    fit: BoxFit.contain,
                                  ),
                                  Positioned(
                                    right: 0,
                                    top: -10,
                                    child: IconButton(
                                      icon: Icon(Icons.cancel, color: Colors.white70,size: 25,),
                                      onPressed: () {
                                        kycController.idImageFile = null;
                                        kycController.update();
                                      },
                                    ),
                                  ),
                                ],
                              );
                            } else if (kycController.kycData.value?.uploadFirstProof?.isNotEmpty == true) {
                              return Image.network(
                                kycController.kycData.value!.uploadFirstProof!,
                                height: 120,
                                width: 120,
                                fit: BoxFit.contain,
                              );
                            } else {
                              return Row(
                                children: [
                                  ElevatedButton(
                                    onPressed: () => kycController.pickFile(false),
                                    child: const Text("Choose file"),
                                  ),
                                  const SizedBox(width: 10),
                                  const Expanded(
                                    child: Text(
                                      "No file chosen",
                                      style: TextStyle(color: Colors.grey),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              );
                            }
                          },
                        ),


                        const SizedBox(height: 24),
                        Text(
                          "Upload Selfie",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),

                        const SizedBox(height: 20),
                        GetBuilder<KycController>(
                          builder: (_) {
                            if (kycController.selfieImageFile != null) {
                              return Stack(
                                children: [
                                  Image.file(
                                    kycController.selfieImageFile!,
                                    height: 120,
                                    width: 120,
                                    fit: BoxFit.contain,
                                  ),
                                  Positioned(
                                    right: 0,
                                    top: -10,
                                    child: IconButton(
                                      icon: Icon(Icons.cancel, color: Colors.white70,size: 25,),
                                      onPressed: () {
                                        kycController.selfieImageFile = null;
                                        kycController.update();
                                      },
                                    ),
                                  ),
                                ],
                              );
                            } else if (kycController.kycData.value?.uploadSecondProof?.isNotEmpty == true) {
                              return Image.network(
                                kycController.kycData.value!.uploadSecondProof!,
                                height: 120,
                                width: 120,
                                fit: BoxFit.contain,
                              );
                            } else {
                              return Row(
                                children: [
                                  ElevatedButton(
                                    onPressed: () => kycController.pickFile(true),
                                    child: const Text("Choose file"),
                                  ),
                                  const SizedBox(width: 10),
                                  const Expanded(
                                    child: Text(
                                      "No file chosen",
                                      style: TextStyle(color: Colors.grey),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              );
                            }
                          },
                        ),

                        const SizedBox(height: 24),
                        Align(
                          alignment: Alignment.centerRight,
                          child: (kycStatus == "1" || kycStatus == "3")
                              ? const SizedBox()  // Empty container to hide the button
                              : ElevatedButton(
                            onPressed: () {
                              kycController.uploadKyc();
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey.shade800,
                            ),
                            child: const Text("Submit"),
                          ),
                        ),

                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
