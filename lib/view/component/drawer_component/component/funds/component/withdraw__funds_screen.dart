import 'package:flutter/material.dart';
import 'package:fx_crm/controller/auth_controller.dart';
import 'package:fx_crm/widgets/bg_container.dart';
import 'package:fx_crm/widgets/custom_text_form.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../../../../controller/app_controller.dart';
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
  final AuthController authController = Get.put(AuthController());
  final accountKindController = TextEditingController();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController _bitcoinAddressController =
      TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final double _processingFeePercent = 1.0;

  final accountKindKey = GlobalKey<FormFieldState<String>>();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getFundWays();
      bankController.getBankDetails();
    });
    amountController.text = controller.totalBalance.toString();
  }

  void _getEmailOtp() async {
    final amount = amountController.text.trim();
    final paymentType = accountKindController.text.trim();

    if (amount.isEmpty || paymentType.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please enter amount and select a payment type."),
        ),
      );
      return;
    }

    // Optional: Validate numeric amount
    final parsedAmount = double.tryParse(amount);
    if (parsedAmount == null || parsedAmount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please enter a valid amount.")),
      );
      return;
    }
    final email = AppController.to.customer.value?.customerEmail;
    print("email: $email");
    await authController.getOtp(email!);

  }

  void _submit() async {
    if (_formKey.currentState?.validate() != true) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in all required fields.")),
      );
      return;
    }

    final otp = _otpController.text.trim();
    final amount = amountController.text.trim();
    final paymentType = accountKindController.text.trim();

    if (otp.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("OTP is required.")),
      );
      return;
    }

    // Call the withdraw request and wait for response
    bool success = await controller.withdrawRequest(
      emailOtp: otp,
      amount: amount,
      paymentType: paymentType,
    );

    // If success is true, clear fields and navigate back
    if (success) {
      amountController.clear();
      accountKindController.clear();
      _otpController.clear();
      _bitcoinAddressController.clear();

      // Optional: Show a success message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Withdrawal request submitted successfully.")),
      );

      // Navigate back
      Navigator.of(context).pop(); // Or Get.back();
    } else {
      // Handle error case (optional)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to submit withdrawal request.")),
      );
    }
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
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                children: [
                  /// Amount input
                  CustomTextFormField(
                    label: "Amount",
                    hint: "Enter amount",
                    controller: amountController,
                    validator: (value) {
                      final entered = double.tryParse(value ?? '') ?? 0;
                      final max =
                          double.tryParse(controller.totalBalance.value) ?? 0;

                      if (value == null || value.isEmpty) {
                        return 'Amount is required';
                      }
                      if (entered <= 0) {
                        return 'Amount must be greater than 0';
                      }
                      if (entered > max) {
                        return 'You cannot enter more than your0 balance (\$$max)';
                      }
                      return null;
                    },
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

                  // const SizedBox(height: 16),
                  //
                  // /// Bitcoin address input
                  // CustomTextFormField(
                  //   label: "Bitcoin Address",
                  //   hint: "Enter your bitcoin wallet address",
                  //   controller: _bitcoinAddressController,
                  // ),
                  const SizedBox(height: 16),
                  Obx(() {
                    final option = controller.selectedWithdrawOption.value;

                    if (option == null) return SizedBox();
                    print("Selected withdraw option: ${option.name}");
                    final name = option.name?.toLowerCase() ?? '';

                    /// Show USDT/BTC/Bizzcoin address
                    if (name.contains('usdt')) {
                      return _buildCryptoAddressTile(
                        'USDT TRC20',
                        bankController.bankDetails.value?.usdtAddress,
                      );
                    } else if (name.contains('bitcoin')) {
                      return _buildCryptoAddressTile(
                        'BTC Address',
                        bankController.bankDetails.value?.btcAddress,
                      );
                    } else if (name.contains('bizzcoin')) {
                      return _buildCryptoAddressTile(
                        'Bizzcoin Address',
                        bankController.bankDetails.value?.bizzcoinAddress,
                      );
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
                              _buildBankRow(
                                'Account Number',
                                bank.accountNumber,
                              ),
                              _buildBankRow(
                                'Account Holder Name',
                                bank.accountHolderName,
                              ),
                              _buildBankRow('IFSC Code', bank.ifscCode),
                              _buildBankRow('Address', bank.address),
                            ],
                          ),
                        ),
                      );
                    }

                    return SizedBox();
                  }),
                  Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    color: Colors.grey.shade900.withOpacity(0.8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Obx(() {
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
                  SizedBox(
                    height: 45,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _submit,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade900,
                        shadowColor: white,
                      ),
                      child: const Text(
                        "Submit",
                        style: TextStyle(fontSize: 18, letterSpacing: 1.2),
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
            child: SelectableText(
              value,
              textAlign: TextAlign.right,
              style: TextStyle(color: white),
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
    WalletLedgerController walletController,
  ) async {
    final RenderBox renderBox =
        key.currentContext!.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;
    print(
      "Available options: ${walletController.withDrawFundList.map((e) => e.name)}",
    );

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
