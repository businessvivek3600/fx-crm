import 'package:flutter/material.dart';

import '../../../../../widgets/bg_container.dart';

class WalletLedger extends StatefulWidget {
  const WalletLedger({super.key});

  @override
  State<WalletLedger> createState() => _WalletLedgerState();
}

class _WalletLedgerState extends State<WalletLedger> {
  @override
  Widget build(BuildContext context) {
    return  BackgroundContainer(
      child:  Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          title: const Text(
            "Ledger Wallet",
            style: TextStyle(fontWeight: FontWeight.bold,letterSpacing: 1.2),
          ),
          centerTitle: true,
          actions: [
            const Text(
              " Balance : \$0",
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                // Row for Buttons and Wallet Balance
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Transfer Wallet to MT5 logic
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.amber.shade700,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child:  Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: const Text(
                            "Wallet to MT5",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Transfer MT5 to Wallet logic
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child:  Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: const Text(
                            "MT5 to Wallet",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          // Withdraw Funds logic
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15),
                          child: const Text(
                            "Withdraw Funds",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Card(
                  elevation: 1,
                  color: Colors.grey.shade100,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Date: 12/05/2025",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade800,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              "Balance: \$345.00",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green.shade700,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Withdraw your demo account funds from the MT5 platform. This is a dummy transaction for practice purposes only and does not involve real money.",
                          style: TextStyle(
                            color: Colors.grey.shade700,
                            fontSize: 13,
                          ),
                          textAlign: TextAlign.justify,
                        ),
                        const SizedBox(height: 8),
                        Divider(color: Colors.grey.shade300),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.call_received, color: Colors.green, size: 18),
                                const SizedBox(width: 4),
                                Text(
                                  "In: \$100.00",
                                  style: TextStyle(
                                    color: Colors.green.shade700,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Icon(Icons.call_made, color: Colors.red, size: 18),
                                const SizedBox(width: 4),
                                Text(
                                  "Out: \$50.00",
                                  style: TextStyle(
                                    color: Colors.red.shade700,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                )


                // You can add more widgets below if needed
              ],
            ),
          ),
        ),
      ),
    );
  }
}
