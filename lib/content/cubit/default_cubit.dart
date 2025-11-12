import 'package:bloc/bloc.dart';
import 'package:kinestex_sdk_flutter/kinestex_sdk.dart';

part 'default_state.dart';

class DefaultCubit extends Cubit<DefaultState> {
  DefaultCubit() : super(DefaultState());

  Future<void> getWorkouts(
    String? id,
    String? title,
    ContentType contentType,
    String? category,
    List<BodyPart>? bodyParts,
  ) async {
    emit(state.copyWith(isLoading: true));
    final result = await KinesteXAIFramework.apiService.fetchContent(
      id: id,
      title: title,
      contentType: contentType,
      category: category,
      bodyParts: bodyParts,
    );
    // Handle different result types
    if (result is WorkoutsResult) {
      // Multiple workouts returned
      final workouts = result.response.workouts;
      emit(state.copyWith(workouts: workouts, isLoading: false));
    } else if (result is WorkoutResult) {
      // Single workout returned (by ID or Title)
      final workouts = [result.workout];
      emit(state.copyWith(workouts: workouts, isLoading: false));
    } else if (result is PlansResult) {
      // Multiple plans returned
      final plans = result.response.plans;
      emit(state.copyWith(plans: plans, isLoading: false));
    } else if (result is PlanResult) {
      // Single plan returned (by ID or Title)
      final plans = [result.plan];
      emit(state.copyWith(plans: plans, isLoading: false));
    } else if (result is ExercisesResult) {
      // Multiple exercises returned
      final exercises = result.response.exercises;
      emit(state.copyWith(exercises: exercises, isLoading: false));
    } else if (result is ExerciseResult) {
      // Single exercise returned (by ID or Title)
      final exercises = [result.exercise];
      emit(state.copyWith(exercises: exercises, isLoading: false));
    } else if (result is ErrorResult) {
      // Handle error
      print('Error fetching content: ${result.message}');
      emit(state.copyWith(isLoading: false));
    } else {
      emit(state.copyWith(isLoading: false));
    }
  }

  void clearWorkouts() {
    emit(state.copyWith(workouts: [], exercises: [], plans: []));
  }
}
