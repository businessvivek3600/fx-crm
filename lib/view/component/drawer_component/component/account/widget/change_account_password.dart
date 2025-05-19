import 'package:flutter/material.dart';
import 'package:fx_crm/controller/account_controller.dart';
import 'package:fx_crm/controller/app_controller.dart';
import 'package:fx_crm/widgets/bg_container.dart';
import 'package:fx_crm/widgets/custom_text_form.dart';
import 'package:get/get.dart';

class ChangeAccountPassword extends StatefulWidget {
  const ChangeAccountPassword({super.key, this.isInvester = false});
  final bool isInvester;

  @override
  State<ChangeAccountPassword> createState() => _ChangeAccountPasswordState();
}

class _ChangeAccountPasswordState extends State<ChangeAccountPassword> {
  final controller = Get.find<AccountController>();
  final _formKey = GlobalKey<FormState>();
  final newPassword = TextEditingController();
  final confPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BackgroundContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            '${widget.isInvester ? 'Invester' : 'Master'} Password',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            autovalidateMode:
                AutovalidateMode.onUserInteraction, // ✅ enables auto-validation
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                // ✅ Auto-validation for new password only
                CustomTextFormField(
                  label: "New password",
                  hint: "New Password",
                  controller: newPassword,
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
                const SizedBox(height: 10),

                // ❌ No auto-validation for confirm password
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextFormField(
                      label: "Confirm Password",
                      hint: "Confirm Password",
                      controller: confPassword,
                      // No validator here
                    ),
                    const SizedBox(height: 4),
                  ],
                ),
                const SizedBox(height: 40),

                // 🔘 Change Password Button
                SizedBox(
                  width: double.infinity,
                  child: Obx(
                    () => ElevatedButton(
                      onPressed:
                          controller.isLoading.value
                              ? null
                              : () {
                                // validate only new password
                                if (_formKey.currentState!.validate()) {
                                  controller.changeaccountPassword(
                                    Get.find<AppController>()
                                            .customer
                                            .value
                                            ?.accountNo ??
                                        0,
                                    newPassword.text.trim(),
                                    confPassword.text.trim(),
                                    widget.isInvester ? '2' : '1',
                                  );
                                }
                              },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey.shade800,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child:
                          controller.isLoading.value
                              ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2,
                                ),
                              )
                              : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.lock, color: Colors.white),
                                  SizedBox(width: 8),
                                  Text(
                                    "Change Password",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
