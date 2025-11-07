import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:kinestex_flutter_demo/content/body_parts_wrap.dart';
import 'package:kinestex_flutter_demo/content/exercise_card.dart';
import 'package:kinestex_sdk_flutter/kinestex_sdk.dart';

class WorkoutDetailView extends StatelessWidget {
  final WorkoutModel workout;

  const WorkoutDetailView({super.key, required this.workout});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(workout.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Workout Image
            CachedNetworkImage(
              imageUrl: workout.imgURL,
              imageBuilder: (context, image) => Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(image: image, fit: BoxFit.cover),
                ),
              ),
              placeholder: (_, __) => const SizedBox(
                height: 200,
                child: Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (_, __, ___) =>
                  const Icon(Icons.image_not_supported, size: 60),
            ),

            const SizedBox(height: 16),

            Text(
              workout.title,
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 8),
            Text(workout.description),

            const SizedBox(height: 16),

            // Details row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _detailItem("Category", workout.category ?? "N/A"),
                _detailItem("Duration", "${workout.totalMinutes ?? 0} min"),
                _detailItem("Calories", "${workout.totalCalories ?? 0} kcal"),
              ],
            ),

            const Divider(height: 32),

            // Body Parts wrap
            Text(
              "Targeted Body Parts",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            BodyPartsWrap(items: workout.bodyParts),

            const Divider(height: 32),

            // Exercises list
            Text(
              "Exercise Sequence",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 12),

            ...List.generate(
              workout.sequence.length,
              (i) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: ExerciseCard(
                  exercise: workout.sequence[i],
                  index: i + 1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailItem(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        Text(value),
      ],
    );
  }
}
