import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../../controller/wallet_controller.dart';
import '../../../../../widgets/bg_container.dart';
import '../../../../../widgets/glass_card.dart';
import 'component/wallet_card_shimmer.dart';
import 'component/with_draw_fund_invoice.dart';
import 'component/withdraw_request_screen.dart';

class WithdrawFundScreen extends StatefulWidget {
  const WithdrawFundScreen({super.key});

  @override
  State<WithdrawFundScreen> createState() => _WithdrawFundScreenState();
}

class _WithdrawFundScreenState extends State<WithdrawFundScreen> {
  final WalletController controller = Get.put(WalletController());
  int _selectedIndex = 0;
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
          child: IndexedStack(
            index: _selectedIndex,
            children: [
              _buildHistory(),

              _buildWithdrawTab(),
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
                label: "Fund History",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_balance_wallet),
                label: "Withdraw",
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildWithdrawTab() {
    return WithdrawRequestScreen();
  }
  Obx _buildHistory() {
    return Obx(() {
          if (controller.isLoading.value) {
            return LedgerShimmerCard();
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
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => WithdrawInvoiceScreen(data: item),
                    ),
                  );
                },
                child: GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Top Row: Request ID & Date
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _infoBlock("Request ID", item.requestId.toString()),
                          _infoBlock(
                            "Date",
                            controller.formatDate(item.createdAt.toString()),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      /// User Info
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _infoBlock("User ID", item.username.toString()),
                          _infoBlock(
                            "Name",
                            item.accountHolderName.toString(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      /// Amount and Status
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Amount: \$${item.amount}",
                            style: TextStyle(
                              color: Colors.green.shade800,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: controller.statusColor(item.status),
                              borderRadius: BorderRadius.circular(30),
                              boxShadow: [
                                BoxShadow(
                                  color: controller
                                      .statusColor(item.status)
                                      .withOpacity(0.4),
                                  blurRadius: 6,
                                  offset: const Offset(2, 4),
                                ),
                              ],
                            ),
                            child: Text(
                              controller.statusText(item.status),
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        });
  }

  Widget _infoBlock(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: TextStyle(fontSize: 12, color: Colors.white70)),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
