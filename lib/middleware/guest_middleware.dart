import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';

export 'package:get/get.dart';
export 'package:flutter/material.dart';
export 'package:refill_mate/controllers/auth_controller.dart';

class GuestMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final authController = Get.find<AuthController>();
    if (authController.currentUser.value != null) {
      return const RouteSettings(name: '/home-screen');
    }
    return null;
  }
}
