# Custom Workout - Complete Example

A complete, ready-to-use example for implementing custom workout sequences.

---

## Full Working Code

```dart
import 'package:flutter/material.dart';
import 'package:kinestex_sdk_flutter/kinestex_sdk.dart';

class CustomWorkoutScreen extends StatefulWidget {
  const CustomWorkoutScreen({Key? key}) : super(key: key);

  @override
  State<CustomWorkoutScreen> createState() => _CustomWorkoutScreenState();
}

class _CustomWorkoutScreenState extends State<CustomWorkoutScreen> {
  // 1. Define your workout sequence
  final customWorkouts = [
    const WorkoutSequenceExercise(
      exerciseId: 'Squats',
      reps: 15,
      includeRestPeriod: true,
      restDuration: 20,
    ),
    const WorkoutSequenceExercise(
      exerciseId: 'Push-ups',
      reps: 10,
      includeRestPeriod: true,
      restDuration: 15,
    ),
    const WorkoutSequenceExercise(
      exerciseId: 'Plank',
      duration: 60,
      includeRestPeriod: true,
      restDuration: 30,
    ),
  ];

  // 2. Create state variables
  ValueNotifier<bool> showKinesteX = ValueNotifier<bool>(false);
  ValueNotifier<int> reps = ValueNotifier<int>(0);
  ValueNotifier<String> feedback = ValueNotifier<String>("Ready!");

  @override
  void initState() {
    super.initState();
    // 3. Initialize SDK
    KinesteXAIFramework.initialize(
      apiKey: "your-api-key",
      companyName: "YourCompany",
      userId: "user-id",
    );
  }

  @override
  void dispose() {
    showKinesteX.dispose();
    reps.dispose();
    feedback.dispose();
    super.dispose();
  }

  // 4. Handle real-time messages
  void handleWebViewMessage(WebViewMessage message) {
    if (message is ExitKinestex) {
      setState(() => showKinesteX.value = false);
    } else if (message is Reps) {
      setState(() => reps.value = message.data['value'] ?? 0);
    } else if (message is Mistake) {
      setState(() => feedback.value = message.data['value'] ?? 'Good form!');
    } else if (message is WorkoutCompleted) {
      setState(() => showKinesteX.value = false);
      _showCompletionDialog();
    }
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("🎉 Workout Complete!"),
        content: const Text("Great job! You finished your workout."),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Custom Workout'),
        backgroundColor: Colors.blue,
      ),
      body: ValueListenableBuilder<bool>(
        valueListenable: showKinesteX,
        builder: (context, isShowing, _) {
          // 5. Show workout view when active
          if (isShowing) {
            return KinesteXAIFramework.createCustomWorkoutView(
              customWorkouts: customWorkouts,
              isShowKinestex: showKinesteX,
              isLoading: ValueNotifier<bool>(false),
              onMessageReceived: handleWebViewMessage,
            );
          }

          // 6. Show stats and start button when not active
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Display real-time reps
                  ValueListenableBuilder<int>(
                    valueListenable: reps,
                    builder: (_, count, __) => Text(
                      'Reps: $count',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Display feedback
                  ValueListenableBuilder<String>(
                    valueListenable: feedback,
                    builder: (_, text, __) => Text(
                      text,
                      style: const TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 48),

                  // Start workout button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 48,
                        vertical: 16,
                      ),
                      backgroundColor: Colors.blue,
                    ),
                    onPressed: () => showKinesteX.value = true,
                    child: const Text(
                      'Start Workout',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
```

---

## What This Example Does

1. ✅ **Defines a workout** with 3 exercises (Squats, Push-ups, Plank)
2. ✅ **Initializes the SDK** on screen load
3. ✅ **Shows real-time feedback** (reps count and form corrections)
4. ✅ **Handles workout completion** with a dialog
5. ✅ **Manages state properly** with ValueNotifiers
6. ✅ **Cleans up resources** on dispose

---

## Using Exercise IDs from API

If you want to use specific exercise IDs from the KinesteX API:

```dart
final customWorkouts = [
  const WorkoutSequenceExercise(
    exerciseId: 'jz73VFlUyZ9nyd64OjRb',  // From API/Admin Panel
    reps: 15,
    includeRestPeriod: true,
    restDuration: 20,
  ),
  const WorkoutSequenceExercise(
    exerciseId: 'ZVMeLsaXQ9Tzr5JYXg29',
    reps: 10,
    includeRestPeriod: true,
    restDuration: 15,
  ),
];
```

---

## Advanced Example with Stats Tracking

```dart
class AdvancedCustomWorkoutScreen extends StatefulWidget {
  const AdvancedCustomWorkoutScreen({Key? key}) : super(key: key);

  @override
  State<AdvancedCustomWorkoutScreen> createState() => _AdvancedCustomWorkoutScreenState();
}

class _AdvancedCustomWorkoutScreenState extends State<AdvancedCustomWorkoutScreen> {
  final customWorkouts = [
    const WorkoutSequenceExercise(exerciseId: 'Squats', reps: 15, restDuration: 20),
    const WorkoutSequenceExercise(exerciseId: 'Push-ups', reps: 10, restDuration: 15),
    const WorkoutSequenceExercise(exerciseId: 'Plank', duration: 60, restDuration: 30),
  ];

  ValueNotifier<bool> showKinesteX = ValueNotifier<bool>(false);
  ValueNotifier<int> reps = ValueNotifier<int>(0);
  ValueNotifier<int> calories = ValueNotifier<int>(0);
  ValueNotifier<String> feedback = ValueNotifier<String>("Ready!");
  ValueNotifier<String> currentExercise = ValueNotifier<String>("--");

  @override
  void initState() {
    super.initState();
    KinesteXAIFramework.initialize(
      apiKey: "your-api-key",
      companyName: "YourCompany",
      userId: "user-id",
    );
  }

  void handleWebViewMessage(WebViewMessage message) {
    if (message is ExitKinestex) {
      setState(() => showKinesteX.value = false);
    } else if (message is Reps) {
      setState(() => reps.value = message.data['value'] ?? 0);
    } else if (message is Mistake) {
      setState(() => feedback.value = message.data['value'] ?? 'Good form!');
    } else if (message is WorkoutStarted) {
      setState(() => currentExercise.value = "Starting...");
    } else if (message is ExerciseCompleted) {
      final exercise = message.data['exercise'] ?? 'Exercise';
      setState(() => currentExercise.value = exercise);
      print("Completed: $exercise");
    } else if (message is WorkoutOverview) {
      final totalCals = message.data['totalCalories'] ?? 0;
      setState(() => calories.value = totalCals);
    } else if (message is WorkoutCompleted) {
      setState(() => showKinesteX.value = false);
      _showStats();
    }
  }

  void _showStats() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("🎉 Workout Complete!"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Total Calories: ${calories.value}"),
            Text("Total Reps: ${reps.value}"),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Advanced Workout')),
      body: ValueListenableBuilder<bool>(
        valueListenable: showKinesteX,
        builder: (context, isShowing, _) {
          if (isShowing) {
            return KinesteXAIFramework.createCustomWorkoutView(
              customWorkouts: customWorkouts,
              isShowKinestex: showKinesteX,
              isLoading: ValueNotifier<bool>(false),
              customParams: {"planC": "#FF5722"},
              onMessageReceived: handleWebViewMessage,
            );
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildStatCard("Reps", reps),
                _buildStatCard("Calories", calories),
                _buildStatCard("Feedback", feedback),
                _buildStatCard("Exercise", currentExercise),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () => showKinesteX.value = true,
                  child: const Text('Start Workout'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard(String label, ValueNotifier notifier) {
    return Card(
      margin: const EdgeInsets.all(8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("$label: ", style: const TextStyle(fontWeight: FontWeight.bold)),
            ValueListenableBuilder(
              valueListenable: notifier,
              builder: (_, value, __) => Text(value.toString()),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## Message Types Used in Examples

| Message Type | When to Use | Example |
|--------------|-------------|---------|
| `Reps` | Track repetition count | `message.data['value']` |
| `Mistake` | Show form feedback | `message.data['value']` |
| `WorkoutStarted` | Detect workout start | - |
| `ExerciseCompleted` | Track exercise progress | `message.data['exercise']` |
| `WorkoutOverview` | Get total stats | `message.data['totalCalories']` |
| `WorkoutCompleted` | Handle workout end | - |
| `ExitKinestex` | User closed view | - |

---

## Next Steps

- **[View integration guide](../integration/custom/custom-workout.md)**
- **[See all message types](../data.md)**
- **[Try other examples](./code-samples.md)**
