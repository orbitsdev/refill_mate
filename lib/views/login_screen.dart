import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:refill_mate/controllers/auth_controller.dart';
import 'package:refill_mate/widgets/animated_button.dart';
import 'package:refill_mate/widgets/modal.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('RefillMate', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 32),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              const SizedBox(height: 24),
              Obx(() => AnimatedButton(
                label: 'Login',
                isLoading: authController.isLoading.value,
                onTap: () async {
                  final email = emailController.text.trim();
                  final password = passwordController.text;
                  if (email.isEmpty || password.isEmpty) {
                    Modal.showErrorModal(message: 'Please enter email and password.', showButton: true);
                    return;
                  }
                  final success = await authController.login(email, password);
                  if (success) {
                    Get.offAllNamed('/home-screen');
                  } else {
                    Modal.showErrorModal(message: 'Invalid credentials.', showButton: true);
                  }
                },
              )),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Get.toNamed('/registration-screen'),
                child: const Text('Don\'t have an account? Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}