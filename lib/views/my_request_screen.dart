import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:refill_mate/controllers/request_controller.dart';
import 'package:refill_mate/controllers/auth_controller.dart';
import 'package:refill_mate/models/request_modal.dart';
import 'package:refill_mate/widgets/modal.dart';
import 'package:refill_mate/widgets/emty_state.dart';

class MyRequestScreen extends StatefulWidget {
  const MyRequestScreen({Key? key}) : super(key: key);

  @override
  State<MyRequestScreen> createState() => _MyRequestScreenState();
}

class _MyRequestScreenState extends State<MyRequestScreen> {
  final RequestController requestController = Get.find<RequestController>();
  final AuthController authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    final user = authController.currentUser.value;
    if (user != null) {
      requestController.fetchRequests(user.id!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Requests')),
      body: Obx(() {
        if (requestController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        final requests = requestController.myRequests;
        if (requests.isEmpty) {
          return EmtyState(
            message: 'You have no requests yet.',
            icon: Icons.inbox,
            buttonText: 'Create Request',
            onButtonPressed: () {
              // Navigate to the request creation screen
              Navigator.of(context).pushNamed('/create-request');
            },
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.all(12),
          itemCount: requests.length,
          itemBuilder: (context, index) {
            final req = requests[index];
            final isPending = req.status == RequestStatus.pending;
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Text('Request #${req.id} - ${req.datetime.toLocal().toString().substring(0, 16)}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Status: ${isPending ? 'Pending' : 'Completed'}', style: TextStyle(color: isPending ? Colors.orange : Colors.green)),
                    if (req.items != null)
                      ...req.items!.map((item) => Text('Gallon ID: ${item.gallonId} x${item.quantity}')),
                  ],
                ),
                trailing: isPending
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            tooltip: 'Edit',
                            onPressed: () {
                              // Optionally, implement edit functionality
                              Modal.showInfoModal(message: 'Edit functionality can be added here.');
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            tooltip: 'Delete',
                            onPressed: () {
                              Modal.showConfirmationModal(
                                message: 'Delete this request?',
                                onConfirm: () async {
                                  final success = await requestController.deleteRequest(req.id!);
                                  if (success) {
                                    Modal.showSuccessModal(message: 'Request deleted!', showButton: true);
                                    final user = authController.currentUser.value;
                                    if (user != null) {
                                      requestController.fetchRequests(user.id!);
                                    }
                                  } else {
                                    Modal.showErrorModal(message: 'Delete failed.', showButton: true);
                                  }
                                },
                                isDangerousAction: true,
                              );
                            },
                          ),
                        ],
                      )
                    : null,
              ),
            );
          },
        );
      }),
    );
  }
}