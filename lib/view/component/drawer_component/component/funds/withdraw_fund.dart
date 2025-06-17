import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../../controller/wallet_controller.dart';
import '../../../../../widgets/bg_container.dart';
import 'component/with_draw_fund_invoice.dart';

class WithdrawFundScreen extends StatefulWidget {
  const WithdrawFundScreen({super.key});

  @override
  State<WithdrawFundScreen> createState() => _WithdrawFundScreenState();
}

class _WithdrawFundScreenState extends State<WithdrawFundScreen> {
  final WalletController controller = Get.put(WalletController());

  final scrollController = ScrollController();

  final Map<int, bool> expandedMap = {};
  @override
  void initState() {
    super.initState();
    controller.getFundWays();
    afterBuildCreated(() {
      refresh();
      if (scrollController.hasClients) {
        scrollController.addListener(_listener);
      }
    });
  }

  void _listener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      refresh(refresh: false, loading: false);
    }
  }

  Future<void> refresh({bool refresh = true, bool loading = true}) async {
    await controller.getWithDrawList(refresh: refresh, loading: loading);
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
            "Withdraw Fund",
            style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            if (controller.withDrawHistory.isEmpty) {
              return const Center(
                child: Text(
                  "No withdrawal history found.",
                  style: TextStyle(color: Colors.white),
                ),
              );
            }

            return ListView.builder(
              controller: scrollController,
              itemCount: controller.withDrawHistory.length,
              itemBuilder: (context, index) {
                final item = controller.withDrawHistory[index];
                return Card(
                  elevation: 1,
                  color: Colors.grey.shade100,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              flex: 5,
                              child: Text(
                                "Request ID: ${item.requestId}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blueGrey,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Flexible(
                              flex: 2,
                              child: Text(
                                "Date: ${controller.formatDate(item.createdAt.toString())}",
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontSize: 13,
                                ),
                                textAlign: TextAlign.justify,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.person_outline,
                              size: 18,
                              color: Colors.grey.shade600,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              "User ID: ${item.username}",
                              style: TextStyle(
                                color: Colors.grey.shade800,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Name: ${item.accountHolderName}",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Amount: \$${item.amount}",
                              style: TextStyle(
                                color: Colors.green.shade700,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: controller.statusColor(item.status),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                controller.statusText(item.status),
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                        // const SizedBox(height: 8),
                        // Text(
                        //   "Remarks: Waiting for payment approval.",
                        //   style: TextStyle(
                        //     color: Colors.grey.shade700,
                        //     fontSize: 13,
                        //   ),
                        // ),
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade600,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 8,
                              ),
                            ),
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) => WithdrawInvoiceScreen(data: item),
                                ),
                              );
                            },

                            icon: const Icon(
                              Icons.visibility_outlined,
                              size: 16,
                              color: Colors.white,
                            ),
                            label: const Text(
                              "View",
                              style: TextStyle(fontSize: 13),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }),
        ),
      ),
    );
  }
}
