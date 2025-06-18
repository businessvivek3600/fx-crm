import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
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
  late final VideoPlayerController _videoController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(vsync: this);
    _animationController.duration = const Duration(seconds: 3);

    _videoController = VideoPlayerController.asset(
        'assets/videos/splash_video.mp4',
      )
      ..initialize().then((_) {
        setState(() {}); // Rebuild after initialization
        _videoController.play();
        _videoController.setLooping(false);
      });

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
            Container(color: Colors.black), // fallback while loading
          // Center Image Overlay
          Center(
            child: Image.asset(
              'assets/images/splashscreen.png',
              width: 90,
              height: 90,
            ),
          ),
        ],
      ),
    );
  }
}
