import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:fx_crm/view/component/auth/login_screen.dart';

import '../../../utils/theme.dart';
import '../../../widgets/bg_container.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  String accountType = 'Live';
  final _countries = ['India', 'USA', 'UK'];
  final _leverageOptions = ['1:50', '1:100', '1:200'];
  final _accountPlans = ['Standard', 'Premium', 'Pro'];
  String? selectedCountryCode;
  String? selectedCountryName;
  String? selectedCountry;
  String? selectedLeverage;
  String? selectedPlan;

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;
    return  BackgroundContainer(
      useAlternateBackground: true,
      child:  Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 40,),
                Text(
                  "Create Your Trading Account",
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                    foreground: Paint()
                      ..shader = LinearGradient(
                        colors: [
                          Colors.white,
                          primaryColor,
                          // Colors.white,
                        ],
                      ).createShader(
                        const Rect.fromLTWH(0.0, 0.0, 300.0, 70.0),
                      ),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  "Complete your details to get started",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey[400],
                  ),
                ),

                SizedBox(height: 30,),
                sectionTitle('Trading Account Type'),
                accountTypeTabs(),

                const SizedBox(height: 16),
                dropdownField(
                  hint: 'Select Account Plan',
                  value: selectedPlan,
                  items: _accountPlans,
                  onChanged: (val) => setState(() => selectedPlan = val),
                ),
                const SizedBox(height: 12),
                dropdownField(
                  hint: 'Select Leverage',
                  value: selectedLeverage,
                  items: _leverageOptions,
                  onChanged: (val) => setState(() => selectedLeverage = val),
                ),
                const SizedBox(height: 25),
                sectionTitle('Personal Details'),
                textField(hint: 'Enter First Name'),
                const SizedBox(height: 12),
                textField(hint: 'Enter Last Name'),
                const SizedBox(height: 25),
                sectionTitle('Contact Details'),
                textField(hint: 'Enter Email Id'),
                const SizedBox(height: 12),
                GestureDetector(
                  onTap: () {
                    showCountryPicker(
                      context: context,
                      showPhoneCode: true,
                      onSelect: (Country country) {
                        setState(() {
                          selectedCountryName = country.name;
                          selectedCountryCode = country.phoneCode;
                        });
                        print('Selected Country: $selectedCountryName, Code: $selectedCountryCode');
                      },
                    );
                  },
                  child: AbsorbPointer(
                    child: TextFormField(
                      decoration: InputDecoration(
                        hintText: selectedCountryName ?? 'Select Country',
                        suffixIcon: const Icon(Icons.arrow_drop_down),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),
                textField(hint: 'Enter Phone Number'),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onPressed: () {},
                    child: const Text(
                      'Register',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: RichText(
                    text: TextSpan(
                      text: 'Already have an account?  ',
                      style: TextStyle(color: Colors.white70),
                      children: [
                        TextSpan(
                          text: 'Login',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // TODO: Replace with actual navigation
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) => LoginScreen(),));
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
      ),
    );
  }

  Widget sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500,color: Colors.white,
      ),),
    );
  }
  Widget accountTypeTabs() {
    final types = ['Live', 'Demo', 'IB Account'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: types.map((type) {
        final isSelected = accountType == type;
        return Expanded(
          child: GestureDetector(
            onTap: () => setState(() => accountType = type),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: isSelected ? ThemeUtils.primaryColor : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isSelected ? ThemeUtils.primaryColor : Colors.grey.shade400,
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


  Widget textField({required String hint}) {
    return TextFormField(
      decoration: InputDecoration(hintText: hint),
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
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
    );
  }
}
