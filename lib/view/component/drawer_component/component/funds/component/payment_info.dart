import 'package:flutter/material.dart';
import 'package:fx_crm/controller/ledger_wallet_controller.dart';
import 'package:fx_crm/models/payment_informaton_model.dart';
import 'package:fx_crm/widgets/bg_container.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pretty_qr_code/pretty_qr_code.dart';

class PaymentInfoScreen extends StatefulWidget {
  const PaymentInfoScreen({super.key, required this.trxId});
  final String trxId;

  @override
  State<PaymentInfoScreen> createState() => _PaymentInfoScreenState();
}

class _PaymentInfoScreenState extends State<PaymentInfoScreen> {
  final controller = Get.find<WalletLedgerController>();
  PaymentInformation? inf;
  bool loading = true;
  // Change to "Pending" to test
  final Color cardColor = const Color(0xFF1C1C1E);

  final Color textColor = Colors.white70;

  final Color highlightColor = Colors.white;

  @override
  void initState() {
    super.initState();
    afterBuildCreated(() {
      controller
          .fetchPaymentInformation(txnId: widget.trxId)
          .then(
            (v) => setState(() {
              inf = v;
              loading = false;
            }),
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<WalletLedgerController>(
      builder: (controller) {
        final status = inf?.data?.status ?? -1;
        return BackgroundContainer(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: const Text("Payment Information"),
              backgroundColor: Colors.transparent,
            ),
            body:
                loading
                    ? const Center(child: CircularProgressIndicator())
                    : inf == null
                    ? const Center(
                      child: Text(
                        "No Payment Information Found",
                        style: TextStyle(color: Colors.white),
                      ),
                    )
                    : SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: cardColor.withOpacity(0.6),
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:
                              status == 1 || status == 2
                                  ? _buildCompletedContent(status)
                                  : _buildPendingContent(status),
                        ),
                      ),
                    ),
          ),
        );
      },
    );
  }

  List<Widget> _buildCompletedContent(int status) {
    return [
      _infoRow(
        "Status:",
        "${inf?.data?.status ?? 0} ${inf?.data?.statusText ?? ''}Complete",
        valueColor: Colors.greenAccent,
      ),
      const SizedBox(height: 15),
      _infoRow(
        "Total Amount To Send:",
        " (total confirms needed: 0)",
      ),
      const SizedBox(height: 15),
      _infoRow(
        "Received So Far:",
        "${inf?.data?.recived ?? 0} ${inf?.data?.recived ?? ''} (unconfirmed)",
      ),
      const SizedBox(height: 15),
      _infoRow(
        "Send To Address:",
        "${inf?.data?.walletAddress ?? 0} ${inf?.data?.walletAddress ?? ''}mtD2P7zwdGy6KUaHE3qxd3KaQiQeKMbxu",
      ),
      const SizedBox(height: 15),
      _infoRow(
        "Time Completed:",
        "${inf?.data?.statusText ?? 0} ${inf?.data?.statusText ?? ''}May 20, 2025 05:43:04pm",
      ),
      const SizedBox(height: 15),
      _infoRow(
        "Seller:",
        "${inf?.data?.orderId ?? 0} ${inf?.data?.orderId ?? ''} (No Ratings)",
      ),
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
              style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 10),
      _infoRow("Payment ID:", "CPJE4S6WBRNHGVGOY6LDRIAH5S"),
    ];
  }

  List<Widget> _buildPendingContent(int status) {
    return [
      _infoRow(
        "Status:",
        "${inf?.data?.statusText ?? 0} ${inf?.data?.statusText ?? ''}",
        valueColor: Colors.redAccent,
      ),
      const SizedBox(height: 15),
      _infoRow(
        "Total Amount To Send:",
        "${inf?.data?.amount ?? 0} ${inf?.data?.amount ?? ''}",
      ),
      const SizedBox(height: 15),
      _infoRow("Received So Far:", "${inf?.data?.coinAmt ?? 0} ${inf?.data?.coinAmt ?? ''}"),
      const SizedBox(height: 10),
      _infoRow(
        "Balance Remaining:",
        "10.71516 LTCT",
        valueColor: Colors.blueAccent,
      ),
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
      _infoRow("Send To Address:", "${inf?.data?.walletAddress ?? 0} ${inf?.data?.walletAddress ?? ''}"),
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
              style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: 20),
      _infoRow(
        "Leave Feedback:",
        "You will be able to leave feedback once this transaction is completed.",
      ),
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
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.white60,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
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
