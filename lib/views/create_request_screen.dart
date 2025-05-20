import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:refill_mate/controllers/request_controller.dart';
import 'package:refill_mate/controllers/auth_controller.dart';
import 'package:refill_mate/models/request_modal.dart';
import 'package:refill_mate/widgets/gallon_card.dart';
import 'package:refill_mate/widgets/animated_button.dart';
import 'package:refill_mate/widgets/modal.dart';
import 'package:refill_mate/widgets/emty_state.dart';

class CreateRequestScreen extends StatefulWidget {
  const CreateRequestScreen({Key? key}) : super(key: key);

  @override
  State<CreateRequestScreen> createState() => _CreateRequestScreenState();
}

class _CreateRequestScreenState extends State<CreateRequestScreen> {
  final RequestController requestController = Get.find<RequestController>();
  final AuthController authController = Get.find<AuthController>();
  Map<int, int> quantities = {};

  @override
  void initState() {
    super.initState();
    requestController.fetchGallons();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Water Refill Request')),
      body: Obx(() {
        if (requestController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        final gallons = requestController.gallons;
        if (gallons.isEmpty) {
          return EmtyState(
            message: 'No gallons available at the moment.',
            icon: Icons.water_drop_outlined,
            buttonText: 'Refresh',
            onButtonPressed: () => requestController.fetchGallons(),
          );
        }
        return Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              Expanded(
                child: MasonryGridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  itemCount: gallons.length,
                  itemBuilder: (context, index) {
                    final gallon = gallons[index];
                    final qty = quantities[gallon.id ?? index] ?? 0;
                    return GallonCard(
                      gallon: gallon,
                      quantity: qty,
                      onAdd: () {
                        setState(() {
                          quantities[gallon.id ?? index] = qty + 1;
                        });
                      },
                      onRemove: () {
                        setState(() {
                          if (qty > 0) quantities[gallon.id ?? index] = qty - 1;
                        });
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              Obx(() => AnimatedButton(
                label: 'Submit Request',
                isLoading: requestController.isLoading.value,
                onTap: () async {
                  final user = authController.currentUser.value;
                  if (user == null) {
                    Modal.showError(context, 'You must be logged in.');
                    return;
                  }
                  final items = quantities.entries
                      .where((e) => e.value > 0)
                      .map((e) => RequestItem(
                            requestId: 0,
                            gallonId: e.key,
                            quantity: e.value,
                          ))
                      .toList();
                  if (items.isEmpty) {
                    Modal.showError(context, 'Please select at least one gallon.');
                    return;
                  }
                  final req = Request(
                    userId: user.id!,
                    datetime: DateTime.now(),
                    status: RequestStatus.pending,
                  );
                  final success = await requestController.createRequest(req, items);
                  if (success) {
                    Modal.showSuccess(context, 'Request submitted!');
                    setState(() {
                      quantities.clear();
                    });
                  } else {
                    Modal.showError(context, 'Failed to submit request.');
                  }
                },
              )),
            ],
          ),
        );
      }),
    );
  }
}