import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../../controller/wallet_controller.dart';
import '../../../../../widgets/bg_container.dart';
import '../../../../../widgets/glass_card.dart';
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
    await controller.getAccountStatement(refresh: refresh, loading: loading);
  }

  @override
  void dispose() {
    scrollController.removeListener(_listener);
    super.dispose();
  }
  int _selectedIndex = 0;
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
          child: IndexedStack(
            index: _selectedIndex,
            children: [
              _buildHistory(),
              _buildTransferTab("Wallet to MT5"), // Index 1
              _buildTransferTab("MT5 to Wallet"), // Index 2
            ],
          ),
        ),
        bottomNavigationBar: GlassCard(
          padding: const EdgeInsets.only(top: 10),
          margin: EdgeInsets.zero,
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            backgroundColor: Colors.transparent,
            selectedItemColor:  Color(0xff0d6efd),
            unselectedItemColor: Colors.white60,
            type: BottomNavigationBarType.fixed,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.receipt_long),
                label: "History",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.swap_horiz),
                label: "Wallet → MT5",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.swap_horizontal_circle),
                label: "MT5 → Wallet",
              ),

            ],
          ),
        ),
      ),
    );
  }
  Widget _buildTransferTab(String title) {
    return  showTransferWalletDialog(title, context
    );
  }

  Obx _buildHistory() {
    return Obx(() {
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

              return RefreshIndicator(
                onRefresh: () async => refresh(loading: false),
                child: ListView.builder(
                  controller: scrollController,
                  itemCount: controller.accountStatement.length,
                  itemBuilder: (context, index) {
                    final item = controller.accountStatement[index];
                    return GlassCard(
                      child:Column(
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
                                    color: Colors.blue.shade400,
                                    fontSize: 14,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        item.type == "DEPOSIT"
                                            ? Colors.indigo.shade50
                                            : Colors.redAccent.shade100,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    item.type ?? '',
                                    style: TextStyle(
                                      color:
                                          item.type == "DEPOSIT"
                                              ? Colors.indigo.shade600
                                              : Colors.redAccent.shade400,
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
                                    color: controller
                                        .statusColor(item.status)
                                        .withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    controller.statusText(item.status),
                                    style: TextStyle(
                                      color: controller.statusColor(
                                        item.status,
                                      ),
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
                                  color: Colors.white70,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  "Transaction Time: ${formatDateTime(item.createdAt.toString())}",
                                  style: TextStyle(
                                    color: Colors.white70,
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
                                color: Colors.white54,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                    );
                  },
                ),
              );
            });
  }

  String formatDateTime(String inputDateTime) {
    DateTime parsedDate = DateTime.parse(inputDateTime);
    String formattedDate = DateFormat('dd/MM/yyyy h:mm a').format(parsedDate);

    return formattedDate;
  }
}
