import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../controller/account_controller.dart';
import '../../../../../../main.dart';
import '../../../../../../widgets/bg_container.dart';
import '../../../../../../widgets/drop_down_text_field.dart';

class CreateAccountFormScreen extends StatefulWidget {
  const CreateAccountFormScreen({super.key});

  @override
  State<CreateAccountFormScreen> createState() =>
      _CreateAccountFormScreenState();
}

class _CreateAccountFormScreenState extends State<CreateAccountFormScreen> {
  late final AccountController accountController;
  final TextEditingController accountTypeController = TextEditingController();
  final TextEditingController leverageController = TextEditingController();
  final TextEditingController depositController = TextEditingController();
  final TextEditingController accountKindController = TextEditingController();
  final GlobalKey _accountKindKey = GlobalKey();

  final GlobalKey _accountTypeKey = GlobalKey();
  final GlobalKey _leverageKey = GlobalKey();
  final GlobalKey _depositKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    accountController = Get.put(AccountController(dioClient: dioClient));
    accountController.getAccountPlans();
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
      setState(() {
        controller.text = selected;
        if (controller == accountKindController) {
          print('Selected Account Kind: ${accountKindController.text}');
        }
      });
    }
  }

  String capitalizeWords(String value) {
    if (value.isEmpty) return value;
    return value
        .split(' ')
        .map(
          (word) =>
              word.isNotEmpty
                  ? word[0].toUpperCase() + word.substring(1).toLowerCase()
                  : '',
        )
        .join(' ');
  }
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BackgroundContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          title: Text(
            "CreateAccount",
            style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
          elevation: 0,
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Obx(() {
                    return DropDownTextFormField(
                      key: _accountKindKey,
                      label: 'Account Type',
                      hint: 'Select Account Type',
                      colors: Colors.white70,
                      controller: accountKindController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) =>
                      (value == null || value.isEmpty) ? 'Please select account type' : null,
                      onTap:
                          accountController.accountTypes.isNotEmpty
                              ? () => _showDropdownMenu(
                                _accountKindKey,
                                accountController.accountTypes,
                                accountKindController,
                              )
                              : null,
                    );
                  }),

                  const SizedBox(height: 16),

                  Obx(() {
                    final options =
                        accountController.accountPlans
                            .map((e) => capitalizeWords(e['name'].toString()))
                            .toList();

                    return DropDownTextFormField(
                      key: _accountTypeKey,
                      label: 'Account Plan',
                      hint: 'Select Account Plan',
                      colors: Colors.white70,
                      controller: accountTypeController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) =>
                      (value == null || value.isEmpty) ? 'Please select account plan' : null,
                      onTap:
                          options.isNotEmpty
                              ? () async {
                                final RenderBox renderBox =
                                    _accountTypeKey.currentContext!
                                            .findRenderObject()
                                        as RenderBox;
                                final Offset offset = renderBox.localToGlobal(
                                  Offset.zero,
                                );
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
                                            (option) => PopupMenuItem<String>(
                                              value: option,
                                              child: Text(option),
                                            ),
                                          )
                                          .toList(),
                                );

                                if (selected != null) {
                                  WidgetsBinding.instance.addPostFrameCallback((_) {
                                    setState(() {
                                      accountTypeController.text = selected;
                                      accountController.updateSelectedAccount(selected);
                                      leverageController.clear();
                                      depositController.clear();
                                    });
                                  });
                                }

                          }
                              : null,
                    );
                  }),

                  // const SizedBox(height: 16),
                  // DropDownTextFormField(
                  //   key: _currencyKey,
                  //   label: 'Currency',
                  //   colors: Colors.white70,
                  //   hint: 'Select Currency',
                  //   controller: currencyController,
                  //   readOnly: true,
                  //   onTap:
                  //       () => _showDropdownMenu(
                  //         _currencyKey,
                  //         currencyOptions,
                  //         currencyController,
                  //       ),
                  // ),
                  const SizedBox(height: 16),
                  Obx(() {
                    return DropDownTextFormField(
                      key: _leverageKey,
                      label: 'Leverage',
                      colors: Colors.white70,
                      hint: 'Select Leverage',
                      controller: leverageController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) =>
                      (value == null || value.isEmpty) ? 'Please select account leverage' : null,
                      onTap:
                          accountController.leverageOptions.isNotEmpty
                              ? () => _showDropdownMenu(
                                _leverageKey,
                                accountController.leverageOptions,
                                leverageController,
                              )
                              : null,
                    );
                  }),

                  const SizedBox(height: 16),
                  if (accountKindController.text == "Demo")
                    Obx(() {
                      return DropDownTextFormField(
                        key: _depositKey,
                        label: 'Initial Deposit',
                        colors: Colors.white70,
                        style: TextStyle(color: Colors.white70),
                        fieldStyle: TextStyle(color: Colors.white70),
                        hint: 'Select Deposit',
                        controller: depositController,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        validator: (value) =>
                        (value == null || value.isEmpty) ? 'Please select initial deposit' : null,
                        onTap: accountController.initialDeposit.isNotEmpty
                            ? () => _showDropdownMenu(
                          _depositKey,
                          accountController.initialDeposit,
                          depositController,
                        )
                            : null,
                      );
                    }),

                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        if (!_formKey.currentState!.validate()) return;
                        final accountPlan = accountTypeController.text;
                        final leverage = leverageController.text;
                        final initialFund = depositController.text;
                        final accountType = accountKindController.text;
                        accountController.createAccount(
                          accountPlanName: accountPlan,
                          leverageText: leverage,
                          initialFund: initialFund,
                          accountType: accountType,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'PROCEED',
                        style: TextStyle(color: Colors.white),
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
}
