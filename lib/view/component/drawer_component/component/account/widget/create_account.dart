import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../controller/account_controller.dart';
import '../../../../../../main.dart';
import '../../../../../../widgets/bg_container.dart';
import '../../../../../../widgets/drop_down_text_field.dart';


class CreateAccountFormScreen extends StatefulWidget {
  const CreateAccountFormScreen({super.key});

  @override
  State<CreateAccountFormScreen> createState() => _CreateAccountFormScreenState();
}

class _CreateAccountFormScreenState extends State<CreateAccountFormScreen> {
  late final AccountController accountController;
  final TextEditingController accountTypeController = TextEditingController();
  final TextEditingController currencyController = TextEditingController(text: 'USD');
  final TextEditingController leverageController = TextEditingController(text: '1:1000');
  final TextEditingController depositController = TextEditingController(text: '200');

  final GlobalKey _accountTypeKey = GlobalKey();
  final GlobalKey _currencyKey = GlobalKey();
  final GlobalKey _leverageKey = GlobalKey();
  final GlobalKey _depositKey = GlobalKey();

  final List<String> currencyOptions = ['AUD', 'USD', 'EUR', 'GBP', 'CHF', 'NZD', 'JPY', 'SGD', 'CAD', 'HKD'];

  final List<String> depositOptions = [
    '200', '1000', '3000', '5000', '10000', '25000', '50000',
    '100000', '500000', '1000000', '5000000'
  ];


  @override
  void initState() {
    super.initState();
    accountController = Get.put(AccountController(dioClient: dioClient));
    accountController.getAccountPlans();
  }

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
      items: options.map((option) => PopupMenuItem<String>(
        value: option,
        child: Text(option),
      )).toList(),
    );

    if (selected != null) {
      setState(() {
        controller.text = selected;
      });
    }
  }

  String capitalizeWords(String value) {
    if (value.isEmpty) return value;
    return value
        .split(' ')
        .map((word) => word.isNotEmpty
        ? word[0].toUpperCase() + word.substring(1).toLowerCase()
        : '')
        .join(' ');
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundContainer(
        child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        title:  Text(
        "CreateAccount",
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
      Obx(() {
        if (accountController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final options = accountController.accountTypes
            .map((e) => capitalizeWords(e['name'].toString()))
            .toList();

        return DropDownTextFormField(
          key: _accountTypeKey,
          label: 'Account Plan',
          hint: 'Select Account Plan',
          colors: Colors.white70,
          controller: accountTypeController,
          onTap: options.isNotEmpty
              ? () async {
            final RenderBox renderBox = _accountTypeKey.currentContext!.findRenderObject() as RenderBox;
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
              items: options.map((option) => PopupMenuItem<String>(
                value: option,
                child: Text(option),
              )).toList(),
            );

            if (selected != null) {
              setState(() {
                accountTypeController.text = selected;
                accountController.updateSelectedAccount(selected);
                leverageController.clear();
              });
            }
          }
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
                onTap: () => _showDropdownMenu(_currencyKey, currencyOptions, currencyController),
              ),
              const SizedBox(height: 16),
      Obx(() {
        return DropDownTextFormField(
          key: _leverageKey,
          label: 'Leverage',
          colors: Colors.white70,
          hint: 'Select Leverage',
          controller: leverageController,
          onTap: accountController.leverageOptions.isNotEmpty
              ? () => _showDropdownMenu(
            _leverageKey,
            accountController.leverageOptions,
            leverageController,
          )
              : null,
        );
      }),

      const SizedBox(height: 16),
              DropDownTextFormField(
                key: _depositKey,
                label: 'Initial Deposit',
                colors: Colors.white70,
                hint: 'Select Deposit',
                controller: depositController,
                readOnly: true,
                onTap: () => _showDropdownMenu(_depositKey, depositOptions, depositController),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // Handle account creation logic
                  },
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('PROCEED', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),),
    );
  }
}
