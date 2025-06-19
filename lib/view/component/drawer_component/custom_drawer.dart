import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fx_crm/routes/route_name.dart';
import 'package:fx_crm/view/component/drawer_component/component/funds/deposit_fund.dart';
import 'package:fx_crm/view/component/drawer_component/component/funds/deposite_withdraw_history.dart';
import 'package:fx_crm/view/component/drawer_component/component/funds/wallet_ledger.dart';
import 'package:fx_crm/view/component/drawer_component/component/funds/withdraw_fund.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../controller/app_controller.dart';
import '../../../controller/auth_controller.dart';
import '../../../routes/route_path.dart';
import '../../../utils/drawer_back_button.dart';
import '../../../widgets/bg_container.dart';
import 'component/Delete/delete_account.dart';

class CustomDrawer extends StatefulWidget {
  const CustomDrawer({super.key});

  @override
  State<CustomDrawer> createState() => _CustomDrawerState();
}

class _CustomDrawerState extends State<CustomDrawer> {
  int? _openTileIndex;

  @override
  Widget build(BuildContext context) {
    final logo = AppController.to.settings;

    return Row(
      children: [
        Expanded(
          child: BackgroundContainer(
            useAlternateBackground: true,
            child: Drawer(
              elevation: 5,
              backgroundColor: Colors.transparent,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(25),
                  bottomRight: Radius.circular(25),
                ),
              ),
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  SizedBox(
                    height: 130,
                    child: DrawerHeader(
                      decoration: const BoxDecoration(color: Colors.transparent),
                      margin: EdgeInsets.zero,
                      padding: EdgeInsets.zero,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Image.network(
                          logo.first.logo ??
                              'https://png.pngtree.com/png-vector/20220423/ourmid/pngtree-trade-market-candle-line-png-png-image_4553954.png',
                          fit: BoxFit.contain,
                          width: double.infinity,
                          height: double.infinity,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.error, color: Colors.white),
                        ),
                      ),
                    ),
                  ),

                  // ExpansionTiles
                  _buildCustomExpansionTile(
                    index: 0,
                    title: 'My Account',
                    icon: Icons.account_circle_outlined,
                    submenus: [
                      {
                        'title': 'Accounts',
                        'icon': Icons.school_outlined,
                        'onTap': () => context.push(Routes.accounts),
                      },
                    ],
                  ),
                  _buildCustomExpansionTile(
                    index: 1,
                    title: 'Funds',
                    icon: Icons.account_balance_wallet_outlined,
                    submenus: [
                      {
                        'title': 'Wallet Ledger',
                        'icon': Icons.account_balance_wallet_outlined,
                        'onTap': () => Navigator.push(context,
                            MaterialPageRoute(builder: (_) => WalletLedger())),
                      },
                      {
                        'title': 'Deposit Fund',
                        'icon': Icons.attach_money_outlined,
                        'onTap': () => Navigator.push(context,
                            MaterialPageRoute(builder: (_) => DepositFundScreen())),
                      },
                      {
                        'title': 'Withdraw Fund',
                        'icon': Icons.money_off_outlined,
                        'onTap': () => Navigator.push(context,
                            MaterialPageRoute(builder: (_) => WithdrawFundScreen())),
                      },
                      {
                        'title': 'Deposit/Withdraw History',
                        'icon': Icons.history,
                        'onTap': () => Navigator.push(context,
                            MaterialPageRoute(builder: (_) => DepositWithdrawHistoryScreen())),
                      },
                    ],
                  ),
                  _buildCustomExpansionTile(
                    index: 2,
                    title: 'Profile',
                    icon: Icons.manage_accounts_outlined,
                    submenus: [
                      {
                        'title': 'Edit Profile',
                        'icon': Icons.edit_outlined,
                        'onTap': () => context.push(Paths.editProfile),
                      },
                      {
                        'title': 'Bank/Wallet',
                        'icon': Icons.credit_card_outlined,
                        'onTap': () => context.push(Paths.bankWallet),
                      },
                      {
                        'title': 'KYC',
                        'icon': Icons.badge_outlined,
                        'onTap': () => context.push(Routes.kyc),
                      },
                      {
                        'title': 'Change Password',
                        'icon': Icons.lock_outline,
                        'onTap': () => context.push(Paths.changePassword),
                      },
                    ],
                  ),
                  _buildCustomExpansionTile(
                    index: 3,
                    title: 'Promotions',
                    icon: Icons.local_offer_outlined,
                    submenus: [
                      {
                        'title': 'Terms and Condition',
                        'icon': Icons.article,
                        'onTap': () => context.push(Paths.termsAndConditions),
                      },
                    ],
                  ),

                  // Single ListTiles
                  _buildListTile(
                    icon: Icons.support_agent_outlined,
                    title: 'Support',
                    onTap: () => context.push(Paths.support),
                  ),
                  _buildListTile(
                    icon: Icons.calendar_month_outlined,
                    title: 'Economic Calendar',
                    onTap: () => context.push(Paths.economicCalendar),
                  ),
                  _buildListTile(
                    icon: Icons.download_outlined,
                    title: 'Downloads',
                    onTap: () => context.push(Paths.downloads),
                  ),
                  _buildListTile(
                    icon: Icons.logout,
                    title: 'Logout',
                    onTap: () {
                      Get.closeAllSnackbars();
                      AwesomeDialog(
                        context: Get.context!,
                        dialogType: DialogType.warning,
                        animType: AnimType.rightSlide,
                        title: 'Logout',
                        customHeader: const Icon(
                          Icons.question_mark_outlined,
                          size: 50,
                          color: Colors.orange,
                        ),
                        headerAnimationLoop: true,
                        desc: 'Are you sure you want to logout?',
                        btnCancelOnPress: () {},
                        btnOkText: 'Logout',
                        btnOkOnPress: () {
                          Future.delayed(const Duration(milliseconds: 200), () {
                            Get.find<AuthController>().logout();
                          });
                        },
                      ).show();
                    },
                  ),
                  _buildListTile(
                    icon: Icons.delete_outline_outlined,
                    title: 'Delete Account',
                    onTap: () => Get.to(() => const DeleteAccountScreen()),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),

        // Drawer Close Button
        Column(
          children: [
            Expanded(
              child: Container(
                color: Colors.black.withOpacity(0.8),
                child: Row(
                  children: [
                    const SizedBox(width: 15),
                    AnimatedCircleButton(onTap: () => Navigator.pop(context)),
                    const SizedBox(width: 15),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Updated to auto-close previous and open tapped one
  Widget _buildCustomExpansionTile({
    required int index,
    required String title,
    required IconData icon,
    required List<Map<String, dynamic>> submenus,
  }) {
    final isOpen = _openTileIndex == index;

    return Column(
      children: [
        ListTile(
          leading: Icon(icon, color: Colors.white),
          title: Text(title, style: const TextStyle(color: Colors.white)),
          trailing: Icon(
            isOpen ? Icons.expand_less : Icons.expand_more,
            color: Colors.white,
          ),
          onTap: () {
            setState(() {
              // Toggle current open state
              _openTileIndex = isOpen ? null : index;
            });
          },
        ),
        if (isOpen)
          ...submenus.map((submenu) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                dense: true,
                leading: Icon(submenu['icon'], size: 20, color: Colors.white),
                title: Text(
                  submenu['title'],
                  style: const TextStyle(fontSize: 14, color: Colors.white),
                ),
                onTap: submenu['onTap'],
              ),
            );
          }).toList(),
      ],
    );
  }

  /// Reusable ListTile for non-expandables
  Widget _buildListTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      onTap: onTap,
    );
  }
}
