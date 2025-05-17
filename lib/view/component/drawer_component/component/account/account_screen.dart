import 'package:flutter/material.dart';
import 'package:fx_crm/utils/theme.dart';
import 'package:fx_crm/view/component/drawer_component/component/account/widget/change_account_password.dart';
import 'package:fx_crm/view/component/drawer_component/component/account/widget/create_account.dart';
import 'package:get/get.dart';
import '../../../../../widgets/bg_container.dart';
import 'widget/set_balance_dialog.dart';

class CreateAccountScreen extends StatefulWidget {
  const CreateAccountScreen({super.key});

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  bool _obscurePassword = true;
  @override
  Widget build(BuildContext context) {
    return BackgroundContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          title: Text(
            "My Account",
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
                    ElevatedButton(
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
                  ],
                ),
                const SizedBox(height: 16),

                /// Account Details Section
                _buildAccountDetails(),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'My Demo Accounts',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              PopupMenuButton<String>(
                icon: Icon(Icons.more_vert, color: Colors.black),
                onSelected: (value) {
                  if (value == 'master') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ChangeAccountPassword(),
                      ),
                    );
                    print("Master Password selected");
                  } else if (value == 'investor') {
                    // TODO: Handle Investor Password action
                    print("Investor Password selected");
                  }
                },
                itemBuilder:
                    (context) => [
                      PopupMenuItem(
                        value: 'master',
                        child: Text('Master Password'),
                      ),
                      PopupMenuItem(
                        value: 'investor',
                        child: Text('Investor Password'),
                      ),
                    ],
              ),
            ],
          ),

          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                'Raw Spread',
                style: TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(width: 8),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Demo',
                  style: TextStyle(color: Colors.green.shade800, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'MT5 Demo 52297992',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Column(
            children: [
              // Master Password Field
              TextFormField(
                obscureText: _obscurePassword,
                initialValue: '1234567',
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Master Password',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
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

              // Investor Password Field
              TextFormField(
                // obscureText: _obscureInvestorPassword,
                initialValue: 'investor123',
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Investor Password',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(
                      // _obscureInvestorPassword
                      //     ? Icons.visibility_off
                      Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        // _obscureInvestorPassword = !_obscureInvestorPassword;
                      });
                    },
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
                  label: Text(
                    'SERVER  ICMarketsSC-Demo',
                    style: TextStyle(fontSize: 12),
                  ),
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
              const SizedBox(width: 0),
            ],
          ),
        ],
      ),
    );
  }
}
