import 'package:flutter/material.dart';
import 'package:fx_crm/widgets/bg_container.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class PaymentInfoScreen extends StatelessWidget {
  final String status = "Complete"; // ← Change this to test other states

  @override
  Widget build(BuildContext context) {
    return BackgroundContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(title: const Text("Payment Information")),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: status == "Complete"
                    ? _buildCompletedContent()
                    : _buildPendingContent(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildCompletedContent() {
    return [
      _infoRow("Status:", "Complete"),
      const SizedBox(height: 15),
      _infoRow("Total Amount To Send:", "1.07022000 LTCT (total confirms needed: 0)"),
      const SizedBox(height: 15),
      _infoRow("Received So Far:", "1.07022000 LTCT (unconfirmed)"),
      const SizedBox(height: 15),
      _infoRow("Send To Address:", "mtD2P7zwdGy6KUaHE3qxd3KaQiQeKMbxu"),
      const SizedBox(height: 15),
      _infoRow("Time Completed:", "May 20, 2025 05:43:04pm"),
      const SizedBox(height: 15),
      _infoRow("Seller:", "parveen115 (No Ratings)"),
      const SizedBox(height: 15),
      RichText(
        text: const TextSpan(
          text: 'Seller Email: ',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          children: [
            TextSpan(
              text: 'touchwoodparveen@gmail.com\n',
              style: TextStyle(color: Colors.blue),
            ),
            TextSpan(
              text: 'DO NOT Send Funds to this Email Address!',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ],
        ),
      ),
      const SizedBox(height: 10),
      _infoRow("Payment ID:", "CPJE4S6WBRNHGVGOY6LDRIAH5S"),
    ];
  }

  List<Widget> _buildPendingContent() {
    return [
      _infoRow("Status:", "Cancelled / Timed Out"),
      const SizedBox(height: 15),
      _infoRow("Total Amount To Send:", "10.71516000 LTCT (total confirms needed: 0)"),
      const SizedBox(height: 15),
      _infoRow("Received So Far:", "0.00000000 LTCT (unconfirmed)"),
      const SizedBox(height: 10),
      _infoRow("Balance Remaining:", "10.71516 LTCT", valueColor: Colors.blue),
      const Divider(height: 32),
      Center(
        child: SizedBox(
          height: 170,
          width: 170,
          child: PrettyQrView.data(
            data: "mfojhWCIn436WTwNIPfZpQSyyrvMBaA3jm", // Replace with dynamic address if needed
            decoration: const PrettyQrDecoration(
              image: PrettyQrDecorationImage(
                image: AssetImage("assets/images/download.png"), // Optional logo in QR
              ),
            ),
          ),
        ),
      ),

      const SizedBox(height: 10),
      _infoRow("Send To Address:", "mfojhWCIn436WTwNIPfZpQSyyrvMBaA3jm"),
      const SizedBox(height: 8),
      _infoRow("Seller:", "parveen115"),
      const SizedBox(height: 8),
      RichText(
        text: const TextSpan(
          text: 'Seller Email: ',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          children: [
            TextSpan(
              text: 'touchwoodparveen@gmail.com\n',
              style: TextStyle(color: Colors.blue),
            ),
            TextSpan(
              text: 'DO NOT Send Funds to this Email Address!',
              style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ],
        ),
      ),
      const SizedBox(height: 20),
      _infoRow("Leave Feedback:", "You will be able to leave feedback once this transaction is completed."),
      const SizedBox(height: 10),
      _infoRow("Payment ID:", "CPJE46Q00RL9O2G531R5QTC1R6"),
    ];
  }

  Widget _infoRow(String label, String value, {Color valueColor = Colors.black}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(width: 4),
        Expanded(child: Text(value, style: TextStyle(color: valueColor))),
      ],
    );
  }

  Widget _ratingOption(String label, Color color) {
    return Row(
      children: [
        Radio(value: label, groupValue: null, onChanged: (_) {}),
        Text(label, style: TextStyle(color: color),textAlign: TextAlign.justify,),
      ],
    );
  }
}
