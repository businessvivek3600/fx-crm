import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:fx_crm/routes/route_name.dart';
import 'package:fx_crm/routes/route_settings.dart';
import 'package:fx_crm/view/component/drawer_component/component/account/account_screen.dart';
import 'package:fx_crm/view/component/drawer_component/component/account/wallet_account.dart'
    show WalletAccountScreen;
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
import 'component/account/wallet_account.dart';
import 'component/profile/kyc_verification.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final logo = AppController.to.settings;
    final screenWidth = MediaQuery.of(context).size.width;
    return Row(
      children: [
        Expanded(
          child: BackgroundContainer(
            useAlternateBackground: true,
            child: Drawer(
              elevation: 5,

              backgroundColor: Colors.transparent,
              shape: RoundedRectangleBorder(
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
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                      ),
                      margin: EdgeInsets.zero,
                      padding: EdgeInsets.zero,
                      child: Align(
                        alignment: Alignment.centerLeft, // Start from left
                        child: Image.network(
                          logo.first.logo ??
                              'https://png.pngtree.com/png-vector/20220423/ourmid/pngtree-trade-market-candle-line-png-png-image_4553954.png',
                          fit: BoxFit.contain,
                          width: double.infinity,
                          height: double.infinity,
                          errorBuilder:
                              (context, error, stackTrace) =>
                                  const Icon(Icons.error, color: Colors.white),
                        ),
                      ),
                    ),
                  ),

                  // Profile with submenus
                  _buildExpansionTile(
                    title: 'My Account',
                    icon: Icons.account_circle_outlined,
                    submenus: [
                      {
                        'title': 'Accounts',
                        'icon': Icons.school_outlined,
                        'onTap': () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => AccountScreen(),
                          //   ),
                          // );
                          context.push(Routes.accounts);
                        },
                      },

                      // {
                      //   'title': 'Activate Account',
                      //   'icon': Icons.account_box_outlined,
                      //   'onTap': () {
                      //     context.push(Paths.activateAccount);
                      //     // router.push(Routes.CreateAccountScreen);
                      //   },
                      // },
                      {
                        'title': 'Wallet Account',
                        'icon': Icons.account_balance_wallet_outlined,
                        'onTap': () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => WalletAccountScreen(),
                          //   ),
                          // );
                          context.push(Routes.walletAccount);
                        },
                      },
                      {
                        'title': 'Transaction History',
                        'icon': Icons.account_balance_wallet_outlined,
                        'onTap': () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => TransactionHistoryScreen(),
                          //   ),
                          // );
                          context.push(Paths.transactionHistory);
                        },
                      },
                    ],
                  ),
                  _buildExpansionTile(
                    title: 'Profile',
                    icon: Icons.manage_accounts_outlined,
                    submenus: [
                      {
                        'title': 'Edit Profile',
                        'icon': Icons.edit_outlined,
                        'onTap': () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => EditProfileScreen(),
                          //   ),
                          // );
                          context.push(Paths.editProfile);
                        },
                      },
                      {
                        'title': 'Bank/Wallet',
                        'icon': Icons.credit_card_outlined,
                        'onTap': () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(builder: (context) => WalletScreen()),
                          // );
                          context.push(Paths.bankWallet); // Works now
                        },
                      },
                      {
                        'title': 'KYC',
                        'icon': Icons.badge_outlined,
                        'onTap': () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => KycUploadScreen(),
                          //   ),
                          // );
                          context.push(Routes.kyc);
                        },
                      },
                      {
                        'title': 'Change Password',
                        'icon': Icons.lock_outline,
                        'onTap': () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => ChangePasswordScreen(),
                          //   ),
                          // );
                          context.push(Paths.changePassword);
                        },
                      },
                    ],
                  ),

                  // Promotion
                  _buildExpansionTile(
                    title: 'Promotions',
                    icon: Icons.local_offer_outlined,
                    submenus: [
                      {
                        'title': 'Monthly Rewards',
                        'icon': Icons.emoji_events,
                        'onTap': () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => MonthlyRewardsScreen(),
                          //   ),
                          // );
                          router.push(Routes.monthlyRewards);
                        },
                      },
                      {
                        'title': 'Terms and Condition',
                        'icon': Icons.article,
                        'onTap': () {
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) => TermsAndConditionsScreen(),
                          //   ),
                          // );
                          context.push(Paths.termsAndConditions);
                        },
                      },
                    ],
                  ),

                  // IB Menu
                  _buildExpansionTile(
                    title: 'IB Menu',
                    icon: Icons.menu_open_outlined,
                    submenus: [
                      {'title': 'Become IB', 'icon': Icons.group_add_outlined},
                    ],
                  ),

                  // Funds
                  _buildExpansionTile(
                    title: 'Funds',
                    icon: Icons.account_balance_wallet_outlined,
                    submenus: [
                      {
                        'title': 'Wallet Ledger',
                        'icon': Icons.account_balance_wallet_outlined,
                        'onTap': () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WalletLedger(),
                            ),
                          );
                          // context.push(Paths.wallet_ledger);
                        },
                      },
                      {
                        'title': 'Deposit Fund',
                        'icon': Icons.attach_money_outlined,
                        'onTap': () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DepositFundScreen(),
                            ),
                          );
                          // context.push(Paths.deposit_fund);
                        },
                      },
                      {
                        'title': 'Withdraw Fund',
                        'icon': Icons.account_balance_wallet_outlined,
                        'onTap': () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => WithdrawFundScreen(),
                            ),
                          );
                          // context.push(Paths.withdraw_fund);
                        },
                      },
                      {
                        'title': 'Deposit/Withdraw History',
                        'icon': Icons.history,
                        'onTap': () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) => DepositWithdrawHistoryScreen(),
                            ),
                          );
                          // context.push(Paths.deposit_withdrawhistory);
                        },
                      },
                    ],
                  ),

                  // Support
                  _buildListTile(
                    icon: Icons.support_agent_outlined,
                    title: 'Support',
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => SupportPage()),
                      // );
                      context.push(Paths.support);
                    },
                  ),

                  // Economic Calendar
                  _buildListTile(
                    icon: Icons.calendar_month_outlined,
                    title: 'Economic Calendar',
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => EconomicCalendarScreen(),
                      //   ),
                      // );
                      context.push(Paths.economicCalendar);
                    },
                  ),
                  // download
                  _buildListTile(
                    icon: Icons.download_outlined,
                    title: 'Downloads',
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => DownloadScreen()),
                      // );
                      context.push(Paths.downloads);
                    },
                  ),

                  // Logout
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
                        customHeader: Icon(
                          Icons.question_mark_outlined,
                          size: 50,
                          color: Colors.orange,
                        ),
                        headerAnimationLoop: true,
                        titleTextStyle: Theme.of(context)
                            .textTheme
                            .headlineLarge!
                            .copyWith(fontWeight: FontWeight.bold),
                        desc: 'Are you sure you want to logout?',
                        btnCancelOnPress: () {},
                        btnOkText: 'Logout',
                        btnOkOnPress: () {
                          Future.delayed(Duration(milliseconds: 200), () {
                            Get.find<AuthController>().logout();
                          });
                        },
                      ).show();
                    },
                  ),

                  _buildListTile(
                    icon: Icons.delete_outline_outlined,
                    title: 'Delete',
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => DownloadScreen()),
                      // );
                      context.push(Paths.downloads);
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        Column(
          children: [
            Expanded(
              child: Container(
                color: Colors.black.withOpacity(0.8),
                child: Row(
                  children: [
                    SizedBox(width: 15),
                    AnimatedCircleButton(onTap: () => Navigator.pop(context)),

                    SizedBox(width: 15),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // Helper Widget for normal ListTile
  Widget _buildListTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(title, style: TextStyle(color: Colors.white)),
      onTap: onTap,
    );
  }

  // Helper Widget for ExpansionTile
  Widget _buildExpansionTile({
    required String title,
    required IconData icon,
    required List<Map<String, dynamic>> submenus,
  }) {
    return Theme(
      data: ThemeData().copyWith(
        dividerColor: Colors.transparent,
      ), // <<< remove divider lines
      child: ExpansionTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(title, style: TextStyle(color: Colors.white)),
        iconColor: Colors.blue,
        collapsedIconColor: Colors.white,
        children:
            submenus.map((submenu) {
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  dense: true,
                  leading: Icon(submenu['icon'], size: 20, color: Colors.white),
                  title: Text(
                    submenu['title'],
                    style: TextStyle(fontSize: 14, color: Colors.white),
                  ),
                  onTap: submenu['onTap'],
                ),
              );
            }).toList(),
      ),
    );
  }
}
