import 'package:flutter/material.dart';
import 'package:fx_crm/utils/theme.dart';
import 'package:get/get.dart';

import '../../../../../controller/account_controller.dart';
import '../../../../../controller/app_controller.dart';
import '../../../../../main.dart';
import '../../../../../widgets/bg_container.dart';
import '../../../../../widgets/drop_down_text_field.dart';
import 'widget/set_balance_dialog.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  late final AccountController  accountController;
  final TextEditingController accountTypeController = TextEditingController();
  final TextEditingController currencyController = TextEditingController(text: 'USD');
  final TextEditingController leverageController = TextEditingController(text: '1:1000');
  final TextEditingController depositController = TextEditingController(text: '200');

  final List<String> currencyOptions = ['AUD', 'USD', 'EUR', 'GBP', 'CHF', 'NZD', 'JPY', 'SGD', 'CAD', 'HKD'];
  final List<String> leverageOptions = [
    '1:1000', '1:500', '1:400', '1:300', '1:200', '1:100',
    '1:75', '1:50', '1:30', '1:25', '1:20', '1:10', '1:5', '1:2', '1:1'
  ];
  final List<String> depositOptions = [
    '200', '1000', '3000', '5000', '10000', '25000', '50000',
    '100000', '500000', '1000000', '5000000'
  ];
  bool showCreateAccountForm = false;
  String capitalizeWords(String value) {
    if (value.isEmpty) return value;
    return value
        .split(' ')
        .map((word) => word.isNotEmpty
        ? word[0].toUpperCase() + word.substring(1).toLowerCase()
        : '')
        .join(' ');
  }

  final GlobalKey _accountTypeKey = GlobalKey();
  final GlobalKey _currencyKey = GlobalKey();
  final GlobalKey _leverageKey = GlobalKey();
  final GlobalKey _depositKey = GlobalKey();

  void _showDropdownMenu(GlobalKey key, List<String> options, TextEditingController controller) async {
    final RenderBox renderBox = key.currentContext!.findRenderObject() as RenderBox;
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
      items: options.map((option) {
        return PopupMenuItem<String>(
          value: option,
          child: Text(option),
        );
      }).toList(),
    );

    if (selected != null) {
      setState(() {
        controller.text = selected;
      });
    }
  }

  void _selectCurrency() => _showDropdownMenu(_currencyKey, currencyOptions, currencyController);
  void _selectLeverage() => _showDropdownMenu(_leverageKey, leverageOptions, leverageController);
  void _selectDeposit() => _showDropdownMenu(_depositKey, depositOptions, depositController);

  @override
  void initState() {
    super.initState();
    accountController = Get.put(
      AccountController(dioClient: dioClient),
    ); // Provide dioClient
    accountController.getAccountPlans();
  }
  bool _obscurePassword = true;
  @override
  Widget build(BuildContext context) {
    return BackgroundContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          title:  Text(
            showCreateAccountForm ?   "Create Account" : "My Account",
            style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
          elevation: 0,
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Header with button
                 Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    showCreateAccountForm ? SizedBox() : ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          showCreateAccountForm = !showCreateAccountForm; // Toggle
                                        });
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: showCreateAccountForm ? Colors.redAccent.shade700 : ThemeUtils.primaryColor,
                                        padding: const EdgeInsets.symmetric(vertical: 14),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 15),
                                        child: Text(
                                          showCreateAccountForm ? "Cancel" : "+ Open New Account", // Toggle text
                                          style: const TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                const SizedBox(height: 16),

                /// Account Details Section
                if (!showCreateAccountForm) ...[
                  _buildAccountDetails(),
                ],

                /// Create Account Form Section
                if (showCreateAccountForm) ...[
                  Obx(() {
                    if (accountController.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    final options = accountController.accountTypes
                        .map((e) => capitalizeWords(e['name'].toString()))
                        .toList();

                    return DropDownTextFormField(
                      key: _accountTypeKey,
                      label: 'Account Type',
                      hint: 'Select Account Type',
                      colors: Colors.white70,
                      controller: accountTypeController,
                      // readOnly: true,
                      onTap: options.isNotEmpty
                          ? () => _showDropdownMenu(_accountTypeKey, options, accountTypeController)
                          : null,
                    );
                  }),



                  const SizedBox(height: 16),
                  DropDownTextFormField(
                    key: _currencyKey,
                    label: 'Currency',
                    colors: Colors.white70,
                    hint: 'Select Currency',
                    controller: currencyController,
                    readOnly: true,
                    onTap: _selectCurrency,
                  ),
                  const SizedBox(height: 16),
                  DropDownTextFormField(
                    key: _leverageKey,
                    label: 'Leverage',
                    colors: Colors.white70,
                    hint: 'Select Leverage',
                    controller: leverageController,
                    // readOnly: true,
                    onTap: _selectLeverage,
                  ),
                  const SizedBox(height: 16),
                  DropDownTextFormField(
                    key: _depositKey,
                    label: 'Initial Deposit',
                    colors: Colors.white70,
                    hint: 'Select Deposit',
                    controller: depositController,
                    readOnly: true,
                    onTap: _selectDeposit,
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle proceed logic
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('PROCEED', style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAccountDetails() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('My Demo Accounts', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Row(
            children: [
              Text('Raw Spread', style: TextStyle(fontSize: 14, color: Colors.black54)),
              const SizedBox(width: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text('Demo', style: TextStyle(color: Colors.green.shade800, fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text('MT5 Demo 52297992', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  obscureText: _obscurePassword,
                  initialValue: '1234567',
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Chip(
                  label: Text('SERVER  ICMarketsSC-Demo', style: TextStyle(fontSize: 12)),
                  backgroundColor: Colors.grey.shade200,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Chip(
                  label: Text('Currency  USD', style: TextStyle(fontSize: 12)),
                  backgroundColor: Colors.grey.shade200,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              OutlinedButton.icon(
                onPressed: () => showSetBalanceDialog(context),
                icon: Icon(Icons.account_balance_wallet_outlined),
                label: Text('Set Balance'),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () {
                  // Show options
                },
                icon: Icon(Icons.more_vert),
              ),
            ],
          ),
        ],
      ),
    );
  }

}