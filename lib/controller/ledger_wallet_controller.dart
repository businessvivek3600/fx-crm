import 'package:fx_crm/constant/api_constants.dart';
import 'package:fx_crm/models/wallet_ledger_model.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';

import '../main.dart';

class WalletLedgerController extends GetxController {
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var depositList = <WalletLedgerItem>[].obs;

  int _currentPage = 1;
  bool _hasMoreData = true;

  var ledgerList = <WalletLedgerItem>[].obs; // ✅ Correct type here
  var totalBalance = '0.00'.obs;

  Future<void> fetchWalletLedger() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final response = await dioClient.post(ApiConst.wallet_ledger);
      print("ApiConst.wallet_ledger response data---------");
      print(response.data);

      if (response.statusCode == 200 && response.data['status'] == 1) {
        final data = WalletLedgerResponse.fromJson(response.data);
        ledgerList.value = data.data?.ledger ?? [];
        totalBalance.value = data.data?.balance ?? '0.00';
      } else {
        errorMessage.value = response.data['message'] ?? 'Unknown error';
      }
    } catch (e) {
      errorMessage.value = 'Error: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
  
     

