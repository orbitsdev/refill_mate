import 'package:get/get.dart';
import 'package:refill_mate/controllers/auth_controller.dart';
import 'package:refill_mate/controllers/request_controller.dart';

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(AuthController(), permanent: true);
    Get.put(RequestController(), permanent: true);
  }
}
