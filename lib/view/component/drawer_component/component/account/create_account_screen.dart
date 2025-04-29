import 'package:flutter/material.dart';

import '../../../../../controller/app_controller.dart';
import '../../../../../widgets/bg_container.dart';
import '../../../../../widgets/drop_down_text_field.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final TextEditingController accountTypeController = TextEditingController();
  final TextEditingController currencyController = TextEditingController(text: 'USD');
  final TextEditingController leverageController = TextEditingController(text: '1:1000');
  final TextEditingController depositController = TextEditingController(text: '200');

  final List<String> accountTypeOptions = ['Standard Account', 'Raw Spread'];
  final List<String> currencyOptions = ['AUD', 'USD', 'EUR', 'GBP', 'CHF', 'NZD', 'JPY', 'SGD', 'CAD', 'HKD'];
  final List<String> leverageOptions = [
    '1:1000', '1:500', '1:400', '1:300', '1:200', '1:100',
    '1:75', '1:50', '1:30', '1:25', '1:20', '1:10', '1:5', '1:2', '1:1'
  ];
  final List<String> depositOptions = [
    '200', '1000', '3000', '5000', '10000', '25000', '50000',
    '100000', '500000', '1000000', '5000000'
  ];

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

  void _selectAccountType() => _showDropdownMenu(_accountTypeKey, accountTypeOptions, accountTypeController);
  void _selectCurrency() => _showDropdownMenu(_currencyKey, currencyOptions, currencyController);
  void _selectLeverage() => _showDropdownMenu(_leverageKey, leverageOptions, leverageController);
  void _selectDeposit() => _showDropdownMenu(_depositKey, depositOptions, depositController);

  @override
  void initState() {
    super.initState();
    accountTypeController.text = 'Raw Spread'; // Default selected
  }

  @override
  Widget build(BuildContext context) {
    return  BackgroundContainer(
      child:  Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          title: const Text(
            "Create Account",
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
              DropDownTextFormField(
                key: _accountTypeKey,
                label: 'Account Type',
                hint: 'Select Account Type',
                controller: accountTypeController,
                readOnly: true,
                onTap: _selectAccountType,
              ),
              const SizedBox(height: 16),
              DropDownTextFormField(
                key: _currencyKey,
                label: 'Currency',
                hint: 'Select Currency',
                controller: currencyController,
                readOnly: true,
                onTap: _selectCurrency,
              ),
              const SizedBox(height: 16),
              DropDownTextFormField(
                key: _leverageKey,
                label: 'Leverage',
                hint: 'Select Leverage',
                controller: leverageController,
                readOnly: true,
                onTap: _selectLeverage,
              ),
              const SizedBox(height: 16),
              DropDownTextFormField(
                key: _depositKey,
                label: 'Initial Deposit',
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
          ),
        ),
      ),
    );
  }
}