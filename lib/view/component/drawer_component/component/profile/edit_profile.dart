import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:fx_crm/controller/auth_controller.dart';
import 'package:fx_crm/controller/profile_controller.dart';
import 'package:fx_crm/main.dart';
import 'package:get/get.dart';

import '../../../../../controller/app_controller.dart';
import '../../../../../models/customer_model.dart';
import '../../../../../widgets/bg_container.dart';
import '../../../../../widgets/custom_text_form.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  ProfileController editProfileController = Get.put(ProfileController());
  AuthController authController = Get.put(AuthController(dioClient: dioClient));
  @override
  Widget build(BuildContext context) {
    final customer = AppController.to.customer.value;
    return BackgroundContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            'Edit Profile',
            style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
          ),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Profile Card
              _buildProfileCard(customer),

              const SizedBox(height: 24),

              /// Personal Details Title
              const Text(
                'Personal Details',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),

              /// Input Fields (Pre-filled from customer data)
              CustomTextFormField(
                controller: editProfileController.firstname,
                label: 'First Name *',
                hint: 'First Name',
                initialValue: customer?.firstName ?? '',
              ),
              const SizedBox(height: 12),
              CustomTextFormField(
                controller: editProfileController.lastname,
                label: 'Last Name *',
                hint: 'Last Name',
                initialValue: customer?.lastName ?? '',
              ),
              const SizedBox(height: 12),
              CustomTextFormField(
                controller: editProfileController.nextofKin,
                label: 'Next of Kin (Optional)',
                hint: 'Next of Kin',
              ),
              const SizedBox(height: 12),
              CustomTextFormField(
                controller: editProfileController.email,
                label: 'Email *',
                hint: 'Email Address',
                initialValue: customer?.customerEmail ?? '',
              ),
              const SizedBox(height: 12),

              // Container(
              //   padding: const EdgeInsets.symmetric(horizontal: 12),
              //   decoration: BoxDecoration(
              //     color: Colors.white,
              //     borderRadius: BorderRadius.circular(8),
              //     border: Border.all(color: Colors.grey.shade300),
              //   ),
              //   child: Icon(Icons.calendar_month, color: Colors.grey.shade400),
              // ),
              CustomTextFormField(
                onTap: () {
                  editProfileController.pickDate(context);
                },
                controller: editProfileController.dateOfBirth,
                label: 'Date Of Birth *',
                hint: 'dd/mm/yyyy',
                isDate: true,
                initialValue: customer?.dateOfBirth ?? '',
              ),

              const SizedBox(height: 12),
              CustomTextFormField(
                controller: editProfileController.company,
                label: 'Company (Optional)',
                hint: 'Company',
                initialValue: customer?.company ?? '',
              ),
              const SizedBox(height: 12),
              Obx(
                () => CustomTextFormField(
                  label: 'Country',
                  readOnly: true,
                  textStyle: TextStyle(color: Colors.black),
                  hint:
                      authController.selectedCountryName.value.isEmpty
                          ? 'Please select a country'
                          : authController.selectedCountryName.value,
                  onTap: () {
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
                  validator:
                      (_) =>
                          authController.selectedCountryId.value.isEmpty
                              ? 'Please select a country'
                              : null,
                ),
              ),

              // CustomTextFormField(
              //   controller: editProfileController.country,
              //   label: 'Country *',
              //   hint: 'Country',
              //   initialValue: customer?.countryText ?? '',
              // ),
              const SizedBox(height: 12),
              CustomTextFormField(
                controller: editProfileController.state,
                label: 'State',
                hint: 'State',
                initialValue: customer?.state ?? '',
              ),
              const SizedBox(height: 12),
              CustomTextFormField(
                controller: editProfileController.city,
                label: 'City',
                hint: 'City',
                initialValue: customer?.city ?? '',
              ),
              const SizedBox(height: 12),
              CustomTextFormField(
                controller: editProfileController.shortAddress,
                label: 'House/Flat No. *',
                hint: 'House/Flat No.',
                initialValue: customer?.customerShortAddress ?? '',
              ),
              const SizedBox(height: 12),
              CustomTextFormField(
                controller: editProfileController.address1,
                label: 'Address 1 *',
                hint: 'Address 1',
                initialValue: customer?.customerAddress1 ?? '',
              ),
              const SizedBox(height: 12),
              CustomTextFormField(
                controller: editProfileController.address2,
                label: 'Address 2 (Optional)',
                hint: 'Address 2',
                initialValue: customer?.customerAddress2 ?? '',
              ),
              const SizedBox(height: 12),
              CustomTextFormField(
                controller: editProfileController.zip,
                label: 'Zip',
                hint: 'Zip',
                initialValue: customer?.zip ?? '',
              ),
              const SizedBox(height: 12),
              CustomTextFormField(
                label: 'Google Authentication *',
                hint: 'Disabled',
                readOnly: true,
                initialValue: customer?.isAuth == 1 ? "Enabled" : "Disabled",
              ),

              const SizedBox(height: 24),

              /// Update Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    // print("object");
                    await editProfileController.updateProfile();
                    // TODO: Save profile changes
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Update Profile',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard(Customer? customer) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.grey.shade100,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Column(
          children: [
            /// Avatar
            CircleAvatar(
              radius: 40,
              backgroundImage: NetworkImage(
                customer?.image ??
                    'https://images.unsplash.com/photo-1633332755192-727a05c4013d?fm=jpg&q=60&w=3000',
              ),
              backgroundColor: Colors.transparent,
            ),
            const SizedBox(height: 12),

            /// Name and Info
            Text(
              customer?.customerName ?? 'Name',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              customer?.username ?? 'Username',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              customer?.customerEmail ?? 'Email',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              customer?.customerMobile ?? 'Mobile',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),

            const SizedBox(height: 16),
            const Divider(),

            /// Social Links (dummy for now)
            _buildSocialLinkRow(
              Icons.language,
              'Website',
              'https://doforex.com',
            ),
            _buildSocialLinkRow(Icons.code, 'Github', 'Doforex'),
            _buildSocialLinkRow(Icons.alternate_email, 'Twitter', '@Doforex'),
            _buildSocialLinkRow(Icons.camera_alt, 'Instagram', 'Doforex'),
            _buildSocialLinkRow(Icons.facebook, 'Facebook', 'Doforex'),
          ],
        ),
      ),
    );
  }

  Widget _buildSocialLinkRow(IconData icon, String label, String value) {
    return ListTile(
      dense: true,
      leading: Icon(icon, color: Colors.blueAccent),
      title: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
      trailing: Text(value, style: const TextStyle(fontSize: 12)),
    );
  }
}
