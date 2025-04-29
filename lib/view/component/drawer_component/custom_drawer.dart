import 'package:flutter/material.dart';
import 'package:fx_crm/view/component/drawer_component/component/funds/deposit_fund.dart';
import 'package:fx_crm/view/component/drawer_component/component/funds/deposite_withdraw_history.dart';
import 'package:fx_crm/view/component/drawer_component/component/funds/wallet_ledger.dart';
import 'package:fx_crm/view/component/drawer_component/component/funds/withdraw_fund.dart';
import 'package:fx_crm/view/component/drawer_component/component/profile/change_password.dart';
import 'package:fx_crm/view/component/drawer_component/component/account/transaction_history.dart';
import 'package:get/get.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import '../../../controller/session_controller.dart';
import '../../../utils/theme.dart';
import '../../../widgets/bg_container.dart';
import 'component/account/create_account_screen.dart';
import 'component/account/wallet_account.dart';
import 'component/profile/bank_wallet_screen.dart';
import 'component/profile/edit_profile.dart';
import 'component/promotions/monthly_reward.dart';
import 'component/promotions/terms_condition.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
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
            DrawerHeader(
              decoration: BoxDecoration(color:Colors.transparent),
              child: CircleAvatar(
                radius: 40,
                child: Text("V", style: TextStyle(fontSize: 24)),
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
                        builder: (context) =>CreateAccountScreen(),
                      ),
                    );
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
                  },
                },
                {
                  'title': 'Transaction History',
                  'icon': Icons.account_balance_wallet_outlined,
                  'onTap': () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TransactionHistoryScreen(),
                      ),
                    );
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProfileScreen(),
                      ),
                    );
                  },
                },
                {
                  'title': 'Bank/Wallet',
                  'icon': Icons.credit_card_outlined,
                  'onTap': () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => WalletScreen()),
                    );
                  },
                },
                {
                  'title': 'Change Password',
                  'icon': Icons.lock_outline,
                  'onTap': () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChangePasswordScreen(),
                      ),
                    );
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
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MonthlyRewardsScreen(),
                      ),
                    );
                  },
                },
                {
                  'title': 'Terms and Condition',
                  'icon': Icons.article,
                  'onTap': () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TermsAndConditionsScreen(),
                      ),
                    );
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
                      MaterialPageRoute(builder: (context) => WalletLedger()),
                    );
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
                  },
                },
                {
                  'title': 'Deposit/Withdraw History',
                  'icon': Icons.history,
                  'onTap': () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DepositWithdrawHistoryScreen(),
                      ),
                    );
                  },
                },
              ],
            ),

            // Support
            _buildListTile(
              icon: Icons.support_agent_outlined,
              title: 'Support',
              onTap: () {},
            ),

            // Economic Calendar
            _buildListTile(
              icon: Icons.calendar_month_outlined,
              title: 'Economic Calendar',
              onTap: () {},
            ),

            // Downloads
            _buildListTile(
              icon: Icons.download_outlined,
              title: 'Downloads',
              onTap: () {},
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
                  customHeader: Icon(Icons.question_mark_outlined, size: 50, color: Colors.orange),
                  headerAnimationLoop: true,
                  titleTextStyle: Theme.of(context).textTheme.headlineLarge!.copyWith(fontWeight: FontWeight.bold),
                  desc: 'Are you sure you want to logout?',
                  btnCancelOnPress: () {},
                  btnOkText: 'Logout',
                  btnOkOnPress: () {
                    SessionController.to.clearSession(); // Clears session and navigates to login
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
    return ListTile(leading: Icon(icon,color: Colors.white,), title: Text(title,style: TextStyle(color: Colors.white),), onTap: onTap);
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
        leading: Icon(icon,color: Colors.white,),
        title: Text(title,style: TextStyle(color: Colors.white),),
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
              leading: Icon(submenu['icon'], size: 20,color: Colors.white,),
              title: Text(submenu['title'], style: TextStyle(fontSize: 14,color: Colors.white)),
              onTap: submenu['onTap'],
            ),
          );
        }).toList(),
      ),
    );
  }
}
