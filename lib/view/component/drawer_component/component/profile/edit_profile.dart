import 'dart:io';

import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:fx_crm/controller/auth_controller.dart';
import 'package:fx_crm/controller/profile_controller.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

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
    editProfileController.shortAddress.text =
        customer?.customerShortAddress ?? '';
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

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final customer = AppController.to.customer.value;
    return GetBuilder<ProfileController>(
      builder: (c) {
        return BackgroundContainer(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              surfaceTintColor: Colors.transparent,
              elevation: 0,
              centerTitle: true,
              title: const Text(
                'Edit Profile',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: formKey,
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
                            .firstWhereOrNull(
                              (e) => e.id.toString() == customerCountryId,
                            );

                        if (authController.selectedCountryName.value.isEmpty &&
                            initialCountry != null) {
                          authController.setSelectedCountry(
                            initialCountry.name,
                            initialCountry.phonecode,
                            initialCountry.id.toString(),
                          );
                        }

                        return CustomTextFormField(
                          label: 'Country',
                          readOnly: true,
                          icon: const Icon(
                            Icons.arrow_drop_down,
                            color: Colors.white,
                          ),
                          hint:
                              authController.selectedCountryName.value.isEmpty
                                  ? 'Please select a country'
                                  : authController.selectedCountryName.value,
                          onTap: () {
                            showCountryPicker(
                              context: context,
                              showPhoneCode: true,
                              onSelect: (Country country) {
                                final matchedCountry = authController
                                    .countryList
                                    .firstWhereOrNull(
                                      (e) =>
                                          e.name.toLowerCase() ==
                                          country.name.toLowerCase(),
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
                          validator:
                              (_) =>
                                  authController.selectedCountryId.value.isEmpty
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
                        initialValue:
                            customer?.isAuth == 1 ? "Enabled" : "Disabled",
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed:
                              editProfileController.isLoading.value
                                  ? null
                                  : () {
                                    if (!(formKey.currentState?.validate() ??
                                        false)) {
                                      return;
                                    }
                                    editProfileController.updateProfile(
                                      onSuccess: (d) {
                                        Get.back();
                                      },
                                    );
                                  },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child:
                              editProfileController.isLoading.value
                                  ? const CircularProgressIndicator()
                                  : const Text(
                                    'Update Profile',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }


  Future<void> _pickImage(ImageSource source) async {
    // Ask permissions
    await _requestPermission(source);

    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source, imageQuality: 85);

    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);
      editProfileController.setImageFile(imageFile);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No image selected.'),
          ),
        );
      }
    }
  }
  Future<bool> _requestPermission(ImageSource source) async {
    Permission permission;

    if (source == ImageSource.camera) {
      permission = Permission.camera;
    } else {
      permission = Platform.isIOS ? Permission.photos : Permission.storage;
    }

    var status = await permission.status;
    print("Initial Permission Status: $status");

    if (status.isGranted) {
      return true;
    }

    if (status.isDenied || status.isLimited || status.isRestricted) {
      final newStatus = await permission.request();
      print("New Permission Status: $newStatus");

      if (newStatus.isGranted) {
        return true;
      } else if (newStatus.isPermanentlyDenied) {
        return await _showPermissionDeniedDialog();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Permission denied. Please allow access.')),
        );
      }
    } else if (status.isPermanentlyDenied) {
      print("Permission Permanently Denied");
      return await _showPermissionDeniedDialog();
    }

    return false;
  }

  Future<bool> _showPermissionDeniedDialog() async {
    return await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permission Required'),
        content: const Text('Please allow access from settings to continue.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              openAppSettings();
              Navigator.of(context).pop(false);
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    ) ??
        false;
  }



  void _showImageSourceActionSheet() {
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: Icon(Icons.photo),
              title: Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildProfileCard(Customer? customer) {
    return Obx(() {
      final networkImage = customer?.image;
      final image = editProfileController.imageFile.value;
     print("initial image: $image");
     print("networkImage: $networkImage");
      return Container(
        width: double.infinity,
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
                  backgroundImage:
                      image != null
                          ? FileImage(image)
                          : (networkImage != null && networkImage.isNotEmpty
                                  ? NetworkImage(networkImage)
                                  : const AssetImage(
                                    'assets/images/default_user.png',
                                  ))
                              as ImageProvider,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: _showImageSourceActionSheet,
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.edit,
                        size: 18,
                        color: Colors.black,
                      ),
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
            Text(
              customer?.username ?? 'Username',
              style: const TextStyle(fontSize: 14, color: Colors.white70),
            ),
            const SizedBox(height: 4),
            Text(
              customer?.customerEmail ?? 'Email',
              style: const TextStyle(fontSize: 14, color: Colors.white70),
            ),
            const SizedBox(height: 4),
            Text(
              customer?.customerMobile ?? 'Mobile',
              style: const TextStyle(fontSize: 14, color: Colors.white70),
            ),
            const SizedBox(height: 16),
            // const Divider(),
            // _buildSocialLinkRow(
            //   Icons.language,
            //   'Website',
            //   'https://doforex.com',
            // ),
            // _buildSocialLinkRow(Icons.code, 'Github', 'Do forex'),
            // _buildSocialLinkRow(Icons.alternate_email, 'Twitter', '@Do-forex'),
            // _buildSocialLinkRow(Icons.camera_alt, 'Instagram', 'Do-forex'),
            // _buildSocialLinkRow(Icons.facebook, 'Facebook', 'Do-forex'),
          ],
        ),
      );
    });
  }

  Widget _buildSocialLinkRow(IconData icon, String label, String value) {
    return ListTile(
      dense: true,
      leading: Icon(icon, color: Colors.blueAccent),
      title: Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: Colors.white,
        ),
      ),
      trailing: Text(
        value,
        style: const TextStyle(fontSize: 12, color: Colors.white70),
      ),
    );
  }
}
