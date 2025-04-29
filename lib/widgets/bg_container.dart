import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class BackgroundContainer extends StatelessWidget {
  final Widget child;
  final bool useAlternateBackground;
  final double opacity;

  const BackgroundContainer({
    super.key,
    required this.child,
    this.useAlternateBackground = false,
    this.opacity = 0.7,
  });
  double getPlatformOpacity() {
    if (kIsWeb) return 0.3;
    if (Platform.isAndroid) return 0.7;
    if (Platform.isIOS) return 0.7;
    return 0.6;
  }
  @override
  Widget build(BuildContext context) {
    final String imagePath = useAlternateBackground
        ? 'assets/images/SZD.jpg'
        : 'assets/images/bg1.png';
    final double effectiveOpacity = getPlatformOpacity() ?? opacity;
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(effectiveOpacity),
            BlendMode.darken,
          ),
        ),
      ),
      child: child,
    );
  }
}
