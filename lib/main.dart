import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fx_crm/utils/theme.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'constant/app_constant.dart';
import 'controller/app_controller.dart';
import 'controller/session_controller.dart';
import 'database/dio/dio/dio_client.dart';
import 'database/dio/dio/logging_interceptor.dart';
import 'routes/bindings/initial_bindings.dart';
import 'routes/route_settings.dart';

late DioClient dioClient;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    await GetStorage.init(); // Only for Android/iOS/desktop
  }
  dioClient = DioClient(AppConst.baseUrl, null,
      loggingInterceptor: LoggingInterceptor());
  Get.put<DioClient>(dioClient);
  Get.put(AppController());
  Get.put(SessionController());
  SessionController.to.loadSession();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _router = router;
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'FXCRM',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(), // Or your custom theme
      routerDelegate: _router.routerDelegate,
      backButtonDispatcher: _router.backButtonDispatcher,
      routeInformationParser: _router.routeInformationParser,
      routeInformationProvider: _router.routeInformationProvider,
    );
  }
}
