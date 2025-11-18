# Custom Workout Sequences

Create personalized workout sequences with custom exercises, repetitions, durations, and rest periods.

---

## Quick Start

### 1. Define Your Workout

```dart
final List<WorkoutSequenceExercise> customWorkoutExercises = [
    const WorkoutSequenceExercise(
      exerciseId: "jz73VFlUyZ9nyd64OjRb",
      reps: 15,
      duration: null,
      includeRestPeriod: true,
      restDuration: 20,
    ),
    const WorkoutSequenceExercise(
      exerciseId: "ZVMeLsaXQ9Tzr5JYXg29",
      reps: 10,
      duration: 30,
      includeRestPeriod: true,
      restDuration: 15,
    ),
    // duplicate of the exercise above to create a set
    const WorkoutSequenceExercise(
      exerciseId: "ZVMeLsaXQ9Tzr5JYXg29",
      reps: 10,
      duration: 30,
      includeRestPeriod: true,
      restDuration: 15,
    ),
    const WorkoutSequenceExercise(
      exerciseId: "gJGOiZhCvJrhEP7sTy78",
      reps: 20,
      duration: null,
      includeRestPeriod: false,
      restDuration: 0,
    ),
  ];
```

### 2. Initialize SDK

```dart
@override
void initState() {
  super.initState();
  KinesteXAIFramework.initialize(
    apiKey: "your-api-key",
    companyName: "YourCompany",
    userId: "user-id",
  );
}
```

### 3. Create Workout View

```dart
ValueNotifier<bool> showKinesteX = ValueNotifier<bool>(false);

Widget buildWorkout() {
  return KinesteXAIFramework.createCustomWorkoutView(
    customWorkouts: customWorkoutExercises,
    isShowKinestex: showKinesteX,
    isLoading: ValueNotifier<bool>(false),
    onMessageReceived: (message) {
      handleWebViewMessage(message);
    },
  );
}
```

### 4. Handle Messages

```dart
void handleWebViewMessage(WebViewMessage message) {
  if (message is ExitKinestex) {
    setState(() => showKinesteX.value = false);
  } else if (message is Reps) {
    print("Reps: ${message.data['value']}");
  } else if (message is Mistake) {
    print("Feedback: ${message.data['value']}");
  } else if (message is WorkoutCompleted) {
    print("Workout finished!");
    setState(() => showKinesteX.value = false);
  }
}
```

### 5. Start Workout

```dart
ElevatedButton(
  onPressed: () => showKinesteX.value = true,
  child: const Text('Start Workout'),
)
```

---

## WorkoutSequenceExercise Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `exerciseId` | `String` | ✅ Yes | Exercise name or ID from KinesteX API/Admin Panel |
| `reps` | `int?` | No | Number of repetitions (null for time-based) |
| `duration` | `int?` | No | Duration in seconds (null for rep-based) |
| `includeRestPeriod` | `bool` | No | Add rest after exercise (default: false) |
| `restDuration` | `int` | No | Rest time in seconds (default: 0) |

---

## Exercise Types

### Rep-Based Exercise
```dart
WorkoutSequenceExercise(
  exerciseId: "jz73VFlUyZ9nyd64OjRb",
  reps: 15,
  duration: null,
  includeRestPeriod: true,
  restDuration: 20,
)
```

### Time-Based Exercise
```dart
WorkoutSequenceExercise(
  exerciseId: "ZVMeLsaXQ9Tzr5JYXg29",
  reps: null,
  duration: 30,
  includeRestPeriod: true,
  restDuration: 15,
)
```

### Combined (ends when either condition is met)
```dart
WorkoutSequenceExercise(
  exerciseId: "gJGOiZhCvJrhEP7sTy78",
  reps: 20,
  duration: 30,
  includeRestPeriod: false,
  restDuration: 0,
)
```

---

## Getting Exercise IDs

### Option 1: Use Common Exercise IDs
```dart
exerciseId: 'jz73VFlUyZ9nyd64OjRb'
exerciseId: 'ZVMeLsaXQ9Tzr5JYXg29'
exerciseId: 'gJGOiZhCvJrhEP7sTy78'
```

### Option 2: Fetch from Content API
```dart
final exercises = await KinesteXAIFramework.fetchContent(
  contentType: ContentType.EXERCISES,
);
// Use exercise IDs from the response
```

### Option 3: Get from Admin Panel
Contact support@kinestex.com to access your KinesteX admin dashboard and browse available exercise IDs.

---

## Available Messages

| Message | When It Fires | Useful Data |
|---------|---------------|-------------|
| `WorkoutStarted` | Workout begins | - |
| `Reps` | Each rep completed | `message.data['value']` = rep count |
| `Mistake` | Form error detected | `message.data['value']` = feedback text |
| `ExerciseCompleted` | Exercise finishes | Exercise details |
| `WorkoutCompleted` | Workout finishes | Total stats |
| `ExitKinestex` | User exits | - |

---

## Complete Example

```dart
import 'package:flutter/material.dart';
import 'package:kinestex_sdk_flutter/kinestex_sdk.dart';

class CustomWorkoutScreen extends StatefulWidget {
  const CustomWorkoutScreen({Key? key}) : super(key: key);

  @override
  State<CustomWorkoutScreen> createState() => _CustomWorkoutScreenState();
}

class _CustomWorkoutScreenState extends State<CustomWorkoutScreen> {
  final List<WorkoutSequenceExercise> customWorkoutExercises = [
    const WorkoutSequenceExercise(
      exerciseId: "jz73VFlUyZ9nyd64OjRb",
      reps: 15,
      duration: null,
      includeRestPeriod: true,
      restDuration: 20,
    ),
    const WorkoutSequenceExercise(
      exerciseId: "ZVMeLsaXQ9Tzr5JYXg29",
      reps: 10,
      duration: 30,
      includeRestPeriod: true,
      restDuration: 15,
    ),
    // duplicate of the exercise above to create a set
    const WorkoutSequenceExercise(
      exerciseId: "ZVMeLsaXQ9Tzr5JYXg29",
      reps: 10,
      duration: 30,
      includeRestPeriod: true,
      restDuration: 15,
    ),
    const WorkoutSequenceExercise(
      exerciseId: "gJGOiZhCvJrhEP7sTy78",
      reps: 20,
      duration: null,
      includeRestPeriod: false,
      restDuration: 0,
    ),
  ];

  ValueNotifier<bool> showKinesteX = ValueNotifier<bool>(false);
  ValueNotifier<int> reps = ValueNotifier<int>(0);
  ValueNotifier<String> feedback = ValueNotifier<String>("Ready!");

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
    } else if (message is WorkoutCompleted) {
      setState(() => showKinesteX.value = false);
      _showCompletionDialog();
    }
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Great Job!"),
        content: const Text("You completed your workout!"),
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
      appBar: AppBar(title: const Text('Custom Workout')),
      body: ValueListenableBuilder<bool>(
        valueListenable: showKinesteX,
        builder: (context, isShowing, _) {
          if (isShowing) {
            return KinesteXAIFramework.createCustomWorkoutView(
              customWorkouts: customWorkoutExercises,
              isShowKinestex: showKinesteX,
              isLoading: ValueNotifier<bool>(false),
              onMessageReceived: handleWebViewMessage,
            );
          }

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ValueListenableBuilder<int>(
                  valueListenable: reps,
                  builder: (_, count, __) => Text(
                    'Reps: $count',
                    style: const TextStyle(fontSize: 24),
                  ),
                ),
                const SizedBox(height: 16),
                ValueListenableBuilder<String>(
                  valueListenable: feedback,
                  builder: (_, text, __) => Text(
                    text,
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
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
}
```

---

## Customization

### Add Custom Colors
```dart
KinesteXAIFramework.createCustomWorkoutView(
  customWorkouts: customWorkoutExercises,
  customParams: {
    "planC": "#FF5722",  // Your brand color
  },
  // ... other parameters
)
```

### Add User Details
```dart
KinesteXAIFramework.createCustomWorkoutView(
  customWorkouts: customWorkoutExercises,
  user: UserDetails(
    name: "John Doe",
    age: 30,
    height: 180,
    weight: 75,
  ),
  // ... other parameters
)
```

---

## Common Patterns

### Create Sets (Repeat Exercises)
```dart
final customWorkouts = [
  // Set 1
  WorkoutSequenceExercise(exerciseId: 'jz73VFlUyZ9nyd64OjRb', reps: 10),
  WorkoutSequenceExercise(exerciseId: 'jz73VFlUyZ9nyd64OjRb', duration: 30),

  // Set 2
  WorkoutSequenceExercise(exerciseId: 'jz73VFlUyZ9nyd64OjRb', reps: 10),
  WorkoutSequenceExercise(exerciseId: 'jz73VFlUyZ9nyd64OjRb', duration: 30),

  // Set 3
  WorkoutSequenceExercise(exerciseId: 'jz73VFlUyZ9nyd64OjRb', reps: 10),
];
```

### Circuit Training
```dart
final customWorkouts = [
  WorkoutSequenceExercise(exerciseId: 'jz73VFlUyZ9nyd64OjRb', reps: 15, restDuration: 10),
  WorkoutSequenceExercise(exerciseId: 'ZVMeLsaXQ9Tzr5JYXg29', reps: 10, restDuration: 10),
  WorkoutSequenceExercise(exerciseId: 'gJGOiZhCvJrhEP7sTy78', reps: 12, restDuration: 10),
  WorkoutSequenceExercise(exerciseId: 'jz73VFlUyZ9nyd64OjRb', duration: 30, restDuration: 60),
  // Repeat circuit...
];
```

---

## Troubleshooting

**Workout doesn't start?**
- Ensure SDK is initialized before showing the view
- Verify exercise IDs are valid

**No real-time feedback?**
- Check your `onMessageReceived` callback is implemented
- Make sure you're handling the message types you need

**Exercise validation errors?**
- Use simple exercise names or valid IDs from the API
- Ensure reps/duration values are positive numbers

---

## Next Steps

- **[View complete code example](../../examples/custom-workout.md)**
- **[See all available message types](../../data.md)**
- **[Explore other integration options](../overview.md)**
- **[Learn about Content API](./content-api.md)**
