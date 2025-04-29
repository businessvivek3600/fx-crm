import 'package:flutter/material.dart';

import '../../../../../widgets/bg_container.dart';

class DepositFundScreen extends StatelessWidget {
  const DepositFundScreen({super.key});

  // Dummy list of deposit records
  final List<Map<String, dynamic>> depositRecords = const [
    {
      "requestId": "REQ12345",
      "date": "12/05/2025",
      "amount": 500.0,
      "status": "Pending",
    },
    {
      "requestId": "REQ67890",
      "date": "10/05/2025",
      "amount": 1000.0,
      "status": "Approved",
    },
    {
      "requestId": "REQ11121",
      "date": "08/05/2025",
      "amount": 250.0,
      "status": "Rejected",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return  BackgroundContainer(
      child:  Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: const Text("Deposit Funds" ,style: TextStyle(fontWeight: FontWeight.bold,letterSpacing: 1.2),
        ),
          elevation: 0,
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Row
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // const Text(
                  //   "Deposit Fund",
                  //   style: TextStyle(
                  //     fontSize: 18,
                  //     fontWeight: FontWeight.bold,
                  //   ),
                  // ),
                  ElevatedButton(
                    onPressed: () {
                      // Add Deposit Fund logic
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber.shade700,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      "Deposit Fund",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Deposit Fund Cards
              Expanded(
                child: depositRecords.isEmpty
                    ? const Center(child: Text("No record available"))
                    : ListView.builder(
                  itemCount: depositRecords.length,
                  itemBuilder: (context, index) {
                    final record = depositRecords[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Card(
                        elevation: 1,
                        color: Colors.grey.shade100,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Date: ${record['date']}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: _getStatusColor(record['status']),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      record['status'],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.account_balance_wallet_outlined, size: 18, color: Colors.black87),
                                  const SizedBox(width: 4),
                                  Text(
                                    "Amount: \$${record['amount']}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "Request ID: ${record['requestId']}",
                                style: const TextStyle(
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "Pending":
        return Colors.orange;
      case "Approved":
        return Colors.green;
      case "Rejected":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
