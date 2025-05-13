import 'package:get/get.dart';

import '../../controller/session_controller.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(SessionController());
  }
}
