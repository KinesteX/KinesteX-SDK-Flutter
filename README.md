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
   kinestex_sdk_flutter: ^@latest
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
   switch (message.type) {
      case 'exit_kinestex':
      // hide KinesteX view
         showKinesteX.value = false;
         break;
   // Handle all other cases as needed
      default:
         log('Other message: ${message.data}');
   }
}
```

2. Display KinesteX with Main Integration Option:

```dart
KinesteXAIFramework.createMainView(
apiKey: 'YOUR API KEY',
companyName: 'YOUR COMPANY',
userId: 'YOUR USER ID',
planCategory: PlanCategory.Cardio, // pass the plan category
isShowKinesTex: showKinesteX,
isLoading: ValueNotifier<bool>(false),
onMessageReceived: handleWebViewMessage,
);
```

### Examples for Each Integration Option

**Individual Plan**

```dart
KinesteXAIFramework.createPlanView(
apiKey: 'YOUR API KEY',
companyName: 'YOUR COMPANY',
userId: 'YOUR USER ID',
planName: 'Circuit Training', // pass the name of the plan
isShowKinesTex: showKinesteX,
isLoading: ValueNotifier<bool>(false),
onMessageReceived: handleWebViewMessage,
);
```

**Individual Workout**

```dart
KinesteXAIFramework.createWorkoutView(
apiKey: 'YOUR API KEY',
companyName: 'YOUR COMPANY',
userId: 'YOUR USER ID',
workoutName: 'Circuit Training', // pass the name of the workout
isShowKinesTex: showKinesteX,
isLoading: ValueNotifier<bool>(false),
onMessageReceived: handleWebViewMessage,
);
```

**Challenge Component**

1. Change `postData`:

```dart
const postData = {
   'key': apiKey,
   'userId': 'YOUR USER ID',
   'company': 'YOUR COMPANY NAME',
   'exercise': 'Squats',
   'countdown': 100,
};
```

2. Change integration option in KinesteXSDK:

```dart
KinesteXAIFramework.createChallengeView(
apiKey: 'YOUR API KEY',
companyName: 'YOUR COMPANY',
userId: 'YOUR USER ID',
exercise: 'Squats', // pass the name of the challenge exercise
countdown: 100, // duration of the challenge in seconds
isShowKinesTex: showKinesteX,
isLoading: ValueNotifier<bool>(false),
onMessageReceived: handleWebViewMessage,
);
```

**Camera Component**

1. Change `postData`:

```dart
const postData = {
   'key': apiKey,
   'userId': 'YOUR USER ID',
   'company': 'YOUR COMPANY NAME',
   'currentExercise': 'Squats',
   'exercises': ['Squats', 'Jumping Jack'],
};
```

2. Changing current exercise:

```dart
void changeExercise() {
   updateExercise.value = 'Jumping Jack';
}
```

3. Displaying KinesteXSDK:

```dart
KinesteXAIFramework.createCameraComponent(
apiKey: 'YOUR API KEY',
companyName: 'YOUR COMPANY',
userId: 'YOUR USER ID',
exercises: ['Squats', 'Jumping Jack'],
currentExercise: 'Squats',
isShowKinesTex: showKinesteX,
isLoading: ValueNotifier<bool>(false),
onMessageReceived: handleWebViewMessage,
updatedExercise: updateExercise.value,
);
```

4. Handle message for reps and mistakes a person has done:

```dart
void handleWebViewMessage(WebViewMessage message) {
   switch (message.type) {
      case 'reps':
         reps.value = message.data['value'] ?? 0;
         break;
      case 'mistake':
         mistake.value = message.data['value'] ?? '--';
         break;
      default:
         log('Other message: ${message.data}');
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

