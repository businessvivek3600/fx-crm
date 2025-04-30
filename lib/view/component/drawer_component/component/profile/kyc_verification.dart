import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

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
  Widget build(BuildContext context) {
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
                          hint: 'Select Document',
                          controller: kycController.documentController,
                          readOnly: true,
                          onTap: kycController.selectDocument,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          "Upload ID",
                          style: TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 8),
                        kycController
                                    .kycData
                                    .value
                                    ?.uploadFirstProof
                                    ?.isNotEmpty ==
                                true
                            ? Center(
                              child: Image.network(
                                kycController.kycData.value!.uploadFirstProof!,
                                height: 150,
                                fit: BoxFit.cover,
                              ),
                            )
                            : Row(
                              children: [
                                ElevatedButton(
                                  onPressed:
                                      () => kycController.pickFile(false),
                                  child: const Text("Choose file"),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    kycController.idFileName ??
                                        "No file chosen",
                                    style: const TextStyle(color: Colors.grey),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),

                        const SizedBox(height: 24),
                        Text(
                          "Upload Selfie With ID",
                          style: TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 8),
                        kycController
                                    .kycData
                                    .value
                                    ?.uploadSecondProof
                                    ?.isNotEmpty ==
                                true
                            ? Center(
                              child: Image.network(
                                kycController.kycData.value!.uploadSecondProof!,
                                height: 150,
                                fit: BoxFit.cover,
                              ),
                            )
                            : Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () => kycController.pickFile(true),
                                  child: const Text("Choose file"),
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    kycController.selfieFileName ??
                                        "No file chosen",
                                    style: const TextStyle(color: Colors.grey),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),

                        const SizedBox(height: 24),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton(
                            onPressed: () {
                              // Submit logic
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
