import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fx_crm/view/component/drawer_component/component/funds/component/wallet_card_shimmer.dart';
import 'package:get/get.dart';

import '../../../../../../controller/wallet_controller.dart';
import '../../../../../../widgets/custom_text_form.dart';
import '../../../../../../widgets/drop_down_text_field.dart';

Widget showTransferWalletDialog(String title, BuildContext context) {
  final WalletController controller = Get.put(WalletController());
  String? selectedValue;
  final accountKindController = TextEditingController();
  final amountController = TextEditingController();
  final accountKindKey = GlobalKey<FormFieldState<String>>();
  final formKey = GlobalKey<FormState>();
 return Obx(() {
        if (controller.transferWalletList.isEmpty) {
          return const Center(child: LedgerShimmerCard());
        }

        return Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title ?? 'Select Wallet',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: Colors.white),
              ),
              const SizedBox(height: 20),
              DropDownTextFormField(
                key: accountKindKey,
                label: 'Wallet',
                hint: 'Choose Wallet',

                controller: accountKindController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator:
                    (value) =>
                        (value == null || value.isEmpty)
                            ? 'Please select a wallet'
                            : null,
                onTap:
                    controller.transferWalletList.isNotEmpty
                        ? () {
                          _showDropdownMenu(
                            context,
                            accountKindKey,
                            controller.transferWalletList
                                .map((e) => e.name ?? '')
                                .toList(),
                            accountKindController,
                          );
                        }
                        : null,
              ),
              const SizedBox(height: 20),
              CustomTextFormField(
                label: "Amount",
                hint: "Enter the amount",
                controller:  amountController,
                // keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter an amount";
                  }
                  final enteredAmount = double.tryParse(value.trim());
                  if (enteredAmount == null) return "Enter a valid number";

                  if (title == "Wallet to MT5") {
                    final balance =
                        double.tryParse(
                          controller.totalBalance.value.toString(),
                        ) ??
                        0.0;
                    if (enteredAmount > balance) {
                      return "Amount exceeds wallet balance";
                    }
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 45,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      Navigator.pop(context);
                      // Proceed with your logic here
                      print("Selected Wallet: ${accountKindController.text}");
                      print("Amount: ${amountController.text}");
                      print("Transfer Type: $title");

                      controller.addWalletFund(
                        accountNo: accountKindController.text,
                        amount: amountController.text,
                        accountType: title == "Wallet to MT5" ? "1" : "2",
                      );
                      // Proceed with your logic
                      print("Selected Wallet Value: $selectedValue");
                    }
                  },

                  child: Center(
                    child: const Text(
                      'Transfer',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      });
}

void _showDropdownMenu(
  BuildContext context,
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
