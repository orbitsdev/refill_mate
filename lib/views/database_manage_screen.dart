import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import '../controllers/auth_controller.dart';

/// Screen for admin to manage the database: delete, reseed, clear requests, etc.
class DatabaseManageScreen extends StatelessWidget {
  const DatabaseManageScreen({super.key});

  Future<void> _deleteDatabase(BuildContext context) async {
    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, 'refillmate.db');
      if (await File(path).exists()) {
        await deleteDatabase(path);
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Database deleted. Restart app to reseed.')),
        );
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Database file not found.')),
        );
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error deleting database: $e')),
      );
    }
  }

  Future<void> _clearRequests(BuildContext context) async {
    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, 'refillmate.db');
      final db = await openDatabase(path);
      await db.delete('requests');
      await db.delete('request_items');
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All requests cleared.')),
      );
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error clearing requests: $e')),
      );
    }
  }

  Future<void> _reseedGallons(BuildContext context) async {
    try {
      final dbPath = await getDatabasesPath();
      final path = join(dbPath, 'refillmate.db');
      final db = await openDatabase(path);
      await db.delete('gallons');
      // Re-run the seedGallons logic
      final gallons = [
        {
          'name': 'Standard Jug Gallon',
          'price': 25.0,
          'image_path': 'assets/images/jug-gallon.png',
          'description': 'Standard 5-gallon water jug, common for refilling in the Philippines.'
        },
        {
          'name': 'Water Container',
          'price': 25.0,
          'image_path': 'assets/images/water-container.png',
          'description': 'Durable water container, suitable for household and commercial use.'
        },
      ];
      for (final g in gallons) {
        await db.insert('gallons', g);
      }
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gallons reseeded.')),
      );
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error reseeding gallons: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final email = authController.currentUser.value?.email;
    if (email != 'admin@email.com') {
      return const Scaffold(
        body: Center(
          child: Text('Access denied: Admins only', style: TextStyle(color: Colors.red)),
        ),
      );
    }
    return Scaffold(
      appBar: AppBar(title: const Text('Database Management')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.delete_forever),
              label: const Text('Delete & Reseed Database'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () => _deleteDatabase(context),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.cleaning_services),
              label: const Text('Clear All Requests'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
              onPressed: () => _clearRequests(context),
            ),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.refresh),
              label: const Text('Reseed Gallons'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
              onPressed: () => _reseedGallons(context),
            ),
          ],
        ),
      ),
    );
  }
}
