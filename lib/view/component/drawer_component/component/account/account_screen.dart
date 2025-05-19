import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fx_crm/utils/theme.dart';
import 'package:fx_crm/view/component/drawer_component/component/account/widget/change_account_password.dart';
import 'package:fx_crm/view/component/drawer_component/component/account/widget/create_account.dart';
import 'package:fx_crm/view/component/drawer_component/component/account/widget/set_balance_dialog.dart';
import '../../../../../controller/account_controller.dart';
import '../../../../../database/dio/dio/dio_client.dart';
import '../../../../../main.dart';
import '../../../../../widgets/bg_container.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final accountController = Get.put(AccountController(dioClient: dioClient));
  bool _obscurePassword = true;
  bool _obscureInvestorPassword = true;

  @override
  void initState() {
    super.initState();
    accountController.fetchAccounts();
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
      final demoAccounts = accountController.accountList
          .toList();
      print(demoAccounts.length);
      return ListView.builder(
        itemCount: demoAccounts.length,
        itemBuilder: (context, index) {
          final account = demoAccounts[index];

          return Container(
            margin: const EdgeInsets.only(bottom: 20),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Demo Account ${account.accountNo}',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert, color: Colors.black),
                      onSelected: (value) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => ChangeAccountPassword(
                              isInvester: value != 'master',
                              accountNo: account.accountNo ?? "",
                            ),
                          ),
                        );
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(value: 'master', child: Text('Master Password')),
                        const PopupMenuItem(value: 'investor', child: Text('Investor Password')),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                /// Type Label
                Row(
                  children: [
                    const Text('Raw Spread', style: TextStyle(fontSize: 14, color: Colors.black54)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.green.shade100,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        account.accountType ?? 'dsddssd',
                        style: TextStyle(color: Colors.green.shade800, fontSize: 12),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                /// Account Title
                Text(
                  'MT5 Demo ${account.accountNo}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 12),

                /// Master Password
                TextFormField(
                  initialValue: account.masterPassword,
                  obscureText: _obscurePassword,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: 'Master Password',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword ? Icons.visibility_off : Icons.visibility,
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
                  decoration: InputDecoration(
                    labelText: 'Investor Password',
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureInvestorPassword ? Icons.visibility_off : Icons.visibility,
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
                        label: Text('SERVER ${account.accountGroup}',
                            style: const TextStyle(fontSize: 12)),
                        backgroundColor: Colors.grey.shade200,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Chip(
                        label: const Text('Currency USD', style: TextStyle(fontSize: 12)),
                        backgroundColor: Colors.grey.shade200,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                /// Set Balance
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    OutlinedButton.icon(
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
}
