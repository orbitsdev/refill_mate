import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:refill_mate/controllers/auth_controller.dart';
import 'package:refill_mate/widgets/animated_button.dart';
import 'package:refill_mate/widgets/modal.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  String? profilePhotoPath;
  final AuthController authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    final user = authController.currentUser.value;
    nameController = TextEditingController(text: user?.name ?? '');
    emailController = TextEditingController(text: user?.email ?? '');
    profilePhotoPath = user?.profilePhotoPath;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 48,
                    backgroundImage: profilePhotoPath != null && profilePhotoPath!.isNotEmpty
                        ? (profilePhotoPath!.startsWith('assets/')
                            ? AssetImage(profilePhotoPath!) as ImageProvider
                            : FileImage(File(profilePhotoPath!)))
                        : const AssetImage('assets/images/default_avatar.png'),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 4,
                    child: InkWell(
                      onTap: () async {
                        final picker = ImagePicker();
                        final picked = await showModalBottomSheet<XFile?>(
                          context: context,
                          builder: (context) => SafeArea(
                            child: Wrap(
                              children: [
                                ListTile(
                                  leading: const Icon(Icons.photo),
                                  title: const Text('Choose from Gallery'),
                                  onTap: () async {
                                    final img = await picker.pickImage(source: ImageSource.gallery);
                                    Navigator.pop(context, img);
                                  },
                                ),
                                ListTile(
                                  leading: const Icon(Icons.camera_alt),
                                  title: const Text('Take a Photo'),
                                  onTap: () async {
                                    final img = await picker.pickImage(source: ImageSource.camera);
                                    Navigator.pop(context, img);
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                        if (picked != null) {
                          setState(() {
                            profilePhotoPath = picked.path;
                          });
                        }
                      },
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.grey[200],
                        child: const Icon(Icons.camera_alt, size: 20, color: Colors.black),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
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
              // Optionally: Add photo picker here
              Obx(() => AnimatedButton(
                label: 'Update Profile',
                isLoading: authController.isLoading.value,
                onTap: () async {
                  final name = nameController.text.trim();
                  final email = emailController.text.trim();

                  final success = await authController.updateProfile(name, email, profilePhotoPath);
                  if (success) {
                    Modal.showSuccessModal(message: 'Profile updated!', showButton: true);
                  } else {
                    Modal.showErrorModal(message: 'Update failed.', showButton: true);
                  }
                },
              )),
            ],
          ),
        ),
      ),
    );
  }
}