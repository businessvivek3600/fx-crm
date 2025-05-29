import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:fx_crm/view/component/auth/login_screen.dart';
import 'package:fx_crm/widgets/custom_text_form.dart';
import 'package:get/get.dart';

import '../../../controller/app_controller.dart';
import '../../../controller/auth_controller.dart';
import '../../../main.dart';
import '../../../utils/theme.dart';
import '../../../widgets/bg_container.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final AuthController authController = Get.put(
    AuthController(),
  );

  String accountType = 'Live';
  // final _countries = ['India', 'USA', 'UK'];
  // final _leverageOptions = ['1:50', '1:100', '1:200'];
  // final _accountPlans = ['Standard', 'Premium', 'Pro'];
  final TextEditingController countryController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String? selectedLeverage;
  String? selectedPlan;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return BackgroundContainer(
      useAlternateBackground: true,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Obx(() {
          final isSignupDisabled = AppController.to.company.value?.signupEnable == '0';

          return Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (isSignupDisabled)
                      Column(
                        children: [
                          SizedBox(height: 40,),
                          Container(
                            padding: const EdgeInsets.all(12),
                            margin: const EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                              color: Colors.redAccent,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Text(
                              'Signup service is currently disabled.',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),

                    isSignupDisabled ?  SizedBox(height: 10):SizedBox(height: 40),
                    Text(
                      "Create Your Trading Account",
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                        foreground: Paint()
                          ..shader = LinearGradient(
                            colors: [Colors.white, primaryColor],
                          ).createShader(const Rect.fromLTWH(0.0, 0.0, 300.0, 70.0)),
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      "Complete your details to get started",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey[400],
                      ),
                    ),

                    const SizedBox(height: 30),
                    sectionTitle('Personal Details'),
                    const SizedBox(height: 16),
                    CustomTextFormField(
                      label: 'First Name',
                      hint: 'Enter your first name',
                      controller: firstNameController,
                      readOnly: isSignupDisabled,
                      validator: (value) => value == null || value.isEmpty ? 'First name is required' : null,
                    ),
                    const SizedBox(height: 12),
                    CustomTextFormField(
                      label: 'Last Name',
                      hint: 'Enter your last name',
                      controller: lastNameController,
                      readOnly: isSignupDisabled,
                      validator: (value) => value == null || value.isEmpty ? 'Last name is required' : null,
                    ),
                    const SizedBox(height: 25),
                    sectionTitle('Contact Details'),
                    CustomTextFormField(
                      label: 'Email',
                      hint: 'Enter your email',
                      controller: emailController,
                      readOnly: isSignupDisabled,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Email is required';
                        final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
                        if (!emailRegex.hasMatch(value)) return 'Enter a valid email';
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    CustomTextFormField(
                      label: 'Country',
                      readOnly: true,
                      hint: authController.selectedCountryName.value.isEmpty
                          ? 'Please select a country'
                          : authController.selectedCountryName.value,
                      onTap: isSignupDisabled
                          ? null
                          : () {
                        showCountryPicker(
                          context: context,
                          showPhoneCode: true,
                          onSelect: (Country country) {
                            authController.setSelectedCountry(
                              country.name,
                              country.phoneCode,
                            );
                          },
                        );
                      },
                      validator: (_) => authController.selectedCountryId.value.isEmpty
                          ? 'Please select a country'
                          : null,
                    ),
                    const SizedBox(height: 12),
                    CustomTextFormField(
                      label: 'Phone Number',
                      hint: 'Enter your phone number',
                      controller: phoneController,
                      readOnly: isSignupDisabled,
                      validator: (value) {
                        if (value == null || value.isEmpty) return 'Phone number is required';
                        if (!RegExp(r'^\d+$').hasMatch(value)) return 'Only numbers allowed';
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                        onPressed: isSignupDisabled
                            ? null
                            : () {
                          final isFormValid = _formKey.currentState!.validate();
                          final isCountrySelected = authController.selectedCountryId.value.isNotEmpty;

                          if (!isCountrySelected) {
                            authController.countryError.value = 'Please select a country';
                          }

                          if (isFormValid && isCountrySelected) {
                            authController.register(
                              firstName: firstNameController.text,
                              lastName: lastNameController.text,
                              customerEmail: emailController.text,
                              countryCode: authController.selectedCountryId.value,
                              customerMobile: phoneController.text,
                              accountType: accountType,
                            );
                          }
                        },
                        child: const Text('Register', style: TextStyle(color: Colors.white)),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: RichText(
                        text: TextSpan(
                          text: 'Already have an account?  ',
                          style: const TextStyle(color: Colors.white70),
                          children: [
                            TextSpan(
                              text: 'Login',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => const LoginScreen(),
                                  ));
                                },
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }


  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget accountTypeTabs() {
    final types = ['Live', 'Demo'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children:
          types.map((type) {
            final isSelected = accountType == type;
            return Expanded(
              child: GestureDetector(
                onTap: () => setState(() => accountType = type),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color:
                        isSelected
                            ? ThemeUtils.primaryColor
                            : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color:
                          isSelected
                              ? ThemeUtils.primaryColor
                              : Colors.grey.shade400,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      type,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black87,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
    );
  }

  Widget textField({
    required String label,
    required TextEditingController controller,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey),
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget dropdownField({
    required String hint,
    required String? value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(hintText: hint),
      value: value,
      onChanged: onChanged,
      items:
          items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
    );
  }
}
