import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fx_crm/view/component/drawer_component/component/funds/component/wallet_card_shimmer.dart';
import 'package:get/get.dart';

import '../../../../../../controller/wallet_controller.dart';
import '../../../../../../widgets/custom_text_form.dart';
import '../../../../../../widgets/drop_down_text_field.dart';

void showTransferWalletDialog(String title, BuildContext context) {
  final WalletController controller = Get.put(WalletController());
  String? selectedValue;
  final accountKindController = TextEditingController();
  final amountController = TextEditingController();
  final accountKindKey = GlobalKey<FormFieldState<String>>();
  final formKey = GlobalKey<FormState>();
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

        return Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                title ?? 'Select Wallet',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              DropDownTextFormField(
                key: accountKindKey,
                textStyle: TextStyle(color: Colors.black26),
                enabledBorder: Colors.black12,
                focusedBorder: Colors.black87,
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
                fillColor: Colors.black45,
                labelColor: Colors.black,
                textStyle: TextStyle(color: Colors.black26),
                enabledBorder: Colors.black12,
                focusedBorder: Colors.black87,
                controller: amountController,
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    child: const Text(
                      'Continue',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    ),
  ).show();
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
