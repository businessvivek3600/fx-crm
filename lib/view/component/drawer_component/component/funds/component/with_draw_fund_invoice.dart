
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../controller/ledger_wallet_controller.dart';
import '../../../../../../models/withdraw_history_model.dart';
import '../../../../../../widgets/bg_container.dart';

class WithdrawInvoiceScreen extends StatelessWidget {
  final WithdrawHistory data;
  const WithdrawInvoiceScreen({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final double amount = double.tryParse(data.amount ?? '0') ?? 0;
    final double processingCharge = amount * 0.02;
    final double netAmount = amount - processingCharge;
    final WalletLedgerController controller = Get.put(WalletLedgerController());
    return BackgroundContainer(
        child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: const Text("Withdrawal Invoice", style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),

    ),
    ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Color(0xFF1C1C1E).withOpacity(0.6),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Image.asset("assets/images/download.png", height: 60), // Your logo

                    const SizedBox(height: 20),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _infoBlock("Bank Detail", [
                    "Account Name: ${data.accountHolderName}",
                    "Account No.: ${data.accountNo}",
                    "IFSC Code: ${data.ifscCode}",
                    "Bank: ${data.bank}",
                  ]),
                  _infoBlock("Customer Details", [
                    "Name: ${data.accountHolderName}",
                    "Country: ${data.country ?? 'India'}",
                    "Payment Type: ${data.paymentType ?? 'Bank'}",
                  ]),

                ],
              ),
              const SizedBox(height: 16),
              Text("Transaction Number: ${data.transactionNumber ?? '-'}",
                  style: const TextStyle(color: Colors.white70)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Date: ${controller.formatDate(data.createdAt.toString()) ?? ''}",
                      style: const TextStyle(color: Colors.white70)),
                  Row(
                    children: [
                      const Text("Status: ", style: TextStyle(color: Colors.white70)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color:controller.statusColor(data.status),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          controller.statusText(data.status) ?? 'Not Paid',
                          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(color: Colors.white38),
              const SizedBox(height: 16),
              _amountRow("Withdraw Amount", "\$${amount.toStringAsFixed(2)}"),
              _amountRow("Processing Charges (2%)", "\$${processingCharge.toStringAsFixed(2)}"),
              const Divider(color: Colors.white54),
              _amountRow("Net Amount", "\$${netAmount.toStringAsFixed(2)}", isBold: true),
              const Spacer(),
              const Align(
                alignment: Alignment.centerRight,
                child: Text("Accounts Department FX",
                    style: TextStyle(color: Colors.white70, fontSize: 12)),
              ),
            ],
          ),
        ),
      ),
        ),
    );
  }

  Widget _infoBlock(String title, List<String> lines) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
          const SizedBox(height: 8),
          ...lines.map((line) => Text(line, style: const TextStyle(color: Colors.white))),
        ],
      ),
    );
  }

  Widget _amountRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(color: Colors.white70, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        Text(value,
            style: TextStyle(color: Colors.white, fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
      ],
    );
  }
}
