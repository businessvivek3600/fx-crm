


import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

Widget buildStatusBanner(int status) {
  String text;
  Color color;
  Color borderColor;
  Color textColor;

  switch (status) {
    case 1:
      text = "Your KYC is verified";
      color = Colors.green.shade100.withOpacity(0.1);
      borderColor = Colors.green;
      textColor = Colors.green;
      break;
    case 3:
      text = "Your KYC is pending";
      color = Colors.amber.shade100.withOpacity(0.1);
      borderColor = Colors.amber;
      textColor = Colors.amber;
      break;
    case 2:
      text = "Your KYC is rejected";
      color = Colors.red.shade100.withOpacity(0.1);
      borderColor = Colors.red;
      textColor = Colors.red;
      break;
    default:
      text = "Your KYC is not verified";
      color = Colors.red.shade100.withOpacity(0.1);
      borderColor = Colors.red;
      textColor = Colors.red;
      break;
  }

  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: color,
      border: Border.all(color: borderColor),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Text(text, style: TextStyle(color: textColor)),
  );
}

Widget buildHeader(int status) {
  String text;
  Color color;

  switch (status) {
    case 1:
      text = "Verified";
      color = Colors.green;
      break;
    case 3:
      text = "Pending";
      color = Colors.amber;
      break;
    case 2:
      text = "Rejected";
      color = Colors.red;
      break;
    default:
      text = "Not Verified";
      color = Colors.red;
      break;
  }

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    decoration: BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(
      text,
      style: const TextStyle(color: Colors.white, fontSize: 12),
    ),
  );
}
Widget buildShimmer() {
  return Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      children: [
        Shimmer.fromColors(
          baseColor: Colors.grey.shade800,
          highlightColor: Colors.grey.shade600,
          child: Container(
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Shimmer.fromColors(
          baseColor: Colors.grey.shade800,
          highlightColor: Colors.grey.shade600,
          child: Container(
            height: 300,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(16),
            ),
          ),
        ),
      ],
    ),
  );
}
