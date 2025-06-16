import 'package:flutter/material.dart';
import 'package:fx_crm/widgets/bg_container.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../widgets/custom_text_form.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({Key? key}) : super(key: key);

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  final List<String> reasons = [
    'No longer using the service/platform',
    'Found a better alternative',
    'Privacy concerns',
    'Too many emails/notifications',
    'Difficulty navigating the platform',
    'Account security concerns',
    'Personal reasons',
    'Others',
  ];

  String? selectedReason;
  TextEditingController otherReasonController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BackgroundContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          title: const Text(
            "Delete Account",
            style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
          elevation: 0,
          centerTitle: true,

        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              Text(
                "If you need to delete an account and you're prompted to provide a reason.",
                style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              ...reasons.map((reason) {
                return RadioListTile<String>(
                  title: Text(reason,style: TextStyle(color: Colors.white70),),
                  value: reason,
                  fillColor: WidgetStatePropertyAll(Colors.white54),
                  activeColor:Colors.white,

                  groupValue: selectedReason,
                  onChanged: (value) {
                    setState(() {
                      selectedReason = value!;
                    });
                  },
                );
              }).toList(),
              if (selectedReason == 'Others') ...[
                SizedBox(height: 10),
                CustomTextFormField(

                  label: '',
                  hint: 'Write a message here',

                  controller: otherReasonController,
                ),
              ],
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  if (selectedReason == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Please select a reason")),
                    );
                    return;
                  }
                  _showConfirmationDialog(context);
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: Text("Delete", style: TextStyle(fontSize: 16)),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.help_outline, size: 50, color: Colors.orange),
              SizedBox(height: 20),
              Text("Are you sure?",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text("You want to delete your account permanently.\n\nLoss of data, subscriptions, etc."),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Keep Account"),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    onPressed: () {
                      Navigator.pop(context);
                      _deleteAccount();
                    },
                    child: Text("Delete"),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  Future<void> _deleteAccount() async {
    const url = 'https://aic.tenxbot.com/delete-user';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Could not open delete link")),
      );
    }
  }
}
