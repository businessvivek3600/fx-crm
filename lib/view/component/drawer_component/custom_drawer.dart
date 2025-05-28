import 'package:flutter/material.dart';
import 'package:fx_crm/routes/route_name.dart';
import 'package:fx_crm/routes/route_settings.dart';
import 'package:fx_crm/view/component/drawer_component/component/account/account_screen.dart';
import 'package:fx_crm/view/component/drawer_component/component/account/wallet_account.dart' show WalletAccountScreen;
import 'package:fx_crm/view/component/drawer_component/component/funds/deposit_fund.dart';
import 'package:fx_crm/view/component/drawer_component/component/funds/deposite_withdraw_history.dart';
import 'package:fx_crm/view/component/drawer_component/component/funds/wallet_ledger.dart';
import 'package:fx_crm/view/component/drawer_component/component/funds/withdraw_fund.dart';
import 'package:get/get.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:go_router/go_router.dart';
import '../../../controller/app_controller.dart';
import '../../../controller/auth_controller.dart';
import '../../../routes/route_path.dart';
import '../../../widgets/bg_container.dart';
import 'component/account/wallet_account.dart';
import 'component/profile/kyc_verification.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final logo = AppController.to.settings;

    return BackgroundContainer(
      useAlternateBackground: true,
      child: Drawer(
        elevation: 8,
        backgroundColor: Colors.black.withOpacity(0.85),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildHeader(context, logo),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  _buildExpansionTile(
                    title: 'My Account',
                    icon: Icons.account_circle_outlined,
                    submenus: [
                      {
                        'title': 'Accounts',
                        'icon': Icons.school_outlined,
                        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => AccountScreen())),
                      },
                      {
                        'title': 'Wallet Account',
                        'icon': Icons.account_balance_wallet_outlined,
                        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => WalletAccountScreen())),
                      },
                      {
                        'title': 'Transaction History',
                        'icon': Icons.history_outlined,
                        'onTap': () => context.push(Paths.trasaction_history),
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
                        'onTap': () => context.push(Paths.editprofile),
                      },
                      {
                        'title': 'Bank/Wallet',
                        'icon': Icons.credit_card_outlined,
                        'onTap': () => context.push(Paths.bank_wallet),
                      },
                      {
                        'title': 'KYC',
                        'icon': Icons.badge_outlined,
                        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => KycUploadScreen())),
                      },
                      {
                        'title': 'Change Password',
                        'icon': Icons.lock_outline,
                        'onTap': () => context.push(Paths.changepassword),
                      },
                    ],
                  ),
                  _buildExpansionTile(
                    title: 'Promotions',
                    icon: Icons.local_offer_outlined,
                    submenus: [
                      {
                        'title': 'Monthly Rewards',
                        'icon': Icons.emoji_events_outlined,
                        'onTap': () => router.push(Routes.monthly_rewards),
                      },
                      {
                        'title': 'Terms and Condition',
                        'icon': Icons.article_outlined,
                        'onTap': () => context.push(Paths.termandcondition),
                      },
                    ],
                  ),
                  _buildExpansionTile(
                    title: 'IB Menu',
                    icon: Icons.menu_open_outlined,
                    submenus: [
                      {
                        'title': 'Become IB',
                        'icon': Icons.group_add_outlined,
                        'onTap': () {/* TODO: Add IB action */},
                      },
                    ],
                  ),
                  _buildExpansionTile(
                    title: 'Funds',
                    icon: Icons.account_balance_wallet_outlined,
                    submenus: [
                      {
                        'title': 'Wallet Ledger',
                        'icon': Icons.account_balance_wallet_outlined,
                        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => WalletLedger())),
                      },
                      {
                        'title': 'Deposit Fund',
                        'icon': Icons.attach_money_outlined,
                        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => DepositFundScreen())),
                      },
                      {
                        'title': 'Withdraw Fund',
                        'icon': Icons.account_balance_wallet_outlined,
                        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => WithdrawFundScreen())),
                      },
                      {
                        'title': 'Deposit/Withdraw History',
                        'icon': Icons.history_outlined,
                        'onTap': () => Navigator.push(context, MaterialPageRoute(builder: (_) => DepositWithdrawHistoryScreen())),
                      },
                    ],
                  ),
                  _buildListTile(
                    icon: Icons.support_agent_outlined,
                    title: 'Support',
                    onTap: () => context.push(Paths.support),
                  ),
                  _buildListTile(
                    icon: Icons.calendar_month_outlined,
                    title: 'Economic Calendar',
                    onTap: () => context.push(Paths.economic_calendar),
                  ),
                  _buildListTile(
                    icon: Icons.download_outlined,
                    title: 'Downloads',
                    onTap: () => context.push(Paths.downloads),
                  ),
                  const Divider(
                    color: Colors.white24,
                    thickness: 1,
                    indent: 16,
                    endIndent: 16,
                    height: 32,
                  ),
                  _buildLogoutTile(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, dynamic logo) {
    return DrawerHeader(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepPurple.shade900, Colors.black87],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(30),
        ),
      ),
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            CircleAvatar(
              radius: 36,
              backgroundColor: Colors.white24,
              backgroundImage: NetworkImage(
                AppController.to.customer.value?.image??
                    'https://cdn-icons-png.flaticon.com/512/149/149071.png',
              ),
              onBackgroundImageError: (_, __) {},
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppController.to.customer.value?.username ?? 'Guest User',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    AppController.to.customer.value?.customerEmail ?? '',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 6),
                  // Add any status or subtitle here if needed
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      horizontalTitleGap: 0,
      leading: Icon(icon, color: Colors.white70),
      title: Text(
        title,
        style: TextStyle(color: Colors.white70, fontSize: 16),
      ),
      onTap: onTap,
      contentPadding: EdgeInsets.symmetric(horizontal: 24),
      dense: true,
      hoverColor: Colors.deepPurpleAccent.withOpacity(0.2),
    );
  }

  Widget _buildExpansionTile({
    required String title,
    required IconData icon,
    required List<Map<String, dynamic>> submenus,
  }) {
    return Theme(
      data: ThemeData().copyWith(
        dividerColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
      ),
      child: ExpansionTile(
        collapsedIconColor: Colors.white70,
        iconColor: Colors.deepPurpleAccent,
        leading: Icon(icon, color: Colors.white70),
        title: Text(
          title,
          style: TextStyle(color: Colors.white70, fontSize: 16, fontWeight: FontWeight.w600),
        ),
        children: submenus
            .map(
              (submenu) => Container(
            margin: EdgeInsets.symmetric(horizontal: 32, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.deepPurple.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              dense: true,
              horizontalTitleGap: 0,
              leading: Icon(submenu['icon'], size: 20, color: Colors.white70),
              title: Text(
                submenu['title'],
                style: TextStyle(fontSize: 14, color: Colors.white70),
              ),
              onTap: submenu['onTap'],
              contentPadding: EdgeInsets.symmetric(horizontal: 16),
              hoverColor: Colors.deepPurpleAccent.withOpacity(0.4),
            ),
          ),
        )
            .toList(),
      ),
    );
  }

  Widget _buildLogoutTile(BuildContext context) {
    return ListTile(
      horizontalTitleGap: 0,
      leading: Icon(Icons.logout, color: Colors.redAccent.shade200),
      title: Text(
        'Logout',
        style: TextStyle(color: Colors.redAccent.shade200, fontWeight: FontWeight.w600, fontSize: 16),
      ),
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
          titleTextStyle: Theme.of(context).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.bold),
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
      contentPadding: EdgeInsets.symmetric(horizontal: 24),
      dense: true,
      hoverColor: Colors.redAccent.withOpacity(0.2),
    );
  }
}
