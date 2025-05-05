import 'package:flutter/material.dart';

import '../../../../../widgets/custom_text_form.dart';

class ChangePasswordScreen extends StatelessWidget {
  ChangePasswordScreen({super.key});

  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController retypePasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Change your information",
          style: TextStyle(fontWeight: FontWeight.bold,letterSpacing: 1.2),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Old Information",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Old Password Field
              CustomTextFormField(
                label: "Old Password",
                hint: "Old Password",
                controller: oldPasswordController,
              ),
              const SizedBox(height: 20),

              // New Password Field
              CustomTextFormField(
                label: "New Password",
                hint: "New Password",
                controller: newPasswordController,
              ),
              const SizedBox(height: 20),

              // Retype Password Field
              CustomTextFormField(
                label: "Re-Type Password",
                hint: "Re-Type Password",
                controller: retypePasswordController,
              ),
              const SizedBox(height: 40),

              // Change Password Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Add your change password logic here
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade800,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.lock, color: Colors.white),
                  label: const Text(
                    "Change Password",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
