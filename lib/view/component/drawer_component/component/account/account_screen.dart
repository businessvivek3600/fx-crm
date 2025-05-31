import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fx_crm/utils/theme.dart';
import 'package:fx_crm/view/component/drawer_component/component/account/widget/change_account_password.dart';
import 'package:fx_crm/view/component/drawer_component/component/account/widget/create_account.dart';
import 'package:fx_crm/view/component/drawer_component/component/account/widget/set_balance_dialog.dart';
import '../../../../../controller/account_controller.dart';
import '../../../../../main.dart';
import '../../../../../widgets/bg_container.dart';
import '../../../../../widgets/drop_down_text_field.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final accountController = Get.put(AccountController(dioClient: dioClient));
  bool _obscurePassword = true;
  bool _obscureInvestorPassword = true;
  final GlobalKey _leverageKey = GlobalKey();
  final TextEditingController accountKindController = TextEditingController();
  @override
  void initState() {
    super.initState();
    accountController.fetchAccounts();
    accountController.getAccountPlans();
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          title: const Text(
            "My Account",
            style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
          elevation: 0,
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    Get.to(() => const CreateAccountFormScreen());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ThemeUtils.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Text(
                      "+ Open New Account",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(child: _buildAccountDetails()),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccountDetails() {
    return Obx(() {
      if (accountController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (accountController.accountList.isEmpty) {
        return const Center(child: Text("No accounts found."));
      }

      // Filter demo accounts
      final demoAccounts = accountController.accountList.toList();
      print(demoAccounts.length);
      return ListView.builder(
        itemCount: demoAccounts.length,
        itemBuilder: (context, index) {
          final account = demoAccounts[index];

          return Container(
  margin: const EdgeInsets.only(bottom: 20),
  padding: const EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: const Color(0xff151527),
    borderRadius: BorderRadius.circular(25),
    border: Border.all(
      color: Colors.white.withOpacity(0.2), // subtle white border
      width: 1.5, // border thickness
    ),
    // boxShadow removed
  ),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      /// Header
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${account.accountType} Account ${account.accountNo}',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white70,
            ),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: Colors.white70),
            onSelected: (value) {
              if (value == 'leverage') {
                accountController.updateSelectedAccount(
                  account.accountPlan.toString(),
                );
                Future.delayed(const Duration(milliseconds: 100), () {
                  _showLeverageDialog(account.accountNo ?? "");
                });
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChangeAccountPassword(
                      isInvester: value != 'master',
                      accountNo: account.accountNo ?? "",
                    ),
                  ),
                );
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'master',
                child: Text('Master Password'),
              ),
              const PopupMenuItem(
                value: 'investor',
                child: Text('Investor Password'),
              ),
              const PopupMenuItem(
                value: 'leverage',
                child: Text('Change Leverage'),
              ),
            ],
          ),
        ],
      ),

      const SizedBox(height: 12),

      /// Type Label
      Row(
        children: [
          Text(
            '${account.accountPlan}',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              'Demo',
              style: TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ),
        ],
      ),

      const SizedBox(height: 8),

      /// Account Title
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'MT5 ${account.accountType} ${account.accountNo}',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white70,
            ),
          ),
          Text(
            'Leverage: 1:${account.leverage ?? 'N/A'}',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white70,
            ),
          ),
        ],
      ),

      const SizedBox(height: 12),

      /// Master Password
      TextFormField(
        initialValue: account.masterPassword,
        obscureText: _obscurePassword,
        readOnly: true,
        style: const TextStyle(color: Colors.white70),
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color.fromARGB(32, 153, 143, 143),
          labelText: 'Master Password',
          labelStyle: const TextStyle(color: Colors.white70),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white70),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(12),
          ),
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility_off : Icons.visibility,
              color: Colors.white70,
            ),
            onPressed: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
        ),
      ),

      const SizedBox(height: 16),

      /// Investor Password
      TextFormField(
        initialValue: account.investorPassword,
        obscureText: _obscureInvestorPassword,
        readOnly: true,
        style: const TextStyle(color: Colors.white70),
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color.fromARGB(32, 153, 143, 143),
          labelText: 'Investor Password',
          labelStyle: const TextStyle(color: Colors.white70),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white70),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(12),
          ),
          suffixIcon: IconButton(
            icon: Icon(
              _obscureInvestorPassword ? Icons.visibility_off : Icons.visibility,
              color: Colors.white70,
            ),
            onPressed: () {
              setState(() {
                _obscureInvestorPassword = !_obscureInvestorPassword;
              });
            },
          ),
        ),
      ),

      const SizedBox(height: 12),

      /// Server & Currency
      Row(
        children: [
          Expanded(
            child: Chip(
              label: Text(
                'SERVER ${account.accountGroup ?? ""}',
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                ),
              ),
              backgroundColor: Colors.white24,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 50),
              child: Chip(
                label: const Text(
                  'Currency USD',
                  style: TextStyle(fontSize: 12, color: Colors.black),
                ),
                backgroundColor: Colors.white24,
              ),
            ),
          ),
        ],
      ),

      const SizedBox(height: 12),

      /// Set Balance Button
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              backgroundColor: const Color(0xff2e2e2e),
              foregroundColor: Colors.white70,
            ),
            onPressed: () => showSetBalanceDialog(context),
            icon: const Icon(Icons.account_balance_wallet_outlined),
            label: const Text('Set Balance'),
          ),
        ],
      ),
    ],
  ),
);

        },
      );
    });
  }

  void _showLeverageDialog(String accountNo) {
    final leverageController = TextEditingController();

    AwesomeDialog(
      context: context,
      dialogType: DialogType.noHeader,
      animType: AnimType.scale,
      width: 400,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Change Leverage Account #$accountNo',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Obx(() {
              return DropDownTextFormField(
                key: _leverageKey,
                label: 'Leverage',
                colors: Colors.white70,
                hint: 'Select Leverage',
                controller: leverageController,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                validator:
                    (value) =>
                        (value == null || value.isEmpty)
                            ? 'Please select account leverage'
                            : null,
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

            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                final newLeverage = leverageController.text.trim();
                if (newLeverage.isNotEmpty) {
                  await accountController.changeLeverage(
                    accountNo: accountNo,
                    leverage: newLeverage,
                  );
                  Navigator.of(context).pop();
                  Get.snackbar(
                    'Success',
                    'Leverage changed to $newLeverage',
                    snackPosition: SnackPosition.BOTTOM,
                  );
                } else {
                  Get.snackbar(
                    'Error',
                    'Leverage cannot be empty',
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
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
                'Submit',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
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
}
