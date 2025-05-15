import 'package:flutter/material.dart';
import 'package:fx_crm/controller/auth_controller.dart';
import 'package:fx_crm/routes/route_name.dart';
import 'package:fx_crm/routes/route_path.dart';
import 'package:fx_crm/routes/route_settings.dart';
import 'package:fx_crm/utils/theme.dart';
import 'package:fx_crm/view/component/auth/login_screen.dart';
import 'package:get/get.dart';

import '../../../../../widgets/bg_container.dart';
import '../../../../../widgets/custom_text_form.dart';

class NewPasswordScreen extends StatefulWidget {
  const NewPasswordScreen({super.key, required this.username});
  final String username;

  @override
  State<NewPasswordScreen> createState() => _NewPasswordScreenState();
}

class _NewPasswordScreenState extends State<NewPasswordScreen> {
  final authController = Get.find<AuthController>();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  void _handleSetPassword() async {
    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill all fields',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    if (newPassword != confirmPassword) {
      Get.snackbar(
        'Error',
        'Passwords do not match',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    bool success = await authController.changePassword(
      widget.username,
      newPassword,
      confirmPassword,
    );
    router.pushReplacement(Paths.login);
    if (success) {
      // Navigator.of(context).pushReplacement(
      //   MaterialPageRoute(builder: (context) => LoginScreen()),
      // ); // Direct navigation for debug
    }
  }

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
                style: textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade300,
                ),
              ),
              const SizedBox(height: 32),

              // New Password Field
              CustomTextFormField(
                label: "New Password",
                hint: "Enter your new password",
                controller: _newPasswordController,
                // isPassword: true,
              ),
              const SizedBox(height: 16),

              // Confirm Password Field
              CustomTextFormField(
                label: "Confirm Password",
                hint: "Re-enter your new password",
                controller: _confirmPasswordController,
                // isPassword: true,
              ),
              const SizedBox(height: 40),

              // Set Password Button
              SizedBox(
                width: double.infinity,
                child: Obx(() {
                  final isLoading = authController.isLoading.value;
                  return ElevatedButton.icon(
                    onPressed: isLoading ? null : _handleSetPassword,
                    icon:
                        isLoading
                            ? const SizedBox(
                              width: 20,
                              height: 20,

                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            )
                            : const Icon(Icons.lock_reset, color: Colors.white),
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
