import 'package:fx_crm/constant/api_constants.dart';
import 'package:fx_crm/models/wallet_deposit_model.dart';
import 'package:fx_crm/models/wallet_ledger_model.dart';
import 'package:get/get.dart';

import '../main.dart';

class WalletLedgerController extends GetxController {
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var depositList = <FundRequestItem>[].obs;
  var currentPage = 1;
  var hasMoreData = true.obs;

  var ledgerList = <WalletLedgerItem>[].obs; // ✅ Correct type here
  var totalBalance = '0.00'.obs;

  int wallerLedgerPage = 1;

  Future<void> fetchWalletLedger({
    bool refresh = true,
    bool loading = false,
  }) async {
    try {
      if (refresh) {
        wallerLedgerPage = 1;
        ledgerList.clear();
      }
      errorMessage.value = '';
      isLoading.value = loading;
      var data = {'page': wallerLedgerPage.toString()};
      print("ApiConst.wallet_ledger data--------- $data");

      final response = await dioClient.post(ApiConst.wallet_ledger, data: data);
      print("ApiConst.wallet_ledger response data---------");
      print(response.data);

      if (response.statusCode == 200 && response.data['status'] == 1) {
        final data = WalletLedgerResponse.fromJson(response.data);
        totalBalance.value = data.data?.balance ?? '0.00';
        var list = data.data?.ledger ?? [];
        if (list.isNotEmpty) wallerLedgerPage++;
        if (wallerLedgerPage == 1) {
          ledgerList.value = list;
        } else {
          ledgerList.addAll(list);
        }
      } else {
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

  // Future<void> fetchWalletDeposits({
  //   bool refresh = true,
  //   bool loading = false,
  // }) async {
  //   try {
  //     if (refresh) {
  //       currentPage = 1;
  //       depositList.clear();
  //     }

  //     errorMessage.value = '';
  //     isLoading.value = loading;

  //     final data = {'page': currentPage.toString()};
  //     print("ApiConst.wallet_deposit data request: $data");

  //     final response = await dioClient.post(ApiConst.wallet_deposit, data: data);
  //     print("ApiConst.wallet_deposit response data:");
  //     print(response.data);

  //     if (response.statusCode == 200 && response.data['status'] == 1) {
  //       final parsed = FundRequestResponse.fromJson(response.data);
  //       final List<FundRequestItem> list = parsed.data?.fundRequest ?? [];

  //       if (list.isNotEmpty) currentPage++;
  //       if (refresh) {
  //         depositList.value = list;
  //       } else {
  //         depositList.addAll(list);
  //       }

  //       hasMoreData.value = list.isNotEmpty;
  //     } else {
  //       errorMessage.value = response.data['message'] ?? 'Unknown error';
  //       hasMoreData.value = false;
  //     }
  //   } catch (e) {
  //     errorMessage.value = 'Error: $e';
  //   } finally {
  //     isLoading.value = false;
  //   }
  // }

  // void loadMore() {
  //   if (hasMoreData.value && !isLoading.value) {
  //     fetchWalletDeposits(refresh: false);
  //   }
  // }

  // void refreshDeposits() {
  //   currentPage = 1;
  //   hasMoreData.value = true;
  //   fetchWalletDeposits(refresh: true);
  // }
}
