import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:refill_mate/controllers/auth_controller.dart';
import 'package:refill_mate/core/app_binding.dart';
import 'package:refill_mate/views/create_request_screen.dart';
import 'package:refill_mate/views/home_screen.dart';
import 'package:refill_mate/views/login_screen.dart';
import 'package:refill_mate/views/my_request_screen.dart';
import 'package:refill_mate/views/profile_screen.dart';
import 'package:refill_mate/views/registration_screen.dart';
import 'package:refill_mate/views/database_manage_screen.dart';
import 'package:refill_mate/views/splash_screen.dart';
import 'package:refill_mate/middleware/auth_middleware.dart';
import 'package:refill_mate/middleware/guest_middleware.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  AppBinding().dependencies();

  final authController = Get.find<AuthController>();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'RefillMate',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
        scaffoldBackgroundColor: const Color(0xFFE9F6FF), // Soft blue
        cardColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF4FC3F7), // Light blue
          foregroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF29B6F6), // Accent blue
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
            elevation: 2,
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFF29B6F6), width: 2),
          ),
        ),
        cardTheme: CardTheme(
          color: Colors.white,
          elevation: 3,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        ),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 32, color: Color(0xFF01579B)),
          headlineMedium: TextStyle(fontWeight: FontWeight.bold, fontSize: 24, color: Color(0xFF01579B)),
          titleLarge: TextStyle(fontWeight: FontWeight.w600, fontSize: 20, color: Color(0xFF01579B)),
          bodyLarge: TextStyle(fontSize: 18, color: Color(0xFF01579B)),
          bodyMedium: TextStyle(fontSize: 16, color: Color(0xFF01579B)),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/splash-screen',
      getPages: [
        GetPage(
          name: '/splash-screen',
          page: () => const SplashScreen(),
        ),
        GetPage(
          name: '/login-screen',
          page: () => const LoginScreen(),
          middlewares: [GuestMiddleware()],
        ),
        GetPage(
          name: '/registration-screen',
          page: () => const RegistrationScreen(),
          middlewares: [GuestMiddleware()],
        ),
        GetPage(
          name: '/home-screen',
          page: () => const HomeScreen(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: '/profile-screen',
          page: () => const ProfileScreen(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: '/create-request-screen',
          page: () => const CreateRequestScreen(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: '/my-request-screen',
          page: () => const MyRequestScreen(),
          middlewares: [AuthMiddleware()],
        ),
        GetPage(
          name: '/database-manage',
          page: () => const DatabaseManageScreen(),
          middlewares: [AuthMiddleware()],
        ),
      ],
      
    );
  }
}
