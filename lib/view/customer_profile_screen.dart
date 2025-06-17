import 'package:flutter/material.dart';
import 'package:fx_crm/utils/theme.dart';
import 'package:fx_crm/view/component/drawer_component/component/profile/edit_profile.dart';
import 'package:fx_crm/widgets/bg_container.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';

import '../controller/dashboard_controller.dart';

class CustomerProfileScreen extends StatefulWidget {
  const CustomerProfileScreen({super.key});

  @override
  State<CustomerProfileScreen> createState() => _CustomerProfileScreenState();
}

class _CustomerProfileScreenState extends State<CustomerProfileScreen> {
  final DashBoardController dashBoardController = Get.put(DashBoardController());

  @override
  void initState() {
    super.initState();
    dashBoardController.getUserProfile();
  }


  @override
  Widget build(BuildContext context) {
    return BackgroundContainer(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          backgroundColor: ThemeUtils.primaryColor,
          centerTitle: true,
          title: const Text(
            "Customer Profile", 
            style: TextStyle(
              color: Colors.white,
              fontSize: 23,
              fontWeight: FontWeight.bold,
              letterSpacing: 1.2,
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                // TODO: Handle edit tap here
                // Example:
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => EditProfileScreen()),
                );
              },
              child: Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Icon(Icons.edit_note, color: Colors.white, size: 28),
              ),
            ),
          ],
        ),

        body: SafeArea(
          child:Obx(() {
            final customer = dashBoardController.profileData.value;
            final networkImage = customer?.image;
            if (dashBoardController.isLoading.value) {
              return _buildShimmer();
            }

            if (customer == null) {
              return const Center(child: Text('No profile data available.'));
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  /// Profile Info
                  Column(
                    children: [
                     CircleAvatar(
                        radius: 40,
                        backgroundImage:   (networkImage != null && networkImage.isNotEmpty
                            ? NetworkImage(networkImage)
                            : const AssetImage(
                          'assets/images/default_user.png',
                        ))
                        as ImageProvider,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        customer.customerName ?? '',
                        style: const TextStyle(
                          fontSize: 18,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        customer.username ?? '',
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  /// Personal Details Card

                  _buildCard("Personal Details", {
                    "Username": customer.username ?? '',
                    "Refer By": customer.referencerUsername ?? '',
                    "First Name": customer.firstName ?? '',
                    "Last Name": customer.lastName ?? '',
                    "Gender": customer.gender ?? '',
                    "Email": customer.customerEmail ?? '',
                    "Mobile": customer.customerMobile ?? '',
                    "Address": customer.customerShortAddress ?? '',
                    "Address1": customer.customerAddress1 ?? '',
                    "Address2": customer.customerAddress2 ?? '',
                    "City": customer.city ?? '',
                    "State": customer.state ?? '',
                    "Country": customer.countryText ?? '',
                    "Zip": customer.zip ?? '',
                    "Company": customer.company ?? '',
                    "Date of Birth": customer.dateOfBirth ?? '',
                  }),

                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildShimmer() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey.shade800,
                highlightColor: Colors.grey.shade700,
                child: const CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.white,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(2, (index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6.0),
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey.shade800,
                        highlightColor: Colors.grey.shade700,
                        child: Container(
                          width: double.infinity,
                          height: 14,
                          color: Colors.white,
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Shimmer.fromColors(
            baseColor: Colors.grey.shade800,
            highlightColor: Colors.grey.shade700,
            child: Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(String title, Map<String, String> fields) {
    final entries = fields.entries.toList();

    return  Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 12),
            ...List.generate(entries.length, (index) {
              final entry = entries[index];
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 0,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 4,
                          child: Text(
                            entry.key,
                            style: const TextStyle(color: Colors.white70),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          flex: 2,
                          child: Text(
                            entry.value,
                            style: const TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (index < entries.length - 1)
                    const Divider(
                      color: Colors.white24,
                      thickness: 1,
                      height: 12,
                    ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
