import 'package:flutter/material.dart';
import 'package:fx_crm/main.dart';
import 'package:fx_crm/utils/theme.dart';
import 'package:get/get.dart';
import '../controller/dashboard_controller.dart';
import '../database/dio/dio/dio_client.dart';

class CustomerProfileScreen extends StatefulWidget {
  const CustomerProfileScreen({super.key});

  @override
  State<CustomerProfileScreen> createState() => _CustomerProfileScreenState();
}

class _CustomerProfileScreenState extends State<CustomerProfileScreen> {
  late DashBoardController dashController;

  @override
  void initState() {
    super.initState();
    dashController = Get.put(DashBoardController(dioClient: dioClient));
    dashController.getUserProfile(); // Fetch profile data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,

      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: ThemeUtils.primaryColor,
        centerTitle: true,
        title: Text(
          "Customer Profile",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 23,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),
      body: SafeArea(
        child: Obx(() {
          if (dashController.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = dashController.profileData;

          if (data.isEmpty) {
            return const Center(
              child: Text(
                "No data found",
                style: TextStyle(color: Colors.white),
              ),
            );
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                /// Profile Info
                Column(
                  children: [
                    const CircleAvatar(
                      radius: 40,
                      backgroundColor: Colors.blueGrey,
                      child: Icon(Icons.person, size: 40, color: Colors.white),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      data["customer_name"] ?? '',
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
                    Text(
                      data["username"] ?? '',
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // /// Bank/BTC Details Card
                // _buildCard("Bank/BTC Details", {
                //   "Account Holder Name": data["bank_account_holder"] ?? '',
                //   "Account Number": data["account_number"] ?? '',
                //   "IFSC Code": data["ifsc_code"] ?? '',
                //   "Bank": data["bank_name"] ?? '',
                //   "Branch": data["branch_name"] ?? '',
                //   "Bankcode": data["bankcode"] ?? '',
                //   "Address": data["bank_address"] ?? '',
                //   "City": data["bank_city"] ?? '',
                //   "State": data["bank_state"] ?? '',
                //   "BTC Address": data["btc_address"] ?? '',
                //   "QBN Address": data["qbn_address"] ?? '',
                // }),

                // const SizedBox(height: 20),

                /// Personal Details Card
                _buildCard("Personal Details", {
                  "Username": data["username"] ?? '',
                  "Refer By": data["refer_by"] ?? '',
                  "Parent": data["parent"] ?? '',
                  "First Name": data["first_name"] ?? '',
                  "Last Name": data["last_name"] ?? '',
                  "Next of Kin": data["next_of_kin"] ?? '',
                  "Email": data["email"] ?? '',
                  "Mobile": data["customer_mobile"] ?? '',
                  "Address": data["customer_short_address"] ?? '',
                  "Address1": data["customer_address_1"] ?? '',
                  "Address2": data["customer_address_2"] ?? '',
                  "City": data["city"] ?? '',
                  "State": data["state"] ?? '',
                  "Country": data["country_text"] ?? '',
                  "Zip": data["zip"] ?? '',
                  "Company": data["company"] ?? '',
                  "Date of Birth": data["date_of_birth"] ?? '',
                }),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildCard(String title, Map<String, String> fields) {
    return Card(
      color: const Color(0xFF263238),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 6,
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
            ...fields.entries.map(
              (entry) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        entry.key,
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        entry.value,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
