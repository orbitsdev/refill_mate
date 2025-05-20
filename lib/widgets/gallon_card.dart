import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:refill_mate/models/gallon_model.dart';

class GallonCard extends StatelessWidget {
  final Gallon gallon;
  final int quantity;
  final VoidCallback onAdd;
  final VoidCallback onRemove;
  const GallonCard({
    Key? key,
    required this.gallon,
    required this.quantity,
    required this.onAdd,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Animate(
      effects: [FadeEffect(duration: 300.ms), ScaleEffect(duration: 300.ms)],
      child: Card(
        margin: const EdgeInsets.all(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(gallon.imagePath, height: 64, width: 64, fit: BoxFit.contain),
              const SizedBox(height: 8),
              Text(gallon.name, style: Theme.of(context).textTheme.titleMedium),
              Text(gallon.description, style: Theme.of(context).textTheme.bodySmall),
              const SizedBox(height: 8),
              Text('₱${gallon.price.toStringAsFixed(2)}', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.blue)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(icon: const Icon(Icons.remove), onPressed: onRemove),
                  Text(quantity.toString(), style: Theme.of(context).textTheme.titleMedium),
                  IconButton(icon: const Icon(Icons.add), onPressed: onAdd),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}