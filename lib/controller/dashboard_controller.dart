import 'package:get/get.dart';
import '../database/dio/dio/dio_client.dart';
import '../constant/api_constants.dart';

class DashBoardController extends GetxController {
  final DioClient dioClient;

  DashBoardController({required this.dioClient});

  var isLoading = false.obs;
  var dashboardData = {}.obs;

  Future<void> getDashboardData() async {
    try {
      isLoading.value = true;

      final response = await dioClient.post(ApiConst.home);
      print("-------------------------------");
      print(response.data);
      if (response.statusCode == 200 && response.data != null) {
        dashboardData.value = response.data;
      } else {
        Get.snackbar('Error', 'Failed to fetch dashboard data');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
