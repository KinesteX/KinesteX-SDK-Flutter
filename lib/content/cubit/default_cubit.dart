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
    if (result is WorkoutsResult) {
      final workouts = result.response.workouts;
      emit(state.copyWith(workouts: workouts, isLoading: false));
    } else if (result is PlansResult) {
      final plans = result.response.plans;
      emit(state.copyWith(plans: plans, isLoading: false));
    } else if (result is ExercisesResult) {
      final exercises = result.response.exercises;
      emit(state.copyWith(exercises: exercises, isLoading: false));
    } else {
      emit(state.copyWith(isLoading: false));
    }
  }

  void clearWorkouts() {
    emit(state.copyWith(workouts: [], exercises: [], plans: []));
  }
}
