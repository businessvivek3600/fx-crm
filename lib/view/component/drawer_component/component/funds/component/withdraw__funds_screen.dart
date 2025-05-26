import 'package:flutter/material.dart';
import 'package:fx_crm/widgets/bg_container.dart';
import 'package:fx_crm/widgets/custom_text_form.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../../../controller/bank_controller.dart';
import '../../../../../../controller/ledger_wallet_controller.dart';
import '../../../../../../widgets/drop_down_text_field.dart';

class WithdrawFundsScreen extends StatefulWidget {
  const WithdrawFundsScreen({super.key});

  @override
  _WithdrawFundsScreenState createState() => _WithdrawFundsScreenState();
}

class _WithdrawFundsScreenState extends State<WithdrawFundsScreen> {
  final WalletLedgerController controller = Get.put(WalletLedgerController());
  final BankController bankController = Get.put(BankController());
  final accountKindController = TextEditingController();
  final TextEditingController amountController = TextEditingController(
    text: "500",
  );
  final TextEditingController _bitcoinAddressController =
      TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final double _processingFeePercent = 1.0;

  double get _netAmount {
    double amount = double.tryParse(amountController.text) ?? 0.0;
    return amount - (amount * _processingFeePercent / 100);
  }

  void _getEmailOtp() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("OTP sent to registered email.")),
    );
  }

  final accountKindKey = GlobalKey<FormFieldState<String>>();
  void _submit() {
    if (_bitcoinAddressController.text.isEmpty || _otpController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please complete all fields.")),
      );
    } else {
      print("Submitting withdrawal...");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getFundWays();
      bankController.getBankDetails();
    });
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          elevation: 0,

          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Withdraw Funds",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                  fontSize: 23,
                  color: Colors.white,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(),
                child: Text(
                  "\$${controller.totalBalance.toString()}",
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              /// Amount input
              CustomTextFormField(
                label: "Amount",
                hint: "Enter amount",
                controller: amountController,
              ),
              const SizedBox(height: 13),

              /// Payment type dropdown
              // const Padding(
              //   padding: EdgeInsets.all(9.0),
              //   child: Text(
              //     "Payment Type",
              //     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.white),
              //   ),
              // ),
              DropDownTextFormField(
                key: accountKindKey,
                label: 'Payment Type',
                hint: 'Choose Payment Type',
                colors: Colors.white70,
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

              const SizedBox(height: 16),

              /// Bitcoin address input
              CustomTextFormField(
                label: "Bitcoin Address",
                hint: "Enter your bitcoin wallet address",
                controller: _bitcoinAddressController,
              ),
              const SizedBox(height: 16),

              Card(
                margin: const EdgeInsets.only(bottom: 12),
                color: Colors.grey.shade900.withOpacity(0.8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() {
                        final option = controller.selectedWithdrawOption.value;

                        if (option == null) return SizedBox();

                        /// Show USDT/BTC/Bizzcoin address
                        if (option.name?.toLowerCase() == 'usdt') {
                          return _buildCryptoAddressTile('USDT Address', bankController.bankDetails.value?.usdtAddress);
                        } else if (option.name?.toLowerCase() == 'btc') {
                          return _buildCryptoAddressTile('BTC Address', bankController.bankDetails.value?.btcAddress);
                        } else if (option.name?.toLowerCase() == 'bizzcoin') {
                          return _buildCryptoAddressTile('Bizzcoin Address', bankController.bankDetails.value?.bizzcoinAddress);
                        }

                        /// Show bank details
                        final bank = bankController.bankDetails.value;
                        if (bank != null) {
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 12),
                            color: Colors.grey.shade900.withOpacity(0.8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  _buildBankRow('Bank Name', bank.bank),
                                  _buildBankRow('Account Number', bank.accountNumber),
                                  _buildBankRow('Account Holder Name', bank.accountHolderName),
                                  _buildBankRow('IFSC Code', bank.ifscCode),
                                  _buildBankRow('Address', bank.address),
                                ],
                              ),
                            ),
                          );
                        }

                        return SizedBox();
                      }),

                      Obx(() {
                        final option = controller.selectedWithdrawOption.value;
                        if (option == null) return SizedBox();
                        var totalAmount = double.tryParse(amountController.text) ?? 0.0;
                        var adminCharge = (option!.adminCharge ?? 0) /100 * totalAmount;
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Processing Fee ${option?.adminCharge ?? 0}%",
                              style: TextStyle(
                                color: white,
                              ),
                            ),
                            Text(
                              adminCharge.toString() ?? "0.0",
                              style: TextStyle(
                                color: white,
                                fontWeight: fontWeightBoldGlobal,
                              ),
                            ),
                          ],
                        );
                      }),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Net Amount",
                            style: TextStyle(
                              color: white,
                            ),
                          ),
                          Text(
                            "\$${controller.totalBalance.toString()}",
                            style: TextStyle(
                              color: white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 12),

              /// Get OTP button
              ElevatedButton(
                onPressed: _getEmailOtp,
                child: const Text("Get Email OTP"),
              ),
              const SizedBox(height: 20),

              /// OTP input
              CustomTextFormField(
                label: "Email OTP",
                hint: "Enter the OTP sent to your email",
                controller: _otpController,
              ),
              const SizedBox(height: 20),

              /// Submit button
              ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shadowColor: white,
                ),
                child: const Text("Submit"),
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildCryptoAddressTile(String label, String? address) {
    if (address == null || address.isEmpty) return SizedBox();
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 12),
      color: Colors.grey.shade900.withOpacity(0.8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: TextStyle(color: white)),
            SelectableText(address, style: TextStyle(color: white)),
          ],
        ),
      ),
    );
  }
  Widget _buildBankRow(String title, String? value) {
    if (value == null || value.isEmpty) return SizedBox();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(color: white)),
          Flexible(
            child: SelectableText(value, textAlign: TextAlign.right, style: TextStyle(color: white)),
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
    WalletLedgerController walletController,
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
