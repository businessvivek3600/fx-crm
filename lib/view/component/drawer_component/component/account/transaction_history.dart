import 'package:flutter/material.dart';

import '../../../../../widgets/bg_container.dart';

class TransactionHistoryScreen extends StatefulWidget {
  const TransactionHistoryScreen({super.key});

  @override
  State<TransactionHistoryScreen> createState() =>
      _TransactionHistoryScreenState();
}

class _TransactionHistoryScreenState extends State<TransactionHistoryScreen> {
  // late final DashBoardController dashBoardController;
  // @override
  // void initState() {
  //   super.initState();
  //   dashBoardController = Get.put(DashBoardController(dioClient: dioClient)); // Provide dioClient
  //   dashBoardController.getDashboardData();
  //
  // }

  @override
  Widget build(BuildContext context) {
    return  BackgroundContainer(
      child:  Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          title: const Text('Transaction History',style: TextStyle(fontWeight: FontWeight.bold,letterSpacing: 1.2),
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
                      // Add Deposit Fund logic
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
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

              /// DataGrid
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
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Colors.grey.shade100,
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildRow(Icons.calendar_today, "Transaction Date", transactionDate),
            const SizedBox(height: 15),
            _buildRow(Icons.swap_vert, "Transaction Type", transactionType),
            const SizedBox(height: 15),
            _buildRow(Icons.payment, "Payment Method", paymentMethod),
            const SizedBox(height: 15),
            _buildRow(Icons.account_balance_wallet, "Source", source),
            const SizedBox(height: 15),
            _buildRow(Icons.account_circle, "Account", account),
            const SizedBox(height: 15),
            _buildRow(Icons.attach_money, "Amount", "\$$amount"),
            const SizedBox(height: 15),
            _buildRow(
              Icons.info_outline,
              "Status",
              status,
              statusColor: status.toLowerCase() == 'incomplete' ? Colors.orange : Colors.green,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(IconData icon, String title, String value, {Color statusColor = Colors.black87}) {
    return Row(
      children: [
        Icon(icon, size: 20, color: Colors.deepPurpleAccent),
        const SizedBox(width: 8),
        Expanded(
          flex: 2,
          child: Text(
            title,
            textAlign: TextAlign.justify,
            style: const TextStyle(
              fontWeight: FontWeight.bold,

              color: Colors.black87,
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
            ),
          ),
        ),
      ],
    );
  }
}