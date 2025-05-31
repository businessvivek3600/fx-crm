

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AnimatedCircleButton extends StatefulWidget {
  final VoidCallback onTap;

  const AnimatedCircleButton({super.key, required this.onTap});

  @override
  State<AnimatedCircleButton> createState() => _AnimatedCircleButtonState();
}

class _AnimatedCircleButtonState extends State<AnimatedCircleButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true); // Repeats infinitely

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Card(
          elevation: 8,
          shape: CircleBorder(),
          child: CircleAvatar(
            radius: 30,
            backgroundColor: Colors.grey.shade900,
            child: Lottie.asset(
              'assets/json/arrow_back.json',
              width: 40,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}