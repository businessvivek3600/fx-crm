

import 'package:flutter/material.dart';
import 'package:fx_crm/routes/route_name.dart';
import 'package:fx_crm/routes/route_path.dart';
import 'package:go_router/go_router.dart';

import '../view/component/auth/login_screen.dart';

final GoRouter goRouter = GoRouter(
  routes: <RouteBase>[
    GoRoute(
      path: Paths.login,
      name: Routes.login,
      pageBuilder: (context, state) {
        return MaterialPage(
          child: const LoginScreen(),
        );
      },
    ),
  ]

);

