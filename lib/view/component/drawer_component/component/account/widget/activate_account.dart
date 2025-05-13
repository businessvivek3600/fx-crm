import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fx_crm/widgets/bg_container.dart';
import 'package:get/get.dart';
import 'package:fx_crm/main.dart';
import 'package:nb_utils/nb_utils.dart';

class ActivateAccount extends StatefulWidget {
  const ActivateAccount({super.key});

  @override
  State<ActivateAccount> createState() => _ActivateAccountState();
}

class _ActivateAccountState extends State<ActivateAccount> {
  @override
  Widget build(BuildContext context) {
    return BackgroundContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          title: const Text(
            'Activate Account',
            style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
          elevation: 0,
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            children: [
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: const Color(0xFF2A2a21),
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Icon(
                              Icons.person_4_sharp,
                              color: Colors.white,
                              size: 30.0,
                            ),
                          ),
                          Text(
                            "Personal Details",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: fontWeightBoldGlobal,
                            ),
                          ),
                        ],
                      ),
                      const Text(
                        "Your profile is not complete.",
                        style: TextStyle(color: Colors.white),
                      ),
                      const SizedBox(height: 6),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color.fromARGB(255, 229, 91, 26), // Button background color
                          foregroundColor: Colors.white, // Icon/text color
                          padding: EdgeInsets.symmetric(
                            horizontal: 13,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: <Widget>[
                            Icon(Icons.edit_document, size: 24.0),
                            SizedBox(width: 8),
                            Text(
                              "Complete Now",
                              style: TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                color: Colors.amber,
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Padding(
                            padding: EdgeInsets.all(4.0),
                            child: Icon(
                              Icons.back_hand,
                              color: Colors.black,
                              size: 30.0,
                            ),
                          ),
                          Text(
                            "KYC Status",
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                              fontWeight: fontWeightBoldGlobal,
                            ),
                          ),
                        ],
                      ),
                      const Text(
                        "Your KYC is pending.",
                        style: TextStyle(color: Colors.black),
                      ),
                      const SizedBox(height: 6),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              Colors.black, // Button background color
                          foregroundColor: Colors.white, // Icon/text color
                          padding: EdgeInsets.symmetric(
                            horizontal: 13,
                            vertical: 8,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: <Widget>[
                            Icon(Icons.edit_document, size: 24.0),
                            SizedBox(width: 8),
                            Text(
                              "Complete Now",
                              style: TextStyle(fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.lock_outline, color: Colors.black),
                      SizedBox(width: 9),
                      Text(
                        'Convert to Live Account',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: fontWeightBoldGlobal,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: 16),

              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.amber),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.info_outline, color: Colors.amber),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'You cannot convert to a live account until you complete all required verifications.',
                            style: TextStyle(
                              color: Colors.amber,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Text(
                      ". KYC is not approved.",
                      style: TextStyle(
                        color: Colors.amber,
                        fontWeight: fontWeightBoldGlobal,
                      ),
                    ),
                    Text(
                      ". Personal profile is incomplete.",
                      style: TextStyle(
                        color: Colors.amber,
                        fontWeight: fontWeightBoldGlobal,
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
