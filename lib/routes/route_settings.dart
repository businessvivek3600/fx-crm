import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fx_crm/routes/route_name.dart';
import 'package:fx_crm/routes/route_path.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../controller/session_controller.dart';
import '../view/component/auth/login_screen.dart';
import '../view/dashboard_screen.dart';

final router = GoRouter(
  navigatorKey: Get.key,
  initialLocation: Paths.dashboard,
  observers: [GetObserver()],
  redirect: _redirect,
  routes: [
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

