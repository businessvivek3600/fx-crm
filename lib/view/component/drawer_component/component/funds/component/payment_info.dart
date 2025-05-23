import 'package:flutter/material.dart';
import 'package:fx_crm/widgets/bg_container.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class PaymentInfoScreen extends StatelessWidget {
  final String status = "Complete"; // Change to "Pending" to test

  final Color cardColor = const Color(0xFF1C1C1E);
  final Color textColor = Colors.white70;
  final Color highlightColor = Colors.white;

  const PaymentInfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BackgroundContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text("Payment Information"),
          backgroundColor: Colors.transparent,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardColor.withOpacity(0.6),
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: status == "Pending"
                  ? _buildCompletedContent()
                  : _buildPendingContent(),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildCompletedContent() {
    return [
      _infoRow("Status:", "Complete", valueColor: Colors.greenAccent),
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
        text: TextSpan(
          text: 'Seller Email: ',
          style: TextStyle(color: highlightColor, fontWeight: FontWeight.bold),
          children: const [
            TextSpan(
              text: 'touchwoodparveen@gmail.com\n',
              style: TextStyle(color: Colors.blueAccent),
            ),
            TextSpan(
              text: 'DO NOT Send Funds to this Email Address!',
              style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 12),
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
      _infoRow("Status:", "Cancelled / Timed Out", valueColor: Colors.redAccent),
      const SizedBox(height: 15),
      _infoRow("Total Amount To Send:", "10.71516000 LTCT (total confirms needed: 0)"),
      const SizedBox(height: 15),
      _infoRow("Received So Far:", "0.00000000 LTCT (unconfirmed)"),
      const SizedBox(height: 10),
      _infoRow("Balance Remaining:", "10.71516 LTCT", valueColor: Colors.blueAccent),
      const Divider(height: 32, color: Colors.grey),
      Center(
        child: SizedBox(
          height: 170,
          width: 170,
          child: Container(
            color: Colors.white,
            padding: EdgeInsets.all(10),
            child: PrettyQrView.data(
              data: "mfojhWCIn436WTwNIPfZpQSyyrvMBaA3jm",
              decoration: PrettyQrDecoration(
                shape: PrettyQrSmoothSymbol(),
                image: const PrettyQrDecorationImage(
                  image: AssetImage("assets/images/download.png"),
                ),
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
        text: TextSpan(
          text: 'Seller Email: ',
          style: TextStyle(color: highlightColor, fontWeight: FontWeight.bold),
          children: const [
            TextSpan(
              text: 'touchwoodparveen@gmail.com\n',
              style: TextStyle(color: Colors.blueAccent),
            ),
            TextSpan(
              text: 'DO NOT Send Funds to this Email Address!',
              style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold, fontSize: 12),
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

  Widget _infoRow(String label, String value, {Color? valueColor}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            flex: 2,
            child: Text(label,
                style: const TextStyle(color: Colors.white60, fontWeight: FontWeight.w600))),
        Expanded(
          flex: 3,
          child: Text(
            value,
            style: TextStyle(
              color: valueColor ?? Colors.white,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
