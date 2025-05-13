import 'package:flutter/material.dart';
import 'package:fx_crm/utils/theme.dart';

import '../../../../../controller/app_controller.dart';
import '../../../../../widgets/bg_container.dart';

class MonthlyRewardsScreen extends StatelessWidget {
   MonthlyRewardsScreen({super.key});
  final monthlyReward = AppController.to.company.value;
  @override
  Widget build(BuildContext context) {

    return  BackgroundContainer(
      child:  Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Monthly Rewards',style: TextStyle(fontWeight: FontWeight.bold,letterSpacing: 1.2),
          ),
          elevation: 0,
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // const Text(
              //   "Scratch & Win Rewards!",
              //   style: TextStyle(
              //     fontSize: 22,
              //     fontWeight: FontWeight.bold,
              //     color: wh,
              //   ),
              // ),
              // const SizedBox(height: 16),
              Expanded(
                child: GridView.builder(
                  itemCount: 6, // Example: 6 scratch cards
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.8,
                  ),
                  itemBuilder: (context, index) {
                    return _buildScratchCard(index);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

   Widget _buildScratchCard(int index) {
     return Card(
       shape: RoundedRectangleBorder(
         borderRadius: BorderRadius.circular(16),
       ),
       elevation: 4,
       color: Colors.grey.shade900.withOpacity(0.8),
       clipBehavior: Clip.antiAlias, // ensures image respects border radius
       child: Image.network(
         monthlyReward?.monthlyRewardImg ??
             "https://png.pngtree.com/png-clipart/20200701/original/pngtree-color-splash-ink-rewards-short-sentence-copy-png-image_5364565.jpg",
         fit: BoxFit.cover,
         loadingBuilder: (context, child, loadingProgress) {
           if (loadingProgress == null) return child;
           return const Padding(
             padding: EdgeInsets.all(16),
             child: CircularProgressIndicator(),
           );
         },
         errorBuilder: (context, error, stackTrace) =>
         const Icon(Icons.broken_image, color: Colors.white),
       ),
     );
   }

}
