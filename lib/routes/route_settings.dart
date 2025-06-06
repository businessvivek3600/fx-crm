import 'dart:async';

import 'package:fx_crm/routes/route_name.dart';
import 'package:fx_crm/routes/route_path.dart';
import 'package:fx_crm/view/component/auth/signup_screen.dart';
import 'package:fx_crm/view/component/drawer_component/component/account/activate_screen.dart';
import 'package:fx_crm/view/component/drawer_component/component/account/account_screen.dart';
import 'package:fx_crm/view/component/drawer_component/component/account/transaction_history.dart';
import 'package:fx_crm/view/component/drawer_component/component/account/wallet_account.dart';
import 'package:fx_crm/view/component/drawer_component/component/profile/bank_wallet_screen.dart';
import 'package:fx_crm/view/component/drawer_component/component/profile/change_password.dart';
import 'package:fx_crm/view/component/drawer_component/component/profile/edit_profile.dart';
import 'package:fx_crm/view/component/drawer_component/component/profile/kyc_verification.dart';
import 'package:fx_crm/view/component/drawer_component/component/promotions/monthly_reward.dart';
import 'package:fx_crm/view/component/drawer_component/component/promotions/terms_condition.dart';
import 'package:fx_crm/view/component/drawer_component/component/support/support_screen.dart';
import 'package:fx_crm/view/component/notification/notification_screen.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../controller/session_controller.dart';
import '../view/component/auth/login_screen.dart';
import '../view/component/drawer_component/component/economic/economic_calander.dart';
import '../view/dashboard_screen.dart';
import '../view/splash_screen.dart';

final router = GoRouter(
  navigatorKey: Get.key,
  initialLocation: Paths.splash,
  observers: [GetObserver()],
  redirect: _redirect,
  routes: [
    GoRoute(
      path: Paths.splash,
      name: Routes.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: Paths.login,
      name: Routes.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: Paths.signup,
      name: Routes.signup,
      builder: (context, state) => SignupScreen(),
    ),
    GoRoute(
      path: Paths.dashboard,
      name: Routes.dashboard,
      builder: (context, state) => DashboardScreen(),
    ),
    GoRoute(
      path: Paths.notification,
      name: Routes.notification,
      builder: (context, state) => NotificationScreen(),
    ),

    /// Account Screens
    GoRoute(
      path: Paths.accounts,
      name: Routes.accounts,
      builder: (context, state) => AccountScreen(),
    ),
    GoRoute(
      path: Paths.walletAccount,
      name: Routes.walletAccount,
      builder: (context, state) => WalletAccountScreen(),
    ),
    GoRoute(
      path: Paths.activateAccount,
      name: Routes.activateAccount,
      builder: (context, state) => ActivateAccountScreen(),
    ),
    GoRoute(
      path: Paths.transactionHistory,
      name: Routes.transactionHistory,
      builder: (context, state) => TransactionHistoryScreen(),
    ),

    /// Profile Screens
    GoRoute(
      path: Paths.editProfile,
      name: Routes.editProfile,
      builder: (context, state) => EditProfileScreen(),
    ),
    GoRoute(
      path: Paths.kycScreen,
      name: Routes.kyc,
      builder: (context, state) => KycUploadScreen(),
    ),
    GoRoute(
      path: Paths.bankWallet,
      name: Routes.bankWallet,
      builder: (context, state) => WalletScreen(),
    ),
    GoRoute(
      path: Paths.changePassword,
      name: Routes.changePassword,
      builder: (context, state) => ChangePasswordScreen(),
    ),

    /// Promotions
    GoRoute(
      path: Paths.monthlyRewards,
      name: Routes.monthlyRewards,
      builder: (context, state) => MonthlyRewardsScreen(),
    ),
    GoRoute(
      path: Paths.termsAndConditions,
      name: Routes.termsAndConditions,
      builder: (context, state) => TermsAndConditionsScreen(),
    ),

    /// Other
    GoRoute(
      path: Paths.economicCalendar,
      name: Routes.economicCalendar,
      builder: (context, state) => EconomicCalendarScreen(),
    ),
    GoRoute(
      path: Paths.support,
      name: Routes.support,
      builder: (context, state) => SupportPage(),
    ),

    /// You can uncomment and use these if needed:
    // GoRoute(
    //   path: Paths.logout,
    //   name: Routes.logout,
    //   builder: (context, state) => LogoutScreen(),
    // ),
  ],
);

FutureOr<String?> _redirect(context, GoRouterState state) {
  final isLoggedIn = SessionController.to.isLoggedIn.value;
  final goingToLogin = state.matchedLocation == Paths.login;
  final goingToSplash = state.matchedLocation == Paths.splash;

  // If not logged in, redirect to login (except splash)
  if (!isLoggedIn && !goingToLogin && !goingToSplash) {
    return Paths.login;
  }

  // If already logged in and going to login, redirect to dashboard
  if (isLoggedIn && goingToLogin) {
    return Paths.dashboard;
  }

  return null;
}
