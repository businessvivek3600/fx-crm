// lib/wallet_ledger_screen.dart

import 'package:flutter/material.dart';
import 'package:fx_crm/controller/ledger_wallet_controller.dart';
import 'package:fx_crm/view/component/drawer_component/component/funds/component/withdraw__funds_screen.dart';
import 'package:fx_crm/widgets/bg_container.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
 // Import the new screen

class WalletLedger extends StatefulWidget {
  const WalletLedger({super.key});

  @override
  State<WalletLedger> createState() => _WalletLedgerState();
}

class _WalletLedgerState extends State<WalletLedger> {
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
  }

  void _listener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      refresh(refresh: false, loading: false);
    }
  }

  Future<void> refresh({bool refresh = true, bool loading = true}) async {
    await controller.fetchWalletLedger(refresh: refresh, loading: loading);
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
          elevation: 0,
          title: const Text(
            "Ledger Wallet",
            style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
          centerTitle: true,
          actions: [
            Obx(() => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Text(
                    " \$${controller.totalBalance}",
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                )),
          ],
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.errorMessage.isNotEmpty) {
            return Center(
              child: Text(
                controller.errorMessage.value,
                style: const TextStyle(color: Colors.white),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                Row(
                  children: [
                    _buildTransferButton("Wallet to MT5", Colors.amber.shade700),
                    const SizedBox(width: 8),
                    _buildTransferButton("MT5 to Wallet", Colors.blue),
                    const SizedBox(width: 8),
                    _buildTransferButton("Withdraw Funds", Colors.green, onTap: () {
                      Get.to(() =>  WithdrawFundsScreen());
                    }),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async => refresh(loading: false),
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: controller.ledgerList.length,
                      itemBuilder: (context, index) {
                        final item = controller.ledgerList[index];

                        final double credit =
                            double.tryParse(item.credit?.toString() ?? '0') ?? 0;
                        final double debit =
                            double.tryParse(item.debit?.toString() ?? '0') ?? 0;
                        final double balance =
                            double.tryParse(item.balance?.toString() ?? '0') ?? 0;
                        final String note = item.note ?? '';
                        final isExpanded = expandedMap[index] ?? false;

                        return Card(
                          elevation: 1,
                          color: Colors.grey.shade100,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          margin: const EdgeInsets.only(bottom: 12),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Date: ${item.date ?? '-'}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey.shade800,
                                        fontSize: 14,
                                      ),
                                    ),
                                    Text(
                                      "Balance: \$${balance.toStringAsFixed(2)}",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.green.shade700,
                                        fontSize: 14,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 14),
                                Text(
                                  note,
                                  maxLines: isExpanded ? null : 3,
                                  overflow: TextOverflow.fade,
                                  textAlign: TextAlign.justify,
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontSize: 13,
                                  ),
                                ),
                                if (note.length > 100)
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        expandedMap[index] = !isExpanded;
                                      });
                                    },
                                    child: Text(
                                      isExpanded ? 'Show less' : 'Show more',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ),
                                const SizedBox(height: 8),
                                Divider(color: Colors.grey.shade300),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.call_received,
                                            color: Colors.green, size: 18),
                                        const SizedBox(width: 4),
                                        Text(
                                          "In: \$${credit.toStringAsFixed(2)}",
                                          style: TextStyle(
                                            color: Colors.green.shade700,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        const Icon(Icons.call_made,
                                            color: Colors.red, size: 18),
                                        const SizedBox(width: 4),
                                        Text(
                                          "Out: \$${debit.toStringAsFixed(2)}",
                                          style: TextStyle(
                                            color: Colors.red.shade700,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildTransferButton(String label, Color bgColor, {VoidCallback? onTap}) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onTap ?? () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: bgColor,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Text(
            label,
            style: const TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

