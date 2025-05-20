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

  // WalletItem

  /*     Future<void> fetchWalletLedger({int page = 1}) async {
      try {
        isLoading.value = true;
        errorMessage.value = '';

        final response = await dioClient.post(
          ApiConst.wallet_ledger,
          data: {'page': page.toString()},
        );

        if (response.statusCode == 200 && response.data['status'] == 1) {
          final data = WalletLedgerResponse.fromJson(response.data);

          if (page == 1) {
            ledgerList.assignAll(data.data?.ledger ?? []);
          } else {
            ledgerList.addAll(data.data?.ledger ?? []);
          }

          totalBalance.value = data.data?.balance ?? '0.00';
          hasMoreData.value = (data.data?.ledger?.isNotEmpty ?? false);
          currentPage = page;
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
        fetchWalletLedger(page: currentPage + 1);
      }
    }

    void refreshLedger() {
      currentPage = 1;
      hasMoreData.value = true;
      fetchWalletLedger(page: 1);
    } */
}
