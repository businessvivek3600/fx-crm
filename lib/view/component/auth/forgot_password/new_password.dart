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
  final _formKey = GlobalKey<FormState>();

  void _handleSetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    final newPassword = _newPasswordController.text.trim();
    final confirmPassword = _confirmPasswordController.text.trim();

    authController.isLoading.value = true;

    bool success = await authController.changePassword(
      widget.username,
      newPassword,
      confirmPassword,
    );

    authController.isLoading.value = false;

    if (success) {
      router.pushReplacement(Paths.login);
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
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
          child: Form(
            key: _formKey,
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
                  "Use 8+ characters with a symbol.",
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
                  validator: (value) {
                    if (value == null ||
                        value.isEmpty ||
                        value.length < 8 ||
                        !RegExp(r'[!@#\$&*~]').hasMatch(value)) {
                      return "Req: 8+characters & !@#*~";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Confirm Password Field
                CustomTextFormField(
                  label: "Confirm Password",
                  hint: "Re-enter your new password",
                  controller: _confirmPasswordController,
                  validator: (value) {
                    if (value != _newPasswordController.text) {
                      return 'Passwords don’t match';
                    }
                    return null;
                  },
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
                              : const Icon(
                                Icons.lock_reset,
                                color: Colors.white,
                              ),
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
      ),
    );
  }
}
