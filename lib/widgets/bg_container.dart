import 'package:flutter/material.dart';

class BackgroundContainer extends StatelessWidget {
  final Widget child;
  final bool useAlternateBackground;
  final double opacity;

  const BackgroundContainer({
    Key? key,
    required this.child,
    this.useAlternateBackground = false,
    this.opacity = 0.7,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String imagePath = useAlternateBackground
        ? 'assets/images/SZD.jpg'
        : 'assets/images/bg1.png';
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imagePath),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(
            Colors.black.withOpacity(opacity),
            BlendMode.darken,
          ),
        ),
      ),
      child: child,
    );
  }
}
