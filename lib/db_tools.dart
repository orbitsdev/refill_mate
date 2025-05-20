import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

/// A widget for development only: shows a button to delete the SQLite database and reseed gallons.
/// Only include this widget in debug builds!
class DBDevTools extends StatelessWidget {
  const DBDevTools({super.key});

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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: ElevatedButton.icon(
        icon: const Icon(Icons.delete_forever),
        label: const Text('Delete & Reseed Database'),
        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
        onPressed: () => _deleteDatabase(context),
      ),
    );
  }
}
