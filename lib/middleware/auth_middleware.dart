
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:refill_mate/controllers/auth_controller.dart';

class AuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final authController = Get.find<AuthController>();

    if (!authController.isAuthenticated.value) {
      return const RouteSettings(name: '/login-screen');
    }
    return null;
  }
}
