import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fx_crm/widgets/glass_card.dart';
import 'package:get/get.dart';
import 'package:fx_crm/view/component/drawer_component/component/account/widget/change_account_password.dart';
import 'package:fx_crm/view/component/drawer_component/component/account/widget/create_account.dart';
import 'package:fx_crm/view/component/drawer_component/component/account/widget/set_balance_dialog.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../../controller/account_controller.dart';
import '../../../../../main.dart';
import '../../../../../models/account_model.dart';
import '../../../../../widgets/bg_container.dart';
import '../../../../../widgets/drop_down_text_field.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  final accountController = Get.put(AccountController(dioClient: dioClient));
  List<bool> _obscureMasterList = [];
  List<bool> _obscureInvestorList = [];
  final GlobalKey _leverageKey = GlobalKey();
  final TextEditingController accountKindController = TextEditingController();
  @override
  void initState() {
    super.initState();
    accountController.fetchAccounts().then((_) {
      // Initialize visibility state for each account
      final count = accountController.accountList.length;
      setState(() {
        _obscureMasterList = List.generate(count, (_) => true);
        _obscureInvestorList = List.generate(count, (_) => true);
      });
    });
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
          actions: [
            IconButton(
              icon: const Icon(Icons.add_circle_outline, color: Colors.white),
              tooltip: 'Open New Account',
              onPressed: () {
                Future.delayed(Duration(milliseconds: 100), () {
                  setState(() {
                    Get.to(() => const CreateAccountFormScreen());
                  });
                });
              },
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(children: [Expanded(child: _buildAccountDetails())]),
        ),
      ),
    );
  }

  Widget _buildAccountDetails() {
  return Obx(() {
    if (accountController.isLoading.value) {
      // 🔹 Show shimmer list while loading
      return ListView.builder(
        itemCount: 3,
        itemBuilder: (context, index) {
          return Shimmer.fromColors(
            baseColor: Colors.grey.shade800,
            highlightColor: Colors.grey.shade700,
            child: GlassCard(
              child: Container(
                height: 200,
              ),
            ),
          );
        },
      );
    }

      if (accountController.accountList.isEmpty) {
        return const Center(child: Text("No accounts found.",style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),));
      }

      // Filter demo accounts
      final userAccounts = accountController.accountList.toList();
      return ListView.builder(
        itemCount: userAccounts.length,
        itemBuilder: (context, index) {
          final account = userAccounts[index];
          return GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(account, context),
                const SizedBox(height: 12),
                _buildTypeLabel(account),
                const SizedBox(height: 8),
                _buildAccountTitle(account, index),
                const SizedBox(height: 12),
                _buildPasswordField(
                  label: 'Master Password',
                  password: account.masterPassword,
                  obscureList: _obscureMasterList,
                  index: index,
                  onToggle: () => setState(() {
                    _obscureMasterList[index] = !_obscureMasterList[index];
                  }),
                ),
                const SizedBox(height: 16),
                _buildPasswordField(
                  label: 'Investor Password',
                  password: account.investorPassword,
                  obscureList: _obscureInvestorList,
                  index: index,
                  onToggle: () => setState(() {
                    _obscureInvestorList[index] = !_obscureInvestorList[index];
                  }),
                ),
                const SizedBox(height: 12),
                _buildServerAndCurrency(account),
                // const SizedBox(height: 12),
                // _buildSetBalanceButton(context),
              ],
            ),
          );
        },
      );
    });
  }
  Widget _buildHeader(AccountModel account, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '${account.accountType} Account ${account.accountNo}',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white70),
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: Colors.white70),
          onSelected: (value) {
            if (value == 'leverage') {
              accountController.updateSelectedAccount(account.accountPlan.toString());
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
          itemBuilder: (_) => const [
            PopupMenuItem(value: 'master', child: Text('Master Password')),
            PopupMenuItem(value: 'investor', child: Text('Investor Password')),
            PopupMenuItem(value: 'leverage', child: Text('Change Leverage')),
          ],
        ),
      ],
    );
  }

  Widget _buildTypeLabel(AccountModel account) {
    return Row(
      children: [
        Text('${account.accountPlan}', style: const TextStyle(fontSize: 14, color: Colors.white70)),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(4)),
          child: Text(
            account.accountType == 'Demo' ? 'Demo' : 'Live',
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildAccountTitle(AccountModel account, int index) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onLongPress: () {
            Clipboard.setData(ClipboardData(text: account.accountNo ?? ''));
            Get.snackbar('Copied', 'Account Number copied to clipboard', snackPosition: SnackPosition.BOTTOM);
          },
          child: Text(
            'MT5 ${account.accountType} ${account.accountNo}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xff0d6efd)),
          ),
        ),
        Text(
          'Leverage: 1:${account.leverage ?? 'N/A'}',
          style: const TextStyle(fontSize: 14, color: Colors.white70),
        ),
      ],
    );
  }

  Widget _buildPasswordField({
    required String label,
    required String? password,
    required List<bool> obscureList,
    required int index,
    required VoidCallback onToggle,
  }) {
    final isObscured = index < obscureList.length ? obscureList[index] : true;

    return GestureDetector(
      onLongPress: () {
        Clipboard.setData(ClipboardData(text: password ?? ''));
        Get.snackbar('Copied', '$label copied to clipboard');
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 3),
            decoration: BoxDecoration(
              color: const Color.fromARGB(32, 153, 143, 143),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.white12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    isObscured ? '••••••••' : (password ?? ''),
                    style: const TextStyle(color: Colors.white70, fontSize: 16),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: Icon(isObscured ? Icons.visibility_off : Icons.visibility, color: Colors.white70),
                  onPressed: onToggle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServerAndCurrency(AccountModel account) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: GestureDetector(
            onLongPress: () {
              Clipboard.setData(ClipboardData(text: account.accountGroup ?? ''));
              Get.snackbar('Copied', 'Server name copied to clipboard');
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('SERVER', style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Chip(
                  label: Text(account.accountGroup ?? "", style: const TextStyle(fontSize: 12, color: Colors.black)),
                  backgroundColor: Colors.white24,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('Currency', style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w600)),
              SizedBox(height: 4),
              Chip(
                label: Text('USD', style: TextStyle(fontSize: 12, color: Colors.black)),
                backgroundColor: Colors.white24,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSetBalanceButton(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            backgroundColor: const Color(0xff2e2e2e),
            foregroundColor: Colors.white70,
          ),
          onPressed: () => showSetBalanceDialog(context),
          icon: const Icon(Icons.account_balance_wallet_outlined, color: Colors.white70),
          label: const Text('Set Balance'),
        ),
      ],
    );
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
                textStyle: const TextStyle(color: Colors.black26),
                colors: Colors.black,
                focusedBorder: Colors.black,
                enabledBorder: Colors.black26,
                fieldStyle: TextStyle(color: Colors.black),
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
