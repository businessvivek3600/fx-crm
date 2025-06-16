import 'dart:io';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:fx_crm/controller/auth_controller.dart';
import 'package:fx_crm/controller/profile_controller.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

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
  final ProfileController editProfileController = Get.put(ProfileController());
  final AuthController authController = Get.put(AuthController());
  final Rx<File?> pickedImage = Rx<File?>(null);
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage() async {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: const Text('Camera'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final XFile? picked = await _picker.pickImage(source: ImageSource.camera);
                  if (picked != null) {
                    final file = File(picked.path);
                    pickedImage.value = file;
                    editProfileController.setImageFile(file);
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Gallery'),
                onTap: () async {
                  Navigator.of(context).pop();
                  final XFile? picked = await _picker.pickImage(source: ImageSource.gallery);
                  if (picked != null) {
                    final file = File(picked.path);
                    pickedImage.value = file;
                    editProfileController.setImageFile(file);
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    final customer = AppController.to.customer.value;

    editProfileController.firstname.text = customer?.firstName ?? '';
    editProfileController.lastname.text = customer?.lastName ?? '';
    editProfileController.dateOfBirth.text = customer?.dateOfBirth ?? '';
    editProfileController.company.text = customer?.company ?? '';
    editProfileController.state.text = customer?.state ?? '';
    editProfileController.city.text = customer?.city ?? '';
    editProfileController.shortAddress.text = customer?.customerShortAddress ?? '';
    editProfileController.address1.text = customer?.customerAddress1 ?? '';
    editProfileController.address2.text = customer?.customerAddress2 ?? '';
    editProfileController.zip.text = customer?.zip ?? '';

    if (customer?.countryText != null && customer?.countryCode != null) {
      authController.setSelectedCountry(
        customer!.countryText!,
        customer.countryCode!.toString(),
      );
    }
  }

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
              _buildProfileCard(customer),
              const SizedBox(height: 24),
              const Text(
                'Personal Details',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              CustomTextFormField(
                controller: editProfileController.firstname,
                label: 'First Name *',
                hint: 'First Name',
              ),
              const SizedBox(height: 12),
              CustomTextFormField(
                controller: editProfileController.lastname,
                label: 'Last Name *',
                hint: 'Last Name',
              ),
              const SizedBox(height: 12),
              CustomTextFormField(
                controller: editProfileController.nextofKin,
                label: 'Next of Kin (Optional)',
                hint: 'Next of Kin',
              ),
              const SizedBox(height: 12),
              CustomTextFormField(
                onTap: () => editProfileController.pickDate(context),
                controller: editProfileController.dateOfBirth,
                label: 'Date Of Birth *',
                hint: 'dd/mm/yyyy',
                isDate: true,
              ),
              const SizedBox(height: 12),
              CustomTextFormField(
                controller: editProfileController.company,
                label: 'Company (Optional)',
                hint: 'Company',
              ),
              const SizedBox(height: 12),
              Obx(() {
                if (authController.countryList.isEmpty) {
                  return const CircularProgressIndicator();
                }

                final customerCountryId = customer?.country;
                final initialCountry = authController.countryList
                    .firstWhereOrNull((e) => e.id.toString() == customerCountryId);

                if (authController.selectedCountryName.value.isEmpty && initialCountry != null) {
                  authController.setSelectedCountry(
                    initialCountry.name,
                    initialCountry.phonecode,
                    initialCountry.id.toString(),
                  );
                }

                return CustomTextFormField(
                  label: 'Country',
                  readOnly: true,
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.white),
                  hint: authController.selectedCountryName.value.isEmpty
                      ? 'Please select a country'
                      : authController.selectedCountryName.value,
                  onTap: () {
                    showCountryPicker(
                      context: context,
                      showPhoneCode: true,
                      onSelect: (Country country) {
                        final matchedCountry = authController.countryList.firstWhereOrNull(
                          (e) => e.name.toLowerCase() == country.name.toLowerCase(),
                        );

                        if (matchedCountry != null) {
                          authController.setSelectedCountry(
                            matchedCountry.name,
                            matchedCountry.phonecode,
                            matchedCountry.id.toString(),
                          );
                        } else {
                          authController.setSelectedCountry(
                            country.name,
                            country.phoneCode,
                            '',
                          );
                        }
                      },
                    );
                  },
                  validator: (_) => authController.selectedCountryId.value.isEmpty
                      ? 'Please select a country'
                      : null,
                );
              }),
              const SizedBox(height: 12),
              CustomTextFormField(
                controller: editProfileController.state,
                label: 'State',
                hint: 'State',
              ),
              const SizedBox(height: 12),
              CustomTextFormField(
                controller: editProfileController.city,
                label: 'City',
                hint: 'City',
              ),
              const SizedBox(height: 12),
              CustomTextFormField(
                controller: editProfileController.shortAddress,
                label: 'House/Flat No. *',
                hint: 'House/Flat No.',
              ),
              const SizedBox(height: 12),
              CustomTextFormField(
                controller: editProfileController.address1,
                label: 'Address 1 *',
                hint: 'Address 1',
              ),
              const SizedBox(height: 12),
              CustomTextFormField(
                controller: editProfileController.address2,
                label: 'Address 2 (Optional)',
                hint: 'Address 2',
              ),
              const SizedBox(height: 12),
              CustomTextFormField(
                controller: editProfileController.zip,
                label: 'Zip',
                hint: 'Zip',
              ),
              const SizedBox(height: 12),
              CustomTextFormField(
                label: 'Google Authentication *',
                hint: 'Disabled',
                readOnly: true,
                initialValue: customer?.isAuth == 1 ? "Enabled" : "Disabled",
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    await editProfileController.updateProfile();
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
    return Obx(() {
      final networkImage = customer?.image;
      final image = pickedImage.value;

      return Container(
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white24,
                  backgroundImage: image != null
                      ? FileImage(image)
                      : (networkImage != null && networkImage.isNotEmpty
                          ? NetworkImage(networkImage)
                          : const AssetImage('assets/images/default_user.png')) as ImageProvider,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: pickImage,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.edit, size: 18, color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              customer?.customerName ?? 'Name',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 4),
            Text(customer?.username ?? 'Username',
                style: const TextStyle(fontSize: 14, color: Colors.white70)),
            const SizedBox(height: 4),
            Text(customer?.customerEmail ?? 'Email',
                style: const TextStyle(fontSize: 14, color: Colors.white70)),
            const SizedBox(height: 4),
            Text(customer?.customerMobile ?? 'Mobile',
                style: const TextStyle(fontSize: 14, color: Colors.white70)),
            const SizedBox(height: 16),
            const Divider(),
            _buildSocialLinkRow(Icons.language, 'Website', 'https://doforex.com'),
            _buildSocialLinkRow(Icons.code, 'Github', 'Do forex'),
            _buildSocialLinkRow(Icons.alternate_email, 'Twitter', '@Do-forex'),
            _buildSocialLinkRow(Icons.camera_alt, 'Instagram', 'Do-forex'),
            _buildSocialLinkRow(Icons.facebook, 'Facebook', 'Do-forex'),
          ],
        ),
      );
    });
  }

  Widget _buildSocialLinkRow(IconData icon, String label, String value) {
    return ListTile(
      dense: true,
      leading: Icon(icon, color: Colors.blueAccent),
      title: Text(label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white)),
      trailing: Text(value, style: const TextStyle(fontSize: 12, color: Colors.white70)),
    );
  }
}
