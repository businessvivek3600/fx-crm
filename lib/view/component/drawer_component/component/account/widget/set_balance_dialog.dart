import 'package:flutter/material.dart';

void showSetBalanceDialog(BuildContext context) {
  final TextEditingController amountController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        backgroundColor: Colors.transparent, // Make dialog background transparent to show shadow
        insetPadding: const EdgeInsets.all(20),
        child: Material(
          color: const Color(0xff151527),
          borderRadius: BorderRadius.circular(12),
          elevation: 12, // Elevation adds a shadow automatically on Material
          shadowColor: Colors.white.withOpacity(0.4), // Use dark shadow color with opacity
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
                    child: const Icon(Icons.close, size: 24, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 10),

                // Title
                const Text(
                  "Set balance for your demo account",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                ),
                const SizedBox(height: 12),

                // Account info
                const Text(
                  "Account: MT5 Demo 52297992",
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
                const SizedBox(height: 20),

                // Amount Label
                const Text(
                  "Amount",
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
                const SizedBox(height: 6),

                // Amount TextField with suffix
                TextField(
                  controller: amountController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    suffixText: "USD",
                    suffixStyle: const TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: const Color(0xFF2E2E2E),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(6),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey),
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
                    color: Colors.white.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    children: const [
                      Icon(Icons.info_outline, size: 16, color: Colors.white),
                      SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          "Enter an amount between 1 and 5,000,000.",
                          style: TextStyle(fontSize: 13, color: Colors.white),
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
                      backgroundColor: const Color(0xFF2E2E2E),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    child: const Text(
                      "Set Balance",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      );
    },
  );
}
