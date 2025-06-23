import 'package:flutter/material.dart';
import 'package:fx_crm/controller/wallet_controller.dart';
import 'package:fx_crm/view/component/drawer_component/component/funds/component/payment_info.dart';
import 'package:fx_crm/view/component/drawer_component/component/funds/component/wallet_card_shimmer.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart' hide DialogType;

import '../../../../../widgets/bg_container.dart';
import '../../../../../widgets/custom_text_form.dart';
import '../../../../../widgets/drop_down_text_field.dart';
import '../../../../../widgets/glass_card.dart';

class DepositFundScreen extends StatefulWidget {
  const DepositFundScreen({super.key});

  @override
  State<DepositFundScreen> createState() => _DepositFundScreenState();
}

class _DepositFundScreenState extends State<DepositFundScreen> {
  final WalletController controller = Get.put(WalletController());
  final ScrollController scrollController = ScrollController();
  int _selectedIndex = 0;

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
          child: IndexedStack(
            index: _selectedIndex,
            children: [depositHistory(), DepositFundDialog()],
          ),
        ),
        bottomNavigationBar: GlassCard(
          margin: EdgeInsets.zero,
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            backgroundColor: Colors.transparent,
            selectedItemColor: const Color(0xff0d6efd),
            unselectedItemColor: Colors.white60,
            type: BottomNavigationBarType.fixed,
            onTap: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.receipt_outlined),
                label: "Deposit History",
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.account_balance_wallet),
                label: "Deposit Fund",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Obx depositHistory() {
    return Obx(() {
      if (controller.isLoading.value && controller.depositList.isEmpty) {
        return const LedgerShimmerCard();
      }

      if (controller.errorMessage.isNotEmpty &&
          controller.depositList.isEmpty) {
        return Center(child: Text(controller.errorMessage.value));
      }

      if (!controller.isLoading.value && controller.depositList.isEmpty) {
        return const Center(
          child: Text(
            "No Data Found",
            style: TextStyle(color: Colors.white70, fontSize: 16),
          ),
        );
      }

      return ListView.builder(
        controller: scrollController,
        itemCount: controller.depositList.length,
        itemBuilder: (context, index) {
          // No need to check index == length since itemCount is length
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
                        (context) => PaymentInfoScreen(trxId: record.orderId!),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(8),
              child: GlassCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Date: ${record.createdAt ?? '-'}",
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Colors.white54,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: controller.statusColor(record.status),
                            borderRadius: BorderRadius.circular(8),
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
                          color: Colors.white,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          "Amount: ₹${record.amount ?? '0.00'}",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Request ID: ${record.orderId ?? '-'}",
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      );
    });
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
  final accountKindController = TextEditingController();
  final accountKindKey = GlobalKey<FormFieldState<String>>();
  final WalletController controller = Get.put(WalletController());

  double getAmount(dynamic value) {
    return value.toString().replaceAll(',', '').toDouble();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomTextFormField(
            label: "Amount",
            hint: "Enter amount",
            controller: amountController,
            validator: (value) {
              final entered = double.tryParse(value ?? '') ?? 0;
              final max = getAmount(controller.totalBalance.value);

              if (value == null || value.isEmpty) {
                return 'Amount is required';
              }
              if (entered <= 0) {
                return 'Amount must be greater than 0';
              }
              if (entered > max) {
                return 'You cannot enter more than your balance (₹$max)';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          DropDownTextFormField(
            key: accountKindKey,
            label: 'Payment Type',
            hint: 'Choose Payment Type',
            fieldStyle: const TextStyle(color: Colors.white70),
            textStyle: const TextStyle(color: Colors.white70),
            dropdownDisableColor: Colors.white70,
            dropdownEnableColor: Colors.white70,
            controller: accountKindController,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator:
                (value) =>
                    (value == null || value.isEmpty)
                        ? 'Please select a payment type'
                        : null,
            onTap:
                controller.withDrawFundList.isNotEmpty
                    ? () {
                      _showDropdownMenu(
                        context,
                        accountKindKey,
                        controller.withDrawFundList
                            .map((e) => e.name ?? '')
                            .toList(),
                        accountKindController,
                        controller,
                      );
                    }
                    : null,
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 45,
            width: double.infinity,
            child: ElevatedButton(
              onPressed:
                  isLoading
                      ? null
                      : () async {
                        if (!_formKey.currentState!.validate()) {
                          return;
                        }

                        // Use the selected payment type from dropdown controller
                        selectedPaymentType = accountKindController.text;

                        toast(
                          "Submitting ₹${amountController.text} via $selectedPaymentType",
                        );

                        var id = await controller.depositFundRequest(
                          amount: amountController.text.trim(),
                          paymentMethod: selectedPaymentType!,
                        );
                        if (id == null) {
                          toast("Failed to submit deposit request");
                          return;
                        }
                        if (context.mounted) Navigator.pop(context, true);
                      },
              child: const Text("Submit"),
            ),
          ),
        ],
      ),
    );
  }

  void _showDropdownMenu(
    BuildContext context,
    GlobalKey key,
    List<String> options,
    TextEditingController controller,
    WalletController walletController,
  ) async {
    final RenderBox renderBox =
        key.currentContext!.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;
    final selected = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy + size.height,
        offset.dx + size.width,
        offset.dy,
      ),
      items:
          options
              .map(
                (option) =>
                    PopupMenuItem<String>(value: option, child: Text(option)),
              )
              .toList(),
    );
    if (selected != null) {
      controller.text = selected;
      walletController.selectedWithdrawOption.value = walletController
          .withDrawFundList
          .firstWhere((element) => element.name == selected);
    }
  }
}
