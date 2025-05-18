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
  var controller = Get.find<AccountController>();
  TextEditingController newPassword = TextEditingController();
  TextEditingController confPassword = TextEditingController();
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
            style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Text(
              //   "Old Information",
              //   style: TextStyle(
              //     color: Colors.white,
              //     fontSize: 20,
              //     fontWeight: FontWeight.bold,
              //   ),
              // ),
              const SizedBox(height: 20),

              // Old Password Field
              CustomTextFormField(
                label: "New password",
                hint: "New Password",
                controller: newPassword,
              ),
              const SizedBox(height: 10),

              // New Password Field with Hint
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextFormField(
                    label: "Confirm Password",
                    hint: "Confirm Password",
                    controller: confPassword,
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    " (!@#\$&*~), min 8 chars",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // Retype Password Field with Hint
              const SizedBox(height: 40),

              //Change Password Button
              SizedBox(
                width: double.infinity,
                child: Obx(
                  () => ElevatedButton(
                    onPressed:
                        controller.isLoading.value
                            ? null
                            : () => controller.changeaccountPassword(
                              Get.find<AppController>()
                                      .customer
                                      .value
                                      ?.accountNo ??
                                  0,
                              newPassword.text.trim(),
                              confPassword.text.trim(),
                              widget.isInvester ? '2' : '1',
                            ),
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
    );
  }
}
