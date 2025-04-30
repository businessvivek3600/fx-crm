import 'package:flutter/material.dart';
import 'package:fx_crm/utils/theme.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerTextField extends StatelessWidget {
  final double height;
  final double width;

  const ShimmerTextField({super.key, this.height = 40, this.width = double.infinity});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade400,
      highlightColor: ThemeUtils.primaryColor.withOpacity(0.3),
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),

        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(' ', style: TextStyle(color: Colors.transparent)), // Empty text to show shimmer effect
        ),
      ),
    );
  }
}