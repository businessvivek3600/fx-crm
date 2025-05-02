import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart'; // Import the flutter_html package
import 'package:fx_crm/controller/app_controller.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../controller/dashboard_controller.dart';
import '../../../../../main.dart';
import '../../../../../widgets/bg_container.dart';

class TermsAndConditionsScreen extends StatefulWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  State<TermsAndConditionsScreen> createState() => _TermsAndConditionsScreenState();
}

class _TermsAndConditionsScreenState extends State<TermsAndConditionsScreen> {
  late final DashBoardController dashBoardController;
  @override
  void initState() {
    super.initState();
    dashBoardController = Get.put(DashBoardController(dioClient: dioClient)); // Provide dioClient
    dashBoardController.getTermsAndCondition();

  }
  @override
  Widget build(BuildContext context) {
    return BackgroundContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text(
            'Terms & Conditions',
            style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
          elevation: 0,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Card(
              elevation: 1,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              color: Colors.grey.shade100,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.description_outlined, color: Colors.blueGrey.shade700),
                        const SizedBox(width: 8),
                        Text(
                          'Terms & Conditions',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey.shade800,
                          ),
                        ),
                      ],
                    ),
                    const Divider(height: 30, thickness: 1),
              Obx(() {
                if (dashBoardController.isLoading.value) {
                  return Shimmer.fromColors(
                    baseColor: Colors.grey.shade300,
                    highlightColor: Colors.grey.shade100,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                      Container(
                      height: 20,
                      width: 200,
                      color: Colors.white,
                      margin: const EdgeInsets.only(bottom: 12),
                    ),
                    Container(
                      height: 14,
                      width: double.infinity,
                      color: Colors.white,
                      margin: const EdgeInsets.only(bottom: 8),
                    ),
                    Container(
                      height: 14,
                      width: double.infinity,
                      color: Colors.white,
                      margin: const EdgeInsets.only(bottom: 8),
                    )]));
                }
                return Html(
                      data: dashBoardController.termsHtml.value ?? "",
                      style: {
                        "p": Style(
                          color: Colors.blueGrey.shade700,
                          fontSize: FontSize(15),
                        ),
                      },
                    );}),
                  ],
                ),
              ),
            ),
          )

      ),
    );
  }
}
