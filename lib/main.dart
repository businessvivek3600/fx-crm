import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fx_crm/utils/theme.dart';
import 'package:fx_crm/view/component/auth/login_screen.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'constant/app_constant.dart';
import 'controller/app_controller.dart';
import 'controller/auth_controller.dart';
import 'controller/session_controller.dart';
import 'database/dio/dio/dio_client.dart';
import 'database/dio/dio/logging_interceptor.dart';
import 'database/notification_service.dart';
import 'firebase_options.dart';
import 'view/dashboard_screen.dart';

late DioClient dioClient;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!kIsWeb) {
    await GetStorage.init();
  }
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  await NotificationService().init();
  Get.put(SessionController());
  SessionController.to.loadSession();
  dioClient = DioClient(
    AppConst.baseUrl,
    null,
    loggingInterceptor: LoggingInterceptor(),
  );
  Get.put<DioClient>(dioClient);
  Get.put(AppController());
  AppController.to.syncWithSession();
  final AuthController authController = Get.put(
    AuthController(dioClient: dioClient),
  );
  await authController.getCountryList();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeUtils.lightTheme,
      title: 'FXCRM',
      home: Obx(() {
        return SessionController.to.isLoggedIn.value
            ? DashboardScreen()
            : LoginScreen();
      }),
    );
  }
}
