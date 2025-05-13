import 'package:flutter/material.dart';
import 'package:fx_crm/routes/route_name.dart';
import 'package:fx_crm/routes/route_settings.dart';
import 'package:fx_crm/view/component/drawer_component/component/account/create_account_screen.dart';
import 'package:fx_crm/view/component/drawer_component/component/account/wallet_account.dart'
    show WalletAccountScreen;
import 'package:get/get.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:go_router/go_router.dart';
import '../../../controller/app_controller.dart';
import '../../../controller/session_controller.dart';
import '../../../routes/route_path.dart';
import '../../../widgets/bg_container.dart';
import 'component/account/activate_screen.dart';
import 'component/account/wallet_account.dart';
import 'component/profile/kyc_verification.dart';


class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final logo = AppController.to.settings;
    return  BackgroundContainer(
      useAlternateBackground: true,
      child:   Drawer(
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
                decoration: const BoxDecoration(color: Colors.transparent),
                margin: EdgeInsets.zero,
                padding: EdgeInsets.zero,
                child: Align(
                  alignment: Alignment.centerLeft, // Start from left
                  child: Image.network(
                    logo.first.logo ?? 'https://png.pngtree.com/png-vector/20220423/ourmid/pngtree-trade-market-candle-line-png-png-image_4553954.png',
                    fit: BoxFit.contain,
                    width: double.infinity,
                    height: double.infinity,
                    errorBuilder: (context, error, stackTrace) =>
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ActivateAccountScreen(),
                        ),
                      );
                      // router.push(Routes.CreateAccountScreen);
                    },
                  },
                  {
                    'title': 'Wallet Account',
                    'icon': Icons.account_balance_wallet_outlined,
                    'onTap': () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => WalletAccountScreen(),
                        ),
                      );
                      // router.push(Routes.WalletAccountScreen);
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
                      context.push(Paths.trasaction_history);
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
                      context.push(Paths.editprofile);
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
                      context.push(Paths.bank_wallet); // Works now
                    },
                  },
                  {
                    'title': 'KYC',
                    'icon': Icons.badge_outlined,
                    'onTap': () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => KycUploadScreen(),
                        ),
                      );
                      //  router.push(Routes.kyc_verification);
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
                      context.push(Paths.changepassword);
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
                      router.push(Routes.monthly_rewards);
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
                      context.push(Paths.termandcondition);
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
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(builder: (context) => WalletLedger()),
                      // );
                      context.push(Paths.wallet_ledger);
                    },
                  },
                  {
                    'title': 'Deposit Fund',
                    'icon': Icons.attach_money_outlined,
                    'onTap': () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => DepositFundScreen(),
                      //   ),
                      // );
                      context.push(Paths.deposit_fund);
                    },
                  },
                  {
                    'title': 'Withdraw Fund',
                    'icon': Icons.account_balance_wallet_outlined,
                    'onTap': () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => WithdrawFundScreen(),
                      //   ),
                      // );
                      context.push(Paths.withdraw_fund);
                    },
                  },
                  {
                    'title': 'Deposit/Withdraw History',
                    'icon': Icons.history,
                    'onTap': () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => DepositWithdrawHistoryScreen(),
                      //   ),
                      // );
                      context.push(Paths.deposit_withdrawhistory);
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
                  context.push(Paths.economic_calendar);
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
                    titleTextStyle: Theme.of(context).textTheme.headlineLarge!
                        .copyWith(fontWeight: FontWeight.bold),
                    desc: 'Are you sure you want to logout?',
                    btnCancelOnPress: () {},
                    btnOkText: 'Logout',
                    btnOkOnPress: () {
                      SessionController.to
                          .clearSession(); // Clears session and navigates to login
                      SessionController.to
                          .clearSession(); // Clears session and navigates to login
                    },
                  ).show();
                },
              ),
            ],
          ),
        ),

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
