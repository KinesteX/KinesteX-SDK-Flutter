import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kinestex_sdk_flutter/kinestex_sdk.dart';

class PlanDetailView extends StatefulWidget {
  final PlanModel plan;

  const PlanDetailView({super.key, required this.plan});

  @override
  State<PlanDetailView> createState() => _PlanDetailViewState();
}

class _PlanDetailViewState extends State<PlanDetailView> {
  final Map<String, bool> _expandedWeeks = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Plan Details")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Plan Image with Title Overlay
            Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: widget.plan.imgURL,
                  imageBuilder:
                      (context, image) => Container(
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                            image: image,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                  placeholder:
                      (_, __) => const SizedBox(
                        height: 200,
                        child: Center(child: CircularProgressIndicator()),
                      ),
                  errorWidget:
                      (_, __, ___) =>
                          const Icon(Icons.image_not_supported, size: 60),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: _HeaderView(
                    title: widget.plan.title,
                    categories: widget.plan.category.levels,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Category Description
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                widget.plan.category.description,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),

            const SizedBox(height: 20),

            // Levels (Weeks)
            ..._buildLevelWidgets(),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildLevelWidgets() {
    final sortedKeys =
        widget.plan.levels.keys.toList()..sort((a, b) => a.compareTo(b));

    return sortedKeys.map((key) {
      final level = widget.plan.levels[key]!;
      _expandedWeeks[key] ??= false;

      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Week Header
            InkWell(
              onTap: () {
                setState(() {
                  _expandedWeeks[key] = !_expandedWeeks[key]!;
                });
              },
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      level.title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Icon(
                      _expandedWeeks[key]!
                          ? Icons.keyboard_arrow_down
                          : Icons.keyboard_arrow_right,
                      color: Colors.blue,
                    ),
                  ],
                ),
              ),
            ),

            // Week Content (Collapsible)
            if (_expandedWeeks[key]!) ...[
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  level.description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
              const SizedBox(height: 12),

              // Days
              ..._buildDayWidgets(level.days),
            ],
          ],
        ),
      );
    }).toList();
  }

  List<Widget> _buildDayWidgets(Map<String, PlanDay> days) {
    final sortedDayKeys = days.keys.toList()..sort((a, b) => a.compareTo(b));

    return sortedDayKeys.map((dayKey) {
      final day = days[dayKey]!;
      return Padding(
        padding: const EdgeInsets.only(bottom: 12, left: 8, right: 8),
        child: _DayCard(day: day),
      );
    }).toList();
  }
}

class _HeaderView extends StatelessWidget {
  final String title;
  final Map<String, int> categories;

  const _HeaderView({required this.title, required this.categories});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Colors.black.withValues(alpha: 0.8), Colors.transparent],
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(12),
          bottomRight: Radius.circular(12),
        ),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              shadows: [Shadow(blurRadius: 10)],
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            "Category Levels:",
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.white),
          ),
          ...categories.entries.map((entry) {
            return Container(
              margin: const EdgeInsets.only(top: 4),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "${entry.key}: ",
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    "${entry.value}",
                    style: const TextStyle(color: Colors.blue),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _DayCard extends StatelessWidget {
  final PlanDay day;

  const _DayCard({required this.day});

  @override
  Widget build(BuildContext context) {
    final isRestDay = day.title == "Rest today";

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.withAlpha(40),
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Day Title
          Text(
            day.title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isRestDay ? Colors.yellow : null,
            ),
          ),
          const SizedBox(height: 8),

          // Day Description
          Text(day.description, style: TextStyle(color: Colors.grey[600])),

          // Workouts
          if (day.workouts != null && day.workouts!.isNotEmpty) ...[
            const SizedBox(height: 12),
            ...day.workouts!.map((workout) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _WorkoutCard(workout: workout),
              );
            }),
          ],
        ],
      ),
    );
  }
}

class _WorkoutCard extends StatelessWidget {
  final WorkoutSummary workout;

  const _WorkoutCard({required this.workout});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          // Workout Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "ID: ${workout.id}",
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  "Title: ${workout.title}",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Avg Cals: ${workout.calories ?? 0}",
                  style: const TextStyle(fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  "Total minutes: ${workout.totalMinutes}",
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ),

          // Workout Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CachedNetworkImage(
              imageUrl: workout.imgURL,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
              placeholder:
                  (_, __) => Container(
                    width: 100,
                    height: 100,
                    color: Colors.grey.withValues(alpha: 0.3),
                    child: const Center(child: CircularProgressIndicator()),
                  ),
              errorWidget:
                  (_, __, ___) => Container(
                    width: 100,
                    height: 100,
                    color: Colors.grey.withValues(alpha: 0.3),
                    child: const Icon(Icons.image_not_supported),
                  ),
            ),
          ),
        ],
      ),
    );
  }
}
