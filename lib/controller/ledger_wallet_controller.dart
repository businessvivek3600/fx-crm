import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:fx_crm/constant/api_constants.dart';
import 'package:fx_crm/models/account_statement.dart';
import 'package:fx_crm/models/payment_informaton_model.dart';
import 'package:fx_crm/models/wallet_deposit_model.dart';
import 'package:fx_crm/models/wallet_ledger_model.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../main.dart';
import '../models/get_fund_ways.dart';
import '../models/withdraw_history_model.dart';

class WalletLedgerController extends GetxController {
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var depositList = <FundRequestItem>[].obs;
  var currentPage = 0;
  var hasMoreData = true.obs;

  var ledgerList = <WalletLedgerItem>[].obs;
  var withDrawHistory = <WithdrawHistory>[].obs;
  var totalBalance = '0.00'.obs;
  var transferWalletList = <FundOption>[].obs;
  var accountStatement = <AccountStatement>[].obs;
  var paymentList = <PaymentInformation>[].obs;

  int wallerLedgerPage = 0;
  int accountStatementPage = 0;

  Future<void> fetchWalletLedger({
    bool refresh = true,
    bool loading = false,
  }) async {
    try {
      if (refresh) {
        wallerLedgerPage = 0;
        ledgerList.clear();
      }
      errorMessage.value = '';
      isLoading.value = loading;
      var data = {'page': wallerLedgerPage.toString()};
      final response = await dioClient.post(ApiConst.wallet_ledger, data: data);
      if (response.statusCode == 200) {
        final data = WalletLedgerResponse.fromJson(response.data);
        if (wallerLedgerPage == 0) {
          totalBalance.value = data.data?.balance ?? '0.00';
        }
        var list = data.data?.ledger ?? [];
        if (list.isNotEmpty) wallerLedgerPage++;
        if (wallerLedgerPage == 0) {
          ledgerList.value = list;
        } else {
          ledgerList.addAll(list);
        }
      } else {
        // print("this---is show");
        errorMessage.value = response.data['message'] ?? 'Unknown error';
      }
    } catch (e) {
      errorMessage.value = 'Error: $e';
    } finally {
      isLoading.value = false;
    }
    // print(
    //   "$runtimeType [fetchWalletLedger]  list length: ${ledgerList.length}",
    // );
  }

  ///----------------------------------Fetch Wallet Deposit-------------------------
  Future<void> fetchWalletDeposits({
    bool refresh = true,
    bool loading = false,
  }) async {
    try {
      if (refresh) {
        currentPage = 0;
        depositList.clear();
      }

      errorMessage.value = '';
      isLoading.value = loading;

      final data = {'page': currentPage.toString()};
      print("ApiConst.wallet_deposit data request: $data");

      final response = await dioClient.post(
        ApiConst.wallet_deposit,
        data: data,
      );
      print("ApiConst.wallet_deposit response data:");
      print(response.data);

      if (response.statusCode == 200 && response.data['status'] == 1) {
        final parsed = FundRequestResponse.fromJson(response.data);
        final List<FundRequestItem> list = parsed.data?.fundRequest ?? [];

        if (list.isNotEmpty) currentPage++;
        if (refresh) {
          depositList.value = list;
        } else {
          depositList.addAll(list);
        }

        hasMoreData.value = list.isNotEmpty;
      } else {
        errorMessage.value = response.data['message'] ?? 'Unknown error';
        hasMoreData.value = false;
      }
    } catch (e) {
      errorMessage.value = 'Error: $e';
    } finally {
      isLoading.value = false;
    }
  }

  ///-----------PaymentInformation----------------------
  Future<PaymentInformation?> fetchPaymentInformation({
    required String txnId,
  }) async {
    isLoading.value = true;
    PaymentInformation? paymentInfo;
    try {
      final formData = dio.FormData.fromMap({'order_id': txnId});

      final response = await dioClient.post(
        ApiConst.payment_information,
        data: formData,
      );

      if (response.statusCode == 200 && response.data['status'] == 1) {
        paymentInfo = PaymentInformation.fromJson(response.data);

        Get.snackbar(
          'Success',
          'Payment info fetched!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          response.data['message'] ?? 'Failed to fetch payment info',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
    return paymentInfo;
  }
  //------------------deposit--funds-------------------

  Future<String?> depositFundRequest({
    required String paymentMethod,
    required String amount,
  }) async {
    isLoading.value = true;
    String? orderId;
    try {
      final formData = dio.FormData.fromMap({
        'payment_type': paymentMethod,
        'amount': amount,
      });

      final response = await dioClient.post(
        ApiConst.deposit_fund,
        data: formData,
      );

      orderId = response.data['order_id'];
      if (response.statusCode == 200 &&
          response.data['status'] == 1 &&
          orderId != null &&
          orderId != '') {
        fetchWalletDeposits(loading: false);
        Get.snackbar(
          'Success',
          'Payment info fetched!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          response.data['message'] ?? 'Failed to fetch payment info',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
    return orderId;
  }

  ///--------------WithDraw -- History ----------------
  Future<void> getWithDrawList({
    bool refresh = true,
    bool loading = false,
  }) async {
    try {
      if (refresh) {
        wallerLedgerPage = 0;
        withDrawHistory.clear();
      }
      errorMessage.value = '';
      isLoading.value = loading;

      var data = {'page': wallerLedgerPage.toString()};
      final response = await dioClient.post(
        ApiConst.withDrawHistory,
        data: data,
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        if (responseData['status'] == 1 && responseData['data'] != null) {
          List<dynamic> list = responseData['data'];

          var newList = list.map((e) => WithdrawHistory.fromJson(e)).toList();

          wallerLedgerPage++;
          if (refresh) {
            withDrawHistory.value = newList;
          } else {
            withDrawHistory.addAll(newList);
          }
        } else {
          errorMessage.value = responseData['message'] ?? 'Failed to load data';
        }
      } else {
        errorMessage.value = response.statusMessage ?? 'Unknown error';
      }
    } catch (e) {
      errorMessage.value = 'Error: $e';
    } finally {
      isLoading.value = false;
    }
  }

  ///--------------------Wallet Transfer----------------

  Future<void> addWalletFund({
    required String accountNo,
    required String amount,
    required String accountType,
  }) async {
    isLoading.value = true;

    try {
      // Extract the selected account plan cod

      dio.FormData formData = dio.FormData.fromMap({
        'account_no': accountNo,
        'amount': amount,
        'type': accountType,
      });
      print("DATA-------------TRANSFER WALLET");
      print(formData.fields);
      final response = await dioClient.post(
        ApiConst.transferWallet,
        data: formData,
      );
      print(response.data);
      if (response.statusCode == 200 && response.data['status'] == 1) {
        Get.snackbar(
          'Success',
          response.data['message'] ?? 'Account created successfully!',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      } else {
        Get.snackbar(
          'Error',
          response.data['message'] ?? 'Failed to create account',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print(e.toString());
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  ///--------------------GET FUND WAYS----------------
  Future<void> getFundWays() async {
    isLoading.value = true;
    try {
      final response = await dioClient.post(ApiConst.fundWays);
      print("ApiConst.GET FUND WAYS response data---------");
      print(response.data);
      if (response.statusCode == 200 && response.data['status'] == 1) {
        final data = response.data['data'];

        // Parse transfer_wallet list
        final List walletList = data['transfer_wallet'] ?? [];
        transferWalletList.value =
            walletList.map((e) => FundOption.fromJson(e)).toList();
      } else {
        Get.snackbar(
          'Error',
          response.data['message'] ?? 'Failed to fetch Fund Ways',
          snackPosition: SnackPosition.TOP,
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
    } finally {
      isLoading.value = false;
    }
  }

  ///------------------------GET ACCOUNT STATEMENT ------------------------
  Future<void> getAccountStatement({
    bool refresh = true,
    bool loading = false,
  }) async {
    try {
      if (refresh) {
        accountStatementPage = 0;
        accountStatement.clear();
      }

      final data = {'page': accountStatementPage.toString()};
      final response = await dioClient.post(
        ApiConst.accountStatement,
        data: data,
      );

      if (response.statusCode == 200) {
        final dynamic rawData = response.data['data'];
        print(rawData);
        if (rawData is List && rawData.isNotEmpty) {
          final List<dynamic> dataList = rawData;
          accountStatement.addAll(
            dataList.map((e) => AccountStatement.fromJson(e)).toList(),
          );
          accountStatementPage++;
        } else {
          // No more data
          print("No more data available");
        }
      } else {
        Get.snackbar(
          'Error',
          response.data['message'] ?? 'Failed to fetch Account Statement',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      print(e.toString());
      Get.snackbar(
        'Error',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  ///-------------GET  _ STATUS _ COLOR-----------------
  // Function to map numeric status to text
  String statusText(String? status) {
    switch (status) {
      case '0':
        return 'Pending';
      case '1':
        return 'Complete';
      case '2':
        return 'Rejected';
      default:
        return 'Unknown';
    }
  }

  // Function to get color based on status
  Color statusColor(String? status) {
    switch (status) {
      case '0':
        return Colors.orange; // Pending
      case '1':
        return Colors.green; // Complete
      case '2':
        return Colors.red; // Rejected
      default:
        return Colors.black;
    }
  }

  ///-----------------------TIme formate
  String formatDate(String inputDate) {
    try {
      DateTime dateTime = DateTime.parse(inputDate);

      // Convert to desired format: "1:29 5 May 25"
      String formatted = DateFormat('h:mma dMMMyy').format(dateTime);
      return formatted;
    } catch (e) {
      return inputDate; // fallback if parsing fails
    }
  }
}
