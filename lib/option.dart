enum IntegrationOptionType {
  COMPLETE_UX(
    title: 'Complete UX',
    category: 'Goal Category',
    subOptions: [
      'Cardio',
      'Strength',
      'Rehabilitation',
      'WeightManagement',
    ],
  ),
  WORKOUT_PLAN(
    title: 'Workout Plan',
    category: 'Plan',
    subOptions: <String>[
      'Full Cardio',
      'Elastic Evolution',
      'Circuit Training',
      'Fitness Cardio',
    ],
  ),
  WORKOUT(
    title: 'Workout',
    category: 'Workout',
    subOptions: <String>[
      'Fitness Lite',
      'Circuit Training',
      'Tabata',
    ],
  ),
  CHALLENGE(
    title: 'Challenge',
    category: 'Challenge',
    subOptions: <String>[
      'Squats',
      'Jumping Jack',
    ],
  ),
  CAMERA(
    title: 'Camera',
    category: '',
    subOptions: <String>[],
  );

  final String title;
  final String category;
  final List<String>? subOptions;

  const IntegrationOptionType({
    required this.title,
    required this.category,
    this.subOptions,
  });

  /// Returns the `IntegrationOptionType` enum value at the given position.
  ///
  /// @param position The index of the `IntegrationOptionType` to retrieve.
  /// @return The `IntegrationOptionType` at the given position, or `null` if the position is out of bounds.
  static IntegrationOptionType? fromPosition(int position) {
    if (position < 0 || position >= IntegrationOptionType.values.length) {
      return null;
    }
    return IntegrationOptionType.values[position];
  }
}

class IntegrationOption {
  String title;
  String optionType;
  List<String>? subOption;

  IntegrationOption({
    required this.title,
    required this.optionType,
    this.subOption,
  });
}

/// Generates a list of `IntegrationOption` objects based on the values of `IntegrationOptionType`.
///
/// Returns a list of `IntegrationOption` objects, where each object is created from an `IntegrationOptionType` value.
/// The `title` of each `IntegrationOption` is set to the `title` of the corresponding `IntegrationOptionType`.
/// The `optionType` of each `IntegrationOption` is set to the `category` of the corresponding `IntegrationOptionType`.
/// The `subOption` of each `IntegrationOption` is set to the `subOptions` of the corresponding `IntegrationOptionType`,
/// converted to a list.
///
/// Returns a `List<IntegrationOption>`.
List<IntegrationOption> generateOptions() {
  return IntegrationOptionType.values.map((optionType) {
    return IntegrationOption(
      title: optionType.title,
      optionType: optionType.category,
      subOption: optionType.subOptions?.toList(),
    );
  }).toList();
}
