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
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/logo.png', height: 90),
              const SizedBox(height: 20),
              Text(
                'RefillMate',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              TextField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email),
                ),
              ),
              const SizedBox(height: 16),
              StatefulBuilder(
                builder: (context, setState) => TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility),
                      onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  obscureText: _obscurePassword,
                ),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: Obx(() => AnimatedButton(
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
              ),
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