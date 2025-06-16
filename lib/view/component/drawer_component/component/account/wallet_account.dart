import 'package:flutter/material.dart';
import '../../../../../widgets/bg_container.dart';

class WalletAccountScreen extends StatelessWidget {
  const WalletAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BackgroundContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          title: const Text(
            "Wallet Account",
            style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
          elevation: 0,
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Card with White Shadow
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xff151527),
                  borderRadius: BorderRadius.circular(20),
                  // boxShadow: [
                  //   BoxShadow(
                  //     color: Colors.white.withOpacity(0.2), // White shadow
                  //     spreadRadius: 2,
                  //     blurRadius: 6,
                  //     offset: const Offset(3,0.1),
                  //   ),
                  // ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Top Header
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: const BoxDecoration(
                        color: Color(0xff151527),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          topRight: Radius.circular(12),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "CLIENT WALLET ID",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            "USD12880510CW",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Account Info
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "ACCOUNT TYPE",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.white70,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            "Client Wallet",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Currency
                          Container(
                            decoration: BoxDecoration(
                              color: Color.fromARGB(139, 66, 66, 66),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            child: Row(
                              children: const [
                                Icon(Icons.monetization_on_outlined,
                                    color: Color(0xff0262f7)),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text("Currency",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500)),
                                ),
                                Text("USD",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          const SizedBox(height: 8),

                          // Balance
                          Container(
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(139, 66, 66, 66),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 8),
                            child: Row(
                              children: const [
                                Icon(Icons.account_balance_wallet_outlined,
                                    color: Color(0xff0262f7)),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text("Balance",
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500)),
                                ),
                                Text("0",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Transfer Button
                    InkWell(
                      onTap: () {
                        // Action on tap
                      },
                      child: Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Color(0xff2e2e2e),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(12),
                            bottomRight: Radius.circular(12),
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Icon(Icons.send, color: Colors.white, size: 20),
                            SizedBox(width: 8),
                            Text(
                              "TRANSFER FUNDS",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
