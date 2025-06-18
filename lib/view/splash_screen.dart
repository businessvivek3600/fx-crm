import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';

import '../controller/session_controller.dart';
import '../routes/route_path.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _fadeAnimation;
  late final VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();

    // Animation controller with a longer duration for smoothness
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    // Smooth scaling from 0.8 to 1.0
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutExpo),
    );

    // Fade in from transparent to fully visible
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeIn),
    );

    // Initialize video
    _videoController = VideoPlayerController.asset(
        'assets/videos/splash_video.mp4',
      )
      ..initialize().then((_) {
        setState(() {}); // Refresh widget when video is ready
        _videoController.play();
        _videoController.setLooping(false);
      });

    // Start animation
    _animationController.forward();

    // Wait for both animation and video before navigating
    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Future.delayed(const Duration(seconds: 2), () {
          final isLoggedIn = SessionController.to.isLoggedIn.value;
          context.go(isLoggedIn ? Paths.dashboard : Paths.login);
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _videoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Video Background
          if (_videoController.value.isInitialized)
            FittedBox(
              fit: BoxFit.cover,
              child: SizedBox(
                width: _videoController.value.size.width,
                height: _videoController.value.size.height,
                child: VideoPlayer(_videoController),
              ),
            )
          else
            Container(color: Colors.black),

          // Animated Splash Image with Scale and Fade
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: Image.asset(
                  'assets/images/splashscreen.png',
                  width: 90,
                  height: 90,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
