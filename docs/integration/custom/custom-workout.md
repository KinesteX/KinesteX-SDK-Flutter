# Custom Workout Sequences

Create personalized workout sequences with custom exercises, repetitions, durations, and rest periods.

---
## Custom Workout Flow Sequence

```
┌─────────────────────────────────────────────────────┐
│ 1. SDK Initialization                               │
└─────────────────────────────────────────────────────┘
                        ↓
┌─────────────────────────────────────────────────────┐
│ 2. Verification & Setup                             │
│    - Host sends initial data with customWorkout-    │
│      Exercises array                                │
│    - SDK validates exercises                        │
│    - SDK loads AI models & assets in parallel       │
└─────────────────────────────────────────────────────┘
                        ↓
┌─────────────────────────────────────────────────────┐
│ 3. Resource Loading                                 │
│    - Exercise AI models load                        │
│    - Audio files load                               │
│    - Pose tracking model initializes                │
│    - SDK sends: all_resources_loaded                │
└─────────────────────────────────────────────────────┘
                        ↓
┌─────────────────────────────────────────────────────┐
│ 4. Start Command                                    │
│    - Host sends: workout_activity_action: "start"   │
│    - SDK navigates to workout execution             │
└─────────────────────────────────────────────────────┘
                        ↓
┌─────────────────────────────────────────────────────┐
│ 5. Workout Execution                                │
│    - User performs exercises                        │
│    - SDK tracks motion & provides feedback          │
│    - Rest periods occur between exercises (if set)  │
└─────────────────────────────────────────────────────┘
```

---
## Quick Start

### 1. Define Your Workout

```dart
final List<WorkoutSequenceExercise> customWorkoutExercises = [
    const WorkoutSequenceExercise(
      exerciseId: "jz73VFlUyZ9nyd64OjRb", // exercise id from kinestex api or admin panel
      reps: 15, // reps for the exercise
      duration: null,  // duration for the exercise (null if not applicable and person has unlimited time to complete specified number of reps)
      includeRestPeriod: true, // include rest period before the exercise
      restDuration: 20, // rest duration in seconds before the exercise
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

### 3. Create Workout View And Render it Conditionally in the background, until we receive "all_resources_loaded" message (see below)

```dart
ValueNotifier<bool> showKinesteX = ValueNotifier<bool>(false);

Widget buildWorkout() {
  return KinesteXAIFramework.createCustomWorkoutView(
    customWorkouts: customWorkoutExercises, // include defined exercise sequence
    isShowKinestex: showKinesteX,
    isLoading: ValueNotifier<bool>(false),
    onMessageReceived: (message) {
      handleWebViewMessage(message);
    },
  );
}
```

### 4. Handle Messages Received from the SDK 

```dart
void handleWebViewMessage(WebViewMessage message) {
  if (message.data['type'] == 'all_resources_loaded') {
    print("All resources loaded");
    setState((){
      print("Workout is ready to be displayed to users");
      showKinesteX.value = true;
    });
    KinesteXAIFramework.sendAction("workout_activity_action", "start");
  } else if (message.data['type'] == 'workout_exit_request') {
    setState(() {
      print("Workout exited by user");
      showKinesteX.value = false;
    });
  }
}
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

## Troubleshooting

**Workout doesn't start?**
- Ensure SDK is initialized before showing the view
- Verify exercise IDs are valid
- Check "error_occurred" messages for issues

**Exercise validation errors?**
- Use simple exercise names or valid IDs from the API
- Ensure reps/duration values are positive numbers

---

## Next Steps

- **[View complete code example](../../examples/custom-workout.md)**
- **[See all available message types](../../data.md)**
- **[Explore other integration options](../overview.md)**
- **[Learn about Content API](./content-api.md)**
