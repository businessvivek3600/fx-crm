import 'package:flutter/material.dart';
import 'package:fx_crm/controller/profile_controller.dart';
import 'package:fx_crm/utils/theme.dart';
import 'package:get/get.dart';

import '../../../../../widgets/bg_container.dart';
import '../../../../../widgets/custom_text_form.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key});

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final controller = Get.put(ChangePasswordController());

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BackgroundContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'Set New Password',
            style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Text(
                "Create a strong password",
                style: textTheme.titleMedium?.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 8),
              Text(
                "Use at least 8 characters including letters, numbers, and symbols.",
                style: textTheme.bodySmall?.copyWith(color: Colors.grey.shade300),
              ),
              const SizedBox(height: 32),

              // New Password Field
              CustomTextFormField(
                label: "New Password",
                hint: "Enter your new password",
                controller: controller.newPassword,
              ),
              const SizedBox(height: 16),

              // Confirm Password Field
              CustomTextFormField(
                label: "Confirm Password",
                hint: "Re-enter your new password",
                controller: controller.confirmPassword,
              ),
              const SizedBox(height: 40),

              // Change Password Button
              SizedBox(
                width: double.infinity,
                child: Obx(() {
                  final isLoading = controller.isLoading.value;
                  return ElevatedButton.icon(
                    onPressed: isLoading ? null : controller.changePassword,
                    icon: isLoading
                        ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                        : const Icon(Icons.lock_reset,color: Colors.white,),
                    label: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        isLoading ? "Please wait..." : "Set Password",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ThemeUtils.primaryColor,
                      disabledBackgroundColor: Colors.grey,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
