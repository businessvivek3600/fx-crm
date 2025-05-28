import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fx_crm/controller/ledger_wallet_controller.dart';
import 'package:fx_crm/view/component/drawer_component/component/funds/component/payment_info.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart' hide DialogType;

import '../../../../../widgets/bg_container.dart';

class DepositFundScreen extends StatefulWidget {
  const DepositFundScreen({super.key});

  @override
  State<DepositFundScreen> createState() => _DepositFundScreenState();
}

class _DepositFundScreenState extends State<DepositFundScreen> {
  final WalletLedgerController controller = Get.put(WalletLedgerController());
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    afterBuildCreated(() {
      controller.fetchWalletDeposits();
      scrollController.addListener(_scrollListener);
    });
  }

  void _scrollListener() {
    if (scrollController.position.pixels >=
        scrollController.position.maxScrollExtent - 100) {
      controller.fetchWalletDeposits(refresh: false, loading: false);
    }
  }

  @override
  void dispose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
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
            "Deposit Funds",
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
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _showDepositDialog(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber.shade700,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Deposit Fund",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Expanded(
                child: Obx(() {
                  if (controller.isLoading.value &&
                      controller.depositList.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (controller.errorMessage.isNotEmpty &&
                      controller.depositList.isEmpty) {
                    return Center(child: Text(controller.errorMessage.value));
                  }

                  return ListView.builder(
                    controller: scrollController,
                    itemCount: controller.depositList.length,
                    itemBuilder: (context, index) {
                      if (index == controller.depositList.length) {
                        if (controller.hasMoreData.value) {
                          return const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        } else {
                          return const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(child: Text("No more records")),
                          );
                        }
                      }

                      final record = controller.depositList[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: InkWell(
                          onTap: () {
                            if (record.txnId == null || record.txnId!.isEmpty) {
                              toast("Transaction ID is not available");
                              return;
                            }
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => PaymentInfoScreen(
                                      trxId: record.orderId!,
                                    ),
                              ),
                            );
                          },

                          borderRadius: BorderRadius.circular(8),
                          child: Card(
                            elevation: 1,
                            color: Colors.grey.shade100,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Date: ${record.createdAt ?? '-'}",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: controller.statusColor(
                                            record.status,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Text(
                                          controller.statusText(record.status),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.account_balance_wallet_outlined,
                                        size: 18,
                                        color: Colors.black87,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        "Amount: ₹${record.amount ?? '0.00'}",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black87,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    "Request ID: ${record.orderId ?? '-'}",
                                    style: const TextStyle(
                                      color: Colors.black54,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDepositDialog(BuildContext context) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.info,
      animType: AnimType.scale,
      width: 400,
      body: DepositFundDialog(),
    ).show();
  }
}

class DepositFundDialog extends StatefulWidget {
  const DepositFundDialog({super.key});

  @override
  State<DepositFundDialog> createState() => _DepositFundDialogState();
}

class _DepositFundDialogState extends State<DepositFundDialog> {
  final TextEditingController amountController = TextEditingController();
  String? selectedPaymentType;
  final List<String> paymentTypes = ['UPI', 'Bank Transfer', 'BitCoin', "USDT"];
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Deposit Fund",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Amount',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter an amount';
                }
                final amount = double.tryParse(value);
                if (amount == null || amount <= 0) {
                  return 'Please enter a valid amount';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              value: selectedPaymentType,
              items:
                  paymentTypes.map((type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedPaymentType = value;
                });
              },
              decoration: InputDecoration(
                labelText: 'Payment Type',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select a payment type';
                }
                return null;
              },
            ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                onPressed:
                    isLoading
                        ? null
                        : () async {
                          if (!_formKey.currentState!.validate()) {
                            return;
                          }

                          toast(
                            "Submitting ₹${amountController.text} via $selectedPaymentType",
                          );
                          var id = await Get.find<WalletLedgerController>()
                              .depositFundRequest(
                                amount: amountController.text.trim(),
                                paymentMethod: selectedPaymentType!,
                              );
                          if (id == null) {
                            toast("Failed to submit deposit request");
                            return;
                          }
                          if (context.mounted) Navigator.pop(context, true);

                          // Optionally call API or navigate to next screen
                        },
                child: const Text("Submit"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
