import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:kinestex_sdk_flutter/kinestex_sdk.dart';

class EquipmentSection extends StatelessWidget {
  final List<EquipmentModel> equipment;

  const EquipmentSection({super.key, required this.equipment});

  @override
  Widget build(BuildContext context) {
    if (equipment.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Equipment", style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        ...equipment.map((e) => _equipmentTile(context, e)),
      ],
    );
  }

  Widget _equipmentTile(BuildContext context, EquipmentModel e) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: e.thumbnailUrl,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              placeholder: (_, __) => const SizedBox(
                width: 60,
                height: 60,
                child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
              ),
              errorWidget: (_, __, ___) =>
                  const Icon(Icons.fitness_center, size: 40),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  e.title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                if (e.description.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    e.description,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
                if (e.homeAlternative.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    "Home alternative: ${e.homeAlternative}",
                    style: const TextStyle(
                      fontSize: 12,
                      fontStyle: FontStyle.italic,
                      color: Colors.blueGrey,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
