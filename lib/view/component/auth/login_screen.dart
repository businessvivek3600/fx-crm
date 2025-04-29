import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fx_crm/view/component/auth/signup_screen.dart';
import 'package:get/get.dart';
import '../../../constant/api_constants.dart';
import '../../../controller/auth_controller.dart';
import '../../../main.dart';
import '../../../models/country_model.dart';
import '../../../widgets/bg_container.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthController authController = Get.put(
    AuthController(dioClient: dioClient),
  );
  @override
  void initState() {
    super.initState();
    getCountryList();
  }
  Future<void> getCountryList() async {
    try {

      final response = await dioClient.get(ApiConst.country); // Replace with actual endpoint

      print("response Country ----${response.data}");
      if (response.statusCode == 200 && response.data['status'] == 1) {
        final List countriesData = response.data['countries'] ?? [];

        authController.countryList.value = countriesData
            .map((countryJson) => Country.fromJson(countryJson))
            .toList();
      } else {
        Get.snackbar(
          'Failed to Fetch Countries',
          response.data['message'] ?? 'Something went wrong',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }
  @override
  Widget build(BuildContext context) {
    return BackgroundContainer(
      useAlternateBackground: true,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),

                // Login title
                Text(
                  "LOGIN",
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,

                    color: Colors.white, // or any custom color
                  ),
                ),

                const SizedBox(height: 40),

                // Username field

                textField(
                  hint: 'Username',
                  controller: authController.usernameController,
                  icon: Icons.person_outline,
                ),
                const SizedBox(height: 16),

                // Password field
                Obx(
                  () => textField(
                    controller: authController.passwordController,
                    hint: 'Password',
                    icon: Icons.lock_outline,
                    isPassword: true,
                  ),
                ),
                const SizedBox(height: 8),

                // Forgot Password link
                Align(
                  alignment: Alignment.centerRight,
                  child: GestureDetector(
                    onTap: () {
                      // TODO: Navigate to forgot password page
                    },
                    child: Text(
                      'Forgot password?',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Or sign in with
                // Text(
                //   'Or sign in with',
                //   style: Theme.of(context).textTheme.bodyMedium,
                // ),
                //
                // const SizedBox(height: 20),

                // Sign In Button
                Obx(
                  () => SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed:
                          authController.isLoading.value
                              ? null
                              : () {
                                authController.login();
                              },
                      child:
                      authController.isLoading.value
                          ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                          : const Text(
                                'Sign in',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                ),
                              ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Register and Forgot User Id Links
                Column(
                  children: [
                    RichText(
                      text: TextSpan(
                        text: "Don't have an account? ",
                        style: const TextStyle(color: Colors.white70),
                        children: [
                          TextSpan(
                            text: "Register here",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                            recognizer:
                                TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) => SignupScreen(),
                                      ),
                                    );
                                  },
                          ),
                        ],
                      ),
                    ),
                    // const SizedBox(height: 6),
                    // RichText(
                    //   text: TextSpan(
                    //     text: "Forgot User Id? ",
                    //     style: const TextStyle(color: Colors.black87),
                    //     children: [
                    //       TextSpan(
                    //         text: "Forgot User Id",
                    //         style: TextStyle(
                    //           color: ThemeUtils.primaryColor,
                    //           fontWeight: FontWeight.bold,
                    //         ),
                    //         recognizer: TapGestureRecognizer()
                    //           ..onTap = () {
                    //             // TODO: Navigate to forgot user id page
                    //           },
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget textField({
    required String hint,
    IconData? icon,
    required TextEditingController controller,
    bool isPassword = false,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: isPassword ? authController.isPasswordHidden.value : false,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: icon != null ? Icon(icon) : null,
        suffixIcon:
            isPassword
                ? IconButton(
                  icon: Icon(
                    authController.isPasswordHidden.value
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: Colors.grey,
                  ),
                  onPressed: () {
                    authController.isPasswordHidden.toggle();
                  },
                )
                : null,
      ),
    );
  }
}
