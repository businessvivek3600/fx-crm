import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';


import '../controller/session_controller.dart';
import '../routes/route_path.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(vsync: this);

    // You can change duration or speed here
    _animationController.duration = const Duration(seconds: 3);
    _animationController.forward();

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        final isLoggedIn = SessionController.to.isLoggedIn.value;
        context.go(isLoggedIn ? Paths.dashboard : Paths.login);
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.6),
      body: Center(
        child: Lottie.asset(
          'assets/json/Animation - 1747216318540.json',
          controller: _animationController,
          onLoaded: (composition) {
            _animationController.duration = composition.duration * 0.05; // 2x speed
            _animationController.forward();
          },
        ),
      ),
    );
  }
}
