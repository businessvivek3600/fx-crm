import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class NotificationController extends GetxController {
  final _box = GetStorage();
  final RxInt unreadCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    int storedCount = _box.read('unreadCount') ?? 0;
    unreadCount.value = storedCount;
  }

  void incrementUnreadCount() {
    unreadCount.value++;
    _box.write('unreadCount', unreadCount.value);
  }

  void resetUnreadCount() {
    unreadCount.value = 0;
    _box.write('unreadCount', 0);
  }

  void setUnreadCount(int count) {
    unreadCount.value = count;
    _box.write('unreadCount', count);
  }
}
