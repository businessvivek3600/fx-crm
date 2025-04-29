import 'package:flutter/material.dart';

import '../../../../../widgets/bg_container.dart';

class TermsAndConditionsScreen extends StatelessWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return   BackgroundContainer(
      child:  Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text('Terms & Conditions',style: TextStyle(fontWeight: FontWeight.bold,letterSpacing: 1.2),
          ),
          elevation: 0,
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            color: Colors.grey.shade100,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.description_outlined, color: Colors.blueGrey.shade700),
                      const SizedBox(width: 8),
                      Text(
                        'Term & Conditions',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.blueGrey.shade800,
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 30, thickness: 1),
                  _buildParagraph(
                    "Please read the following rules carefully before signing in.",
                  ),
                  _buildParagraph(
                    "You agree to be of legal age in your country to partake in this program, and in all cases, your minimal age must be 18 years.",
                  ),
                  _buildParagraph(
                    "qbn.com is not available to the general public and is open only to qualified members. Every deposit is considered a private transaction between forexmountains.com and its Members.",
                  ),
                  _buildParagraph(
                    "As a private transaction, this program is exempt from the US Securities Act of 1933, and other regulations. We are not FDIC-insured. We are not a licensed bank or security firm.",
                  ),
                  _buildParagraph(
                    "You agree that all information from forexmountains.com is private, confidential, and must be protected. Communications are not offers or solicitations for investments where restricted.",
                  ),
                  _buildParagraph(
                    "All data given by a member will be used privately and not disclosed to third parties. forexmountains.com is not liable for any loss of data.",
                  ),
                  _buildParagraph(
                    "You agree to hold all principals and members harmless of any liability. Investments are at your own risk. Past performance does not guarantee future performance.",
                  ),
                  _buildParagraph(
                    "We reserve the right to change the rules, commissions, and rates of the program at any time without notice. You must review the current terms regularly.",
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildParagraph(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.blueGrey.shade700,
          fontSize: 15,
          height: 1.5,
        ),
        textAlign: TextAlign.justify,
      ),
    );
  }
}
