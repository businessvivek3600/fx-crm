import 'package:flutter/material.dart';
import '../../../../../widgets/bg_container.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  @override
  Widget build(BuildContext context) {
    return BackgroundContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          title: const Text(
            'Transaction History',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          elevation: 0,
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Export Button
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      // Add Export logic
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff2e2e2e),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      "Export",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              /// Transaction Card Example
              TransactionCard(
                transactionDate: '27/04/2025 19:44',
                transactionType: 'Deposit',
                paymentMethod: 'Credit Card',
                source: 'Client Wallet',
                account: 'USD12880510CW',
                amount: 1000.00,
                status: 'Incomplete',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TransactionCard extends StatelessWidget {
  final String transactionDate;
  final String transactionType;
  final String paymentMethod;
  final String source;
  final String account;
  final double amount;
  final String status;

  const TransactionCard({
    super.key,
    required this.transactionDate,
    required this.transactionType,
    required this.paymentMethod,
    required this.source,
    required this.account,
    required this.amount,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xff151527),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildRow(Icons.calendar_today, "Transaction Date", transactionDate),
          const SizedBox(height: 12),
          _buildRow(Icons.swap_vert, "Transaction Type", transactionType),
          const SizedBox(height: 12),
          _buildRow(Icons.payment, "Payment Method", paymentMethod),
          const SizedBox(height: 12),
          _buildRow(Icons.account_balance_wallet, "Source", source),
          const SizedBox(height: 12),
          _buildRow(Icons.account_circle, "Account", account),
          const SizedBox(height: 12),
          _buildRow(Icons.attach_money, "Amount", "\$$amount"),
          const SizedBox(height: 12),
          _buildRow(
            Icons.info_outline,
            "Status",
            status,
            statusColor: status.toLowerCase() == 'incomplete'
                ? Colors.orange
                : Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildRow(IconData icon, String title, String value,
      {Color statusColor = Colors.white}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: const Color(0xff0262f7)),
        const SizedBox(width: 8),
        Expanded(
          flex: 2,
          child: Text(
            title,
            textAlign: TextAlign.left,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(
              color: statusColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
