

import 'package:flutter/material.dart';
import 'package:fx_crm/widgets/glass_card.dart';
import 'package:shimmer/shimmer.dart';

class LedgerShimmerCard extends StatelessWidget {
  const LedgerShimmerCard({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: GlassCard(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(width: 80, height: 14, color: Colors.white),
                    Container(width: 80, height: 14, color: Colors.white),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}