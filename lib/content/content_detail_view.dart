import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinestex_flutter_demo/content/cubit/default_cubit.dart';
import 'package:kinestex_flutter_demo/content/exercise_detail_view.dart';
import 'package:kinestex_flutter_demo/content/plan_detail_view.dart';
import 'package:kinestex_flutter_demo/content/workout_detail_view.dart';
import 'package:kinestex_sdk_flutter/kinestex_sdk.dart';

class ContentDetailView extends StatefulWidget {
  const ContentDetailView({
    super.key,
    required this.title,
    required this.contentType,
  });

  final String title;
  final ContentType contentType;

  @override
  State<ContentDetailView> createState() => _ContentDetailViewState();
}

class _ContentDetailViewState extends State<ContentDetailView> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DefaultCubit, DefaultState>(
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(CupertinoIcons.back),
            ),
            centerTitle: true,
            title: Text(
              widget.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          body: SafeArea(child: _buildContent(state)),
        );
      },
    );
  }

  Widget _buildContent(DefaultState state) {
    switch (widget.contentType) {
      case ContentType.workout:
        return _buildWorkoutGrid(state.workouts);
      case ContentType.exercise:
        return _buildExerciseGrid(state.exercises);
      case ContentType.plan:
        return _buildPlanGrid(state.plans);
    }
  }

  Widget _buildWorkoutGrid(List<WorkoutModel> workouts) {
    if (workouts.isEmpty) {
      return const Center(child: Text("No workouts found!"));
    }

    return GridView.builder(
      itemCount: workouts.length,
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 11 / 9,
      ),
      itemBuilder: (context, index) {
        final workout = workouts[index];
        final imageUrl = Uri.decodeFull(workout.imgURL);

        return InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => WorkoutDetailView(workout: workout),
            ),
          ),
          child: Card(
            margin: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error, color: Colors.red),
                            const SizedBox(height: 8),
                            Text('Error: $error', textAlign: TextAlign.center),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    workout.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildExerciseGrid(List<ExerciseModel> exercises) {
    if (exercises.isEmpty) {
      return const Center(child: Text("No exercises found!"));
    }

    return GridView.builder(
      itemCount: exercises.length,
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 8 / 10,
      ),
      itemBuilder: (context, index) {
        final exercise = exercises[index];
        final imageUrl = Uri.decodeFull(exercise.thumbnailURL);

        return InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ExerciseDetailView(exercise: exercise),
            ),
          ),
          child: Card(
            margin: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error, color: Colors.red),
                            const SizedBox(height: 8),
                            Text('Error: $error', textAlign: TextAlign.center),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    exercise.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPlanGrid(List<PlanModel> plans) {
    if (plans.isEmpty) {
      return const Center(child: Text("No plans found!"));
    }

    return GridView.builder(
      itemCount: plans.length,
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 11 / 9,
      ),
      itemBuilder: (context, index) {
        final plan = plans[index];
        final imageUrl = Uri.decodeFull(plan.imgURL);

        return InkWell(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PlanDetailView(plan: plan),
            ),
          ),
          child: Card(
            margin: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: imageUrl,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error, color: Colors.red),
                            const SizedBox(height: 8),
                            Text('Error: $error', textAlign: TextAlign.center),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    plan.title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
