import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../../controller/ledger_wallet_controller.dart';
import '../../../../../widgets/bg_container.dart';
import 'component/common_transfer_wallet.dart';
import 'component/wallet_card_shimmer.dart';

class DepositWithdrawHistoryScreen extends StatefulWidget {
  const DepositWithdrawHistoryScreen({super.key});

  @override
  State<DepositWithdrawHistoryScreen> createState() =>
      _DepositWithdrawHistoryScreenState();
}

class _DepositWithdrawHistoryScreenState
    extends State<DepositWithdrawHistoryScreen> {
  final WalletLedgerController controller = Get.put(WalletLedgerController());

  final scrollController = ScrollController();

  final Map<int, bool> expandedMap = {};
  @override
  void initState() {
    super.initState();
    afterBuildCreated(() {
      refresh();
      if (scrollController.hasClients) {
        scrollController.addListener(_listener);
      }
    });

    controller.getFundWays();
  }

  void _listener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      refresh(refresh: false, loading: false);
    }
  }

  Future<void> refresh({bool refresh = true, bool loading = true}) async {
    await  controller.getAccountStatement(refresh: refresh, loading: loading);
  }

  @override
  void dispose() {
    scrollController.removeListener(_listener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          title: const Text(
            "Deposit | Withdraw",
            style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
          elevation: 0,
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      showTransferWalletDialog("Wallet to MT5", context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber.shade700,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Wallet to MT5",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      showTransferWalletDialog("MT5 to Wallet", context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "MT5 to wallet",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
    Obx(() {
    if (controller.isLoading.value) {
    return LedgerShimmerCard();
    }

    if (controller.errorMessage.isNotEmpty) {
    return Center(
    child: Text(
    controller.errorMessage.value,
    style: TextStyle(color: Colors.white),
    ),
    );
    }

    return   Expanded(
                child: RefreshIndicator(
                  onRefresh: () async => refresh(loading: false),
                  child: ListView.builder(
                    controller: scrollController,
                    itemCount: controller.accountStatement.length,
                    itemBuilder: (context, index) {
                      final item = controller.accountStatement[index];
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
                              // First Row - Ticket ID and Type
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Ticket ID: #${item.ticket}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.blueGrey.shade700,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: item.type == "DEPOSIT" ? Colors.indigo.shade50 :Colors.redAccent.shade100,
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                     item.type ?? '',
                                      style: TextStyle(
                                        color:  item.type == "DEPOSIT" ? Colors.indigo.shade600 : Colors.redAccent.shade400,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              // Amount and Status
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Amount: \$${item.amount ?? "0.0"}",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.green.shade700,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: controller.statusColor(item.status).withOpacity(0.3),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      controller.statusText(item.status),
                                      style: TextStyle(
                                        color: controller.statusColor(item.status),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              // Timestamp
                              Row(
                                children: [
                                  Icon(
                                    Icons.access_time,
                                    size: 16,
                                    color: Colors.grey.shade600,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    "Transaction Time: ${formatDateTime(item.createdAt.toString())}",
                                    style: TextStyle(
                                      color: Colors.grey.shade700,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              // Remarks
                              Text(
                                "Remarks: ${item.comment ?? ""}",
                                style: TextStyle(
                                  color: Colors.grey.shade700,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              );}),
            ],
          ),
        ),
      ),
    );
  }
  String formatDateTime(String inputDateTime) {
    // Parse the input string to DateTime
    DateTime parsedDate = DateTime.parse(inputDateTime);

    // Format the DateTime to desired format
    String formattedDate = DateFormat('dd/MM/yyyy h:mm a').format(parsedDate);

    return formattedDate;
  }

}
