import 'dart:async';

import 'package:flutter/material.dart';
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
      path:Paths.splash,
      name: Routes.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: Paths.login,
      name: Routes.login,
      builder: (context, state) {
        return const LoginScreen();
      },
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



    GoRoute(
      path: Paths.signup,
      name: Routes.signup,
      builder: (context, state) => SignupScreen(),
    ),

    GoRoute(
      path: Paths.accounts,
      name: Routes.accounts,
      builder: (context, state) => CreateAccountScreen(),
    ),

    GoRoute(
      path: Paths.wallet_account,
      name: Routes.wallet_account,
      builder: (context, state) => WalletAccountScreen(),
    ),

    GoRoute(
      path: Paths.editprofile,
      name: Routes.editprofile,
      builder: (context, state) => EditProfileScreen(),
    ),
    GoRoute(
      path: Paths.kyc,
      name: Routes.kycScreen,
      builder: (context, state) => KycUploadScreen(),
    ),
    GoRoute(
      path: Paths.bank_wallet,
      name: Routes.bank_wallet,
      builder: (context, state) => WalletScreen(),
    ),
    GoRoute(
      path: Paths.economic_calendar,
      name: Routes.economic_calendar,
      builder: (context, state) => EconomicCalendarScreen(),
    ),
    GoRoute(
      path: Paths.activateAccount,
      name: Routes.activateAccount,
      builder: (context, state) => ActivateAccountScreen(),
    ),

    // GoRoute(
    //   path: Paths.bank_wallet,
    //   name: Routes.bank_wallet,
    //   builder: (context, state) => WalletScreen(),
    // ),
    GoRoute(
      path: Paths.trasaction_history,
      name: Routes.trasaction_history,
      builder: (context, state) => TransactionHistoryScreen(),
    ),
    GoRoute(
      path: Paths.changepassword,
      name: Routes.changepassword,
      builder: (context, state) => ChangePasswordScreen(),
    ),
    GoRoute(
      path: Paths.monthly_rewards,
      name: Routes.monthly_rewards,
      builder: (context, state) => MonthlyRewardsScreen(),
    ),
    GoRoute(
      path: Paths.termandcondition,
      name: Routes.termandcondition,
      builder: (context, state) => TermsAndConditionsScreen(),
    ),

    // GoRoute(
    //   path: Paths.CreateAccountScreen,
    //   name: Routes.CreateAccountScreen,
    //   builder: (context, state) => CreateAccountScreen(),
    // ),
    //     GoRoute(
    //       path: Paths.logout,
    //       name: Routes.logout,
    //       builder: (context, state) => (),
    //     ),
  ],
);

// class AppPages {
// static final routes = [
//   GetPage(name: Routes.login, page: () => LoginScreen()),
//   GetPage(name: Routes.dashboard, page: () => DashboardScreen()),
//   // Add more pages here
// ];

/// through go router

FutureOr<String?> _redirect(context, GoRouterState state) {
  print('Redirecting... ${state.matchedLocation}');
  final isLoggedIn = SessionController.to.isLoggedIn.value;
  final isGoingToLogin = state.matchedLocation == Paths.login;

  if (!isLoggedIn && !isGoingToLogin) {
    return Paths.login;
  }
  if (isLoggedIn && isGoingToLogin) {
    return Paths.dashboard;
  }

  return null; // no redirect
}

// }
