import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:refill_mate/controllers/auth_controller.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'dart:io';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();
    return Obx(() {
      final user = authController.currentUser.value;
      return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFB3E5FC), Color(0xFFE1F5FE)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              backgroundColor: Colors.transparent,
              expandedHeight: 180,
              pinned: true,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
                title: Row(
                  children: [
                    if (user?.profilePhotoPath != null && user!.profilePhotoPath!.isNotEmpty)
                      CircleAvatar(
                        radius: 22,
                        backgroundImage: user.profilePhotoPath!.startsWith('assets/')
                            ? AssetImage(user.profilePhotoPath!) as ImageProvider
                            : FileImage(File(user.profilePhotoPath!)),
                      )
                    else
                      const CircleAvatar(
                        radius: 22,
                        backgroundImage: AssetImage('assets/images/default_avatar.png'),
                      ),
                    const SizedBox(width: 12),
                    Text(
                      'Hi, ${user?.name ?? 'User'}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        shadows: [Shadow(color: Colors.black26, blurRadius: 2)],
                      ),
                    ),
                  ],
                ),
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF29B6F6), Color(0xFFB3E5FC)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        right: 24,
                        top: 40,
                        child: Opacity(
                          opacity: 0.18,
                          child: Icon(Icons.water_drop, size: 120, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                IconButton(
                  icon: const Icon(Icons.person, color: Colors.white),
                  onPressed: () => Get.toNamed('/profile-screen'),
                  tooltip: 'Profile',
                ),
                IconButton(
                  icon: const Icon(Icons.logout, color: Colors.white),
                  onPressed: () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (context) => AlertDialog(
                        backgroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        title: const Text('Confirm Logout', style: TextStyle(color: Color(0xFF01579B), fontWeight: FontWeight.bold)),
                        content: const Text('Are you sure you want to log out?', style: TextStyle(color: Color(0xFF01579B))),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(false),
                            child: const Text('Cancel', style: TextStyle(color: Color(0xFF29B6F6))),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF29B6F6)),
                            onPressed: () => Navigator.of(context).pop(true),
                            child: const Text('Logout', style: TextStyle(color: Colors.white)),
                          ),
                        ],
                      ),
                    );
                    if (confirmed == true) {
                      await authController.logout();
                      Get.offAllNamed('/login-screen');
                    }
                  },
                  tooltip: 'Logout',
                ),
              ],
            ),
            SliverPadding(
              padding: const EdgeInsets.all(24),
              sliver: MultiSliver(
                children: [
                  const SizedBox(height: 24),
                  Text(
                    'Welcome, ${user?.name ?? 'User'}!',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: const Color(0xFF01579B)),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add_circle_outline),
                    label: const Text('Create New Request'),
                    onPressed: () => Get.toNamed('/create-request-screen'),
                    style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.list_alt),
                    label: const Text('My Requests'),
                    onPressed: () => Get.toNamed('/my-request-screen'),
                    style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(48)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  });
  }
}