# [KinesteX AI](https://kinestex.com)
## INTEGRATE AI FITNESS & PHYSIO TRAINER IN YOUR APP IN MINUTES

## Available Integration Options

### Integration Options

| **Integration Option**         | **Description**                                                                                                 | **Features**                                                                                                                                     | **Details**                                                                                                             |
|--------------------------------|-----------------------------------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------|
| **Complete User Experience**   | Leave it to us to recommend the best workout routines for your customers, handle motion tracking, and overall user interface. High level of customization based on your brand book for a seamless experience. | - Long-term lifestyle workout plans <br> - Specific body parts and full-body workouts <br> - Individual exercise challenges (e.g., 20 squat challenge) | [View Integration Options](https://www.figma.com/proto/XYEoV023iSFdhpw3w65zR1/Complete?page-id=0%3A1&node-id=0-1&viewport=793%2C330%2C0.1&t=d7VfZzKpLBsJAcP9-1&scaling=contain) |
| **Custom User Experience**     | Integrate the camera component with motion tracking. Real-time feedback on all customer movements. Control the position, size, and placement of the camera component. | - Real-time feedback on customer movements <br> - Communication of every repeat and mistake <br> - Customizable camera component position, size, and placement | [View Details](https://www.figma.com/proto/JyPHuRKKbiQkwgiDTkGJgT/Camera-Component?page-id=0%3A1&node-id=1-4&viewport=925%2C409%2C0.22&t=3UccMcp1o3lKc0cP-1&scaling=contain) |

---
## Configuration

### Permissions

#### AndroidManifest.xml

Add the following permissions for camera and microphone usage:

```xml
<!-- Add this line inside the <manifest> tag -->
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.RECORD_AUDIO" />
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.VIDEO_CAPTURE" />
```

#### Info.plist

Add the following keys for camera and microphone usage:

```xml
<key>NSCameraUsageDescription</key>
<string>Camera access is required for video streaming.</string>
<key>NSMicrophoneUsageDescription</key>
<string>Microphone access is required for video streaming.</string>
```

### Install libraries

Add the following dependency to your `pubspec.yaml`:

```yaml
dependencies:
   kinestex_sdk_flutter: ^1.1.6
```

## Usage

### Initial Setup

1. **Prerequisites**: Ensure you’ve added the necessary permissions in `AndroidManifest.xml` and `Info.plist`.

2. **Launching the View**: Initialize essential widgets, check, and request for camera permission before launching KinesteX.

```dart
void _checkCameraPermission() async {
   if (await Permission.camera.request() != PermissionStatus.granted) {
      _showCameraAccessDeniedAlert();
   }
}

void _showCameraAccessDeniedAlert() {
   showDialog(
      context: context,
      builder: (BuildContext context) {
         return AlertDialog(
            title: const Text("Camera Permission Denied"),
            content: const Text("Camera access is required for this app to function properly."),
            actions: <Widget>[
               TextButton(
                  child: const Text("OK"),
                  onPressed: () {
                     Navigator.of(context).pop();
                  },
               ),
            ],
         );
      },
   );
}
```

### Integration Options

| **functions**             | **Description**                                                 |
|---------------------------|-----------------------------------------------------------------|
| **createMainView**        | Integration of our Complete UX                                  |
| **createPlanView**        | Integration of Individual Plan Component                        |
| **createWorkoutView**     | Integration of Individual Workout Component                     |
| **createChallengeView**   | Integration of Individual Exercise in a challenge form          |
| **createCameraComponent** | Integration of our camera component with pose-analysis and feedback |

### Available Categories to Sort Plans

| **Plan Category (key: planCategory)** |
|---------------------------------------|
| **Strength**                          |
| **Cardio**                            |
| **Weight Management**                 |
| **Rehabilitation**                    |

### Example Integration

1. Create a handleMessage function to process messages from KinesteX SDK:

```dart
 ValueNotifier<bool> showKinesteX = ValueNotifier<bool>(false);

void handleWebViewMessage(WebViewMessage message) {
  if (message is ExitKinestex) {
    // Handle ExitKinestex message
    setState(() {
      showKinesteX.value = false;
    });
  }  else {
    // Handle other message types
    print("Other message received: ${message.data}");
  }
}
```

2. Display KinesteX with Main Integration Option:

```dart
  KinesteXAIFramework.createMainView(
    apiKey: apiKey,
    companyName: company,
    isShowKinestex: showKinesteX,
    userId: userId,
    planCategory: PlanCategory.Cardio,  // plan category
    data: <String, dynamic>{ 'isHideHeaderMain': false }, // optional custom parameters
    isLoading: ValueNotifier<bool>(false),
    onMessageReceived: (message) {
     handleWebViewMessage(message);
    },
);
```

### Examples for Each Integration Option

**Individual Plan**

```dart
  KinesteXAIFramework.createPlanView(
    apiKey: apiKey,
    companyName: company,
    userId: userId,
    isShowKinestex: showKinesteX,
    planName: "Circuit Training",
    isLoading: ValueNotifier<bool>(false),
    onMessageReceived: (message) {
      handleWebViewMessage(message);
    }
    );
```

**Individual Workout**

```dart
  KinesteXAIFramework.createWorkoutView(
        apiKey: apiKey,
        isShowKinestex: showKinesteX,
        companyName: company,
        userId: userId,
        workoutName: "Fitness Lite", // Workout title
        isLoading: ValueNotifier<bool>(false),
        onMessageReceived: (message) {
          handleWebViewMessage(message);
        }
);
```

**Challenge Component**

```dart
    KinesteXAIFramework.createChallengeView(
        apiKey: apiKey,
        companyName: company,
        isShowKinestex: showKinesteX,
        userId: userId,
        exercise: "Squats", // Exercise title
        countdown: 100,
        isLoading: ValueNotifier<bool>(false),
        onMessageReceived: (message) {
          handleWebViewMessage(message);
        }
    );
```

**Camera Component**

1. Displaying KinesteXSDK:

```dart
   ValueListenableBuilder<String?>(
        valueListenable: updateExercise,
        builder: (context, value, _) {
        return KinesteXAIFramework.createCameraComponent(
        apiKey: apiKey,
        companyName: company,
        isShowKinestex: showKinesteX,
        userId: userId,
        exercises: ["Squats", "Jumping Jack"],
        currentExercise: "Squats",
        updatedExercise: value,
        isLoading: ValueNotifier<bool>(false),
        onMessageReceived: (message) {
        handleWebViewMessage(message);
        },
        );
    }),
```
2. Update current exercise by changing the notifier's value:

```dart
 updateExercise.value = 'Jumping Jack';
```
3. Handle message for reps and mistakes a person has done:

```dart
    ValueNotifier<int> reps = ValueNotifier<int>(0);
    ValueNotifier<String> mistake = ValueNotifier<String>("--");
    
    void handleWebViewMessage(WebViewMessage message) {
      if (message is ExitKinestex) {
        // Handle ExitKinestex message
        setState(() {
          showKinesteX.value = false;
        });
      } else if (message is Reps) {
        setState(() {
          reps.value = message.data['value'] ?? 0;
        });
      } else if (message is Mistake) {
        setState(() {
          mistake.value = message.data['value'] ?? '--';
        });
      } else {
        // Handle other message types
        print("Other message received: ${message.data}");
      }
    }
```


## Data Points

The KinesteX SDK provides various data points that are returned through the message callback. Here are the available data types:

| Type                       | Data                                                                                   | Description                                                                                               |
|----------------------------|----------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------------------------------|
| `kinestex_launched`        | `dd mm yyyy hours:minutes:seconds`                                                      | When a user has launched KinesteX                                                                          |
| `exit_kinestex`            | `date: dd mm yyyy hours:minutes:seconds`, `time_spent: number`                          | Logs when a user clicks the exit button and the total time spent                                           |
| `plan_unlocked`            | `title: String, date: date and time`                                                    | Logs when a workout plan is unlocked by a user                                                            |
| `workout_opened`           | `title: String, date: date and time`                                                    | Logs when a workout is opened by a user                                                                   |
| `workout_started`          | `title: String, date: date and time`                                                    | Logs when a workout is started by a user                                                                  |
| `exercise_completed`       | `time_spent: number`, `repeats: number`, `calories: number`, `exercise: string`, `mistakes: [string: number]` | Logs each time a user finishes an exercise                                                                 |
| `total_active_seconds`     | `number`                                                                                | Logs every 5 seconds, counting the active seconds a user has spent working out                            |
| `left_camera_frame`        | `number`                                                                                | Indicates that a user has left the camera frame                                                           |
| `returned_camera_frame`    | `number`                                                                                | Indicates that a user has returned to the camera frame                                                    |
| `workout_overview`         | `workout: string`, `total_time_spent: number`, `total_repeats: number`, `total_calories: number`, `percentage_completed: number`, `total_mistakes: number` | Logs a complete summary of the workout                                                                    |
| `exercise_overview`        | `[exercise_completed]`                                                                 | Returns a log of all exercises and their data                                                             |
| `workout_completed`        | `workout: string`, `date: dd mm yyyy hours:minutes:seconds`                             | Logs when a user finishes the workout and exits the workout overview                                      |
| `active_days` (Coming soon)| `number`                                                                                | Represents the number of days a user has been opening KinesteX                                             |
| `total_workouts` (Coming soon)| `number`                                                                            | Represents the number of workouts a user has done since starting to use KinesteX                          |
| `workout_efficiency` (Coming soon)| `number`                                                                        | Represents the level of intensity with which a person has completed the workout                           |
## Contact

If you have any questions, contact: [support@kinestex.com](mailto:support@kinestex.com)

