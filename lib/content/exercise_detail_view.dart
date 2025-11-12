import 'package:flutter/material.dart';
import 'package:kinestex_sdk_flutter/kinestex_sdk.dart';
import 'package:kinestex_flutter_demo/content/exercise_card.dart';

class ExerciseDetailView extends StatelessWidget {
  final ExerciseModel exercise;

  const ExerciseDetailView({super.key, required this.exercise});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(exercise.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: ExerciseCard(
          exercise: exercise,
          index: 0,
        ),
      ),
    );
  }
}
