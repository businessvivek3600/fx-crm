import 'package:flutter/material.dart';

void showSetBalanceDialog(BuildContext context) {
  final TextEditingController amountController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Close button
              Align(
                alignment: Alignment.topRight,
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Icon(Icons.close, size: 24),
                ),
              ),
              const SizedBox(height: 10),

              // Title
              Text(
                "Set balance for your demo account",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              // Account info
              Text(
                "Account: MT5 Demo 52297992",
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 20),

              // Amount Label
              Text(
                "Amount",
                style: TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 6),

              // Amount TextField with suffix
              TextField(
                controller: amountController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  suffixText: "USD",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 10, horizontal: 12),
                ),
              ),
              const SizedBox(height: 10),

              // Warning Text
              Container(
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(6),
                ),
                padding: const EdgeInsets.all(8),
                child: Row(
                  children: [
                    Icon(Icons.info_outline, size: 16, color: Colors.black87),
                    SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        "Enter an amount between 1 and 5,000,000.",
                        style: TextStyle(fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Set Balance Button
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  onPressed: () {
                    // Implement your logic here
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.greenAccent.shade700,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  child: Text(
                    "Set Balance",
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              )
            ],
          ),
        ),
      );
    },
  );
}