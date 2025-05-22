import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fx_crm/controller/ledger_wallet_controller.dart';
import 'package:fx_crm/widgets/custom_text_form.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart' as nb;
import 'package:shimmer/shimmer.dart';

import '../../../../../widgets/bg_container.dart';
import '../../../../../widgets/drop_down_text_field.dart';
import 'component/wallet_card_shimmer.dart';

class WalletLedger extends StatefulWidget {
  const WalletLedger({super.key});

  @override
  State<WalletLedger> createState() => _WalletLedgerState();
}

class _WalletLedgerState extends State<WalletLedger> {
  final WalletLedgerController controller = Get.put(WalletLedgerController());
  final scrollController = ScrollController();

  // Track expanded state per item
  final Map<int, bool> expandedMap = {};

  @override
  void initState() {
    super.initState();
    nb.afterBuildCreated(() {
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
            Obx(
              () => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  " \$${controller.totalBalance}",
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                children: [
                  _buildTransferButton("Wallet to MT5", Colors.amber.shade700,() {
                    showTransferWalletDialog("Wallet to MT5");
                  },),
                  const SizedBox(width: 8),
                  _buildTransferButton("MT5 to Wallet", Colors.blue,() {
                    showTransferWalletDialog("MT5 to Wallet");
                  },),
                  const SizedBox(width: 8),
                  _buildTransferButton("Withdraw Funds", Colors.green,() {

                  },),
                ],
              ),
              const SizedBox(height: 16),
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

                return Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async => refresh(loading: false),
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: controller.ledgerList.length,
                      itemBuilder: (context, index) {
                        final item = controller.ledgerList[index];

                        final double credit =
                            double.tryParse(item.credit?.toString() ?? '0') ??
                            0;
                        final double debit =
                            double.tryParse(item.debit?.toString() ?? '0') ?? 0;
                        final double balance =
                            double.tryParse(item.balance?.toString() ?? '0') ??
                            0;

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

                                // Note (Expandable)
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

                                // Credit and Debit Row
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.call_received,
                                          color: Colors.green,
                                          size: 18,
                                        ),
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
                                        Icon(
                                          Icons.call_made,
                                          color: Colors.red,
                                          size: 18,
                                        ),
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
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
  void showTransferWalletDialog(String title) {
    String? selectedValue;
    final accountKindController = TextEditingController(); // Use a controller
    final _accountKindKey = GlobalKey<FormFieldState<String>>();
    AwesomeDialog(
      context: context,
      dialogType: DialogType.info,
      animType: AnimType.scale,
      width: 400,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Obx(() {
          if (controller.transferWalletList.isEmpty) {
            return const Center(child: LedgerShimmerCard());
          }

          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
               Text(
               title ??  'Select Wallet',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              DropDownTextFormField(
                key: _accountKindKey,
                label: 'Wallet',
                hint: 'Choose Wallet',
                colors: Colors.white70,
                controller: accountKindController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator: (value) =>
                (value == null || value.isEmpty) ? 'Please select a wallet' : null,
                onTap: controller.transferWalletList.isNotEmpty
                    ? () {
                  _showDropdownMenu(
                    _accountKindKey,
                    controller.transferWalletList.map((e) => e.name ?? '').toList(),
                    accountKindController,
                  );
                }
                    : null,
              ),
              const SizedBox(height: 20),
              CustomTextFormField(label: "Amount", hint: "Enter the amount",fillColor: Colors.white,),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      if (selectedValue != null) {
                        Navigator.pop(context);
                        // Proceed with your logic
                        print("Selected Wallet Value: $selectedValue");
                      } else {
                        Get.snackbar('Error', 'Please select a wallet',
                            backgroundColor: Colors.red, colorText: Colors.white);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                    child: const Text('Continue', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ],
          );
        }),
      ),
    ).show();
  }

  void _showDropdownMenu(
      GlobalKey key,
      List<String> options,
      TextEditingController controller,
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
    }

  }
  Widget _buildTransferButton(String label, Color bgColor,VoidCallback onPressed) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onPressed,
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


