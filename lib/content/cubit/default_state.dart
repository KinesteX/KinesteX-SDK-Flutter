part of 'default_cubit.dart';

class DefaultState {
  final List<WorkoutModel> workouts;
  final List<ExerciseModel> exercises;
  final List<PlanModel> plans;
  final bool isLoading;

  DefaultState({
    this.workouts = const [],
    this.exercises = const [],
    this.plans = const [],
    this.isLoading = false,
  });

  DefaultState copyWith({
    List<WorkoutModel>? workouts,
    List<ExerciseModel>? exercises,
    List<PlanModel>? plans,
    bool? isLoading,
  }) {
    return DefaultState(
      workouts: workouts ?? this.workouts,
      exercises: exercises ?? this.exercises,
      plans: plans ?? this.plans,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}
