

import 'package:get/get.dart';

class NotificationController extends GetxController {
  final RxInt unreadCount = 0.obs;

  void incrementUnreadCount() {
    unreadCount.value++;
  }

  void resetUnreadCount() {
    unreadCount.value = 0;
  }

  void setUnreadCount(int count) {
    unreadCount.value = count;
  }
}
