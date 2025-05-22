import 'package:flutter/material.dart';
import 'package:fx_crm/constant/api_constants.dart';
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
  int wallerLedgerPage = 0;

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
      print("ApiConst.wallet_ledger data--------- $data");

      final response = await dioClient.post(ApiConst.wallet_ledger, data: data);
      print("ApiConst.wallet_ledger response data---------");
      print(response.data);

      if (response.statusCode == 200 ) {
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
        print("this---is show");
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

  Future<void> fetchWalletDeposits({
    bool refresh = true,
    bool loading = false,
  }) async {
    try {
      if (refresh) {
        currentPage = 1;
        depositList.clear();
      }

      errorMessage.value = '';
      isLoading.value = loading;

      final data = {'page': currentPage.toString()};
      print("ApiConst.wallet_deposit data request: $data");

      final response = await dioClient.post(ApiConst.wallet_deposit, data: data);
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

  void loadMore() {
    if (hasMoreData.value && !isLoading.value) {
      fetchWalletDeposits(refresh: false);
    }
  }


    void refreshLedger() {
      currentPage = 1;
      hasMoreData.value = true;
      fetchWalletLedger();
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
      final response = await dioClient.post(ApiConst.withDrawHistory, data: data);

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
