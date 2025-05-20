import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:refill_mate/controllers/auth_controller.dart';
import 'package:refill_mate/widgets/animated_button.dart';
import 'package:refill_mate/widgets/modal.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthController authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Create Account', style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 32),
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              const SizedBox(height: 16),
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
                label: 'Register',
                isLoading: authController.isLoading.value,
                onTap: () async {
                  final name = nameController.text.trim();
                  final email = emailController.text.trim();
                  final password = passwordController.text;
                  if (name.isEmpty || email.isEmpty || password.isEmpty) {
                    Modal.showErrorModal(message: 'Please fill all fields.', showButton: true);
                    return;
                  }
                  final success = await authController.register(name, email, password);
                  if (success) {
                    Modal.showSuccessModal(message: 'Registration successful!', showButton: true, onClose: () {
                      Get.offAllNamed('/login-screen');
                    });
                  } else {
                    Modal.showErrorModal(message: 'Registration failed. Email may already be used.', showButton: true);
                  }
                },
              )),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Get.back(),
                child: const Text('Already have an account? Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}