import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../routes/route_path.dart';
import '../../../../../utils/theme.dart';
import '../../../../../widgets/bg_container.dart';

class ActivateAccountScreen extends StatelessWidget {
  const ActivateAccountScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const darkBg = Color(0xFF1C1F2E);
    const darkCard = Color(0xFF2A2F40);
    const warningColor = Color(0xFFFFC107);
    const textColor = Colors.white;

    return BackgroundContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          title: Text(
            "Activate Account",
            style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
          elevation: 0,
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _sectionCard(
                title: 'Personal Details',
                message: 'Your profile is not complete.',
                buttonText: 'Complete Now',
                icon: Icons.person_outline,
                onPressed: () {
                  // Navigate to profile completion
                },
              ),
              const SizedBox(height: 16),
              _sectionCard(
                title: 'KYC Status',
                message: 'Your KYC is pending.',
                buttonText: 'Update KYC',
                icon: Icons.credit_card_rounded,
                onPressed: () {
                  context.push(Paths.kyc);
                },
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.lock_outline),
                label: const Text("Convert to Live Account"),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48),
                ),
              ),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.black54,
                  border: Border.all(color: warningColor.withOpacity(0.6)),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text.rich(
                  TextSpan(
                    children: [
                      WidgetSpan(
                        child: Icon(
                          Icons.info_outline,
                          size: 18,
                          color: Colors.amber.withOpacity(0.6),
                        ),
                      ),
                      TextSpan(
                        text:
                            '  You cannot convert to a live account until you complete all required verifications:\n\n',
                      ),
                      TextSpan(text: '• KYC is not approved.\n'),
                      TextSpan(text: '• Personal profile is incomplete.'),
                    ],
                    style: TextStyle(color: Colors.amber.withOpacity(0.6)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionCard({
    required String title,
    required String message,
    required String buttonText,
    required IconData icon,
    required VoidCallback onPressed,
    Color textColor = Colors.white,
    Color messageColor = Colors.white70,
    Color buttonColor = ThemeUtils.primaryColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: messageColor),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  color: textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(message, style: TextStyle(color: messageColor)),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: onPressed,
            icon: const Icon(Icons.edit_note, color: Colors.white),
            label: Text(buttonText),
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}
