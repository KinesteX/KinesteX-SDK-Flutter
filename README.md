## Configuration

This is a demo project 

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
Add the following dependencies to pubsec.yaml:

```xml
kinestex_sdk_flutter: ^@latest
```

### Available categories to sort plans (param key is planC):

| **Plan Category (key: planC)** | 
| --- | 
| **Strength** | 
| **Cardio** |
| **Rehabilitation** | 


### Available categories and sub categories to sort workouts:

| **Category (key: category)** |
| --- | 
| **Fitness** |
| **Rehabilitation** | 

## WebView Camera Access in Flutter with KinesteX AI

This guide provides a detailed walkthrough of the Flutter code that integrates a web view with camera access and communicates with KinesteX.

### Initial Setup

1. **Prerequisites**:
    - Ensure you've added the necessary permissions in your `AndroidManifest.xml` and `Info.plist` for both Android and iOS respectively.
    - Add the required dependencies in your `pubspec.yaml`.

2. **App Initialization**:
    - Before Starting KinesteX, please initialize essential widgets.
    - Then checks and request for camera permission.
    ```dart
    void _checkCameraPermission() async {
    if (await Permission.camera.request() != PermissionStatus.granted) {
      _showCameraAccessDeniedAlert();
       }
    }
   void _showCameraAccessDeniedAlert() {
    showDialog(
      context: context, // Now using the build context of the widget
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Camera Permission Denied"),
          content: const Text(
              "Camera access is required for this app to function properly."),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
   }
    ```


### Displaying KinesteX

   ```dart
      Widget _buildWebView() {
      return KinesteXWebView(
         apiKey: 'YOUR API KEY',
         userId:  "YOUR USER ID",
         workOutCategory: CustomWorkOutCategory(""), // Leave it empty if you want to not show workout categories
         planCategory: WeightManagementPlanCategory(),
         companyName: 'YOUR COMPANY NAME',
         onLoadStop: () {},
         onHandleMessage: _handleMessage,
   );
}
   ```



### Handling communication:

We send HTTPS Post messages to inform you of the user's actions. You can handle the received messages through a callback function:
```dart
void _handleMessage(Map<String, dynamic> message) {
  
    switch (message['type']) {
      case "kinestex_launched":
        print("Successfully launched the app. @${message['data']}");
        break;
      case "workout_opened":
        print("Workout opened. ${message['data']}");
        break;
      case "workout_started":
        print("Workout started. ${message['data']}");
        break;
      case "plan_unlocked":
        print("User unlocked plan. Data: ${message['data']}");
        break;
      case "finished_workout":
        print("Workout finished. Data: ${message['data']}");
        break;
      case "error_occured":
        print("There was an error: ${message['data']}");
        break;
      case "exercise_completed":
        print("Exercise completed: ${message['data']}");
        break;
      case "exitApp":
        // a user wishes to close KinesteX, so dismiss the KinesteX webview to your interface
        if (mounted) {
          setState(() {
            showWebView = false;
          });
        }
        print("User closed KinesteX window @$currentTime");
        break;
      default:
        print("Received: ${message['type']} ${message['data']}");
        break;
    }
  }

```

#### Function Breakdown:

**Switch Statement on Message Type**:
The core of the `handleMessage` function is a switch statement that checks the `type` property of the parsed message. Each case corresponds to a different type of action or event that occurred in KinesteX.
 
    
| Type          | Data  |          Description     |
|----------------------|----------------------------|---------------------------------------------------------|
| `kinestex_launched`  | Format: `dd mm yyyy hours:minutes:seconds` | When a user has launched KinesteX 
| `exit_kinestex`     | Format: `date: dd mm yyyy hours:minutes:seconds`, `time_spent: number` | Logs when a user clicks on exit button, requesting dismissal of KinesteX and sending how much time a user has spent totally in seconds since launch   |
| `plan_unlocked`    | Format: `title: String, date: date and time` | Logs when a workout plan is unlocked by a user    |
| `workout_opened`      | Format: `title: String, date: date and time` | Logs when a workout is opened by a user  |
| `workout_started`   |  Format: `title: String, date: date and time`| Logs when a workout is started.  |
| `error_occurred`    | Format:  `data: string`  |  Logs when a significant error has occurred. For example, a user has not granted access to the camera  |
| `exercise_completed`      | Format: `time_spent: number`,  `repeats: number`, `calories: number`,  `exercise: string`, `mistakes: [string: number]`  |  Logs everytime a user finishes an exercise |
| `total_active_seconds` | Format: `number`   |   Logs every `5 seconds` and counts the number of active seconds a user has spent working out. This value is not sent when a user leaves camera tracking area  |
| `left_camera_frame` | Format: `number`  |  Indicates that a user has left the camera frame. The data sent is the current number of `total_active_seconds` |
| `returned_camera_frame` | Format: `number`  |  Indicates that a user has returned to the camera frame. The data sent is the current number of `total_active_seconds` |
| `workout_overview`    | Format:  `workout: string`,`total_time_spent: number`,  `total_repeats: number`, `total_calories: number`,  `percentage_completed: number`,  `total_mistakes: number`  |  Logged when a user finishes the workout with a complete short summary of the workout  |
| `exercise_overview`    | Format:  `[exercise_completed]` |  Returns a log of all exercises and their data (exercise_completed data is defined 5 lines above) |
| `workout_completed`    | Format:  `workout: string`, `date: dd mm yyyy hours:minutes:seconds`  |  Logs when a user finishes the workout and exits the workout overview |
| `active_days` (Coming soon)   | Format:  `number`  |  Represents a number of days a user has been opening KinesteX |
| `total_workouts` (Coming soon)  | Format:  `number`  |  Represents a number of workouts a user has done since start of using KinesteX|
| `workout_efficiency` (Coming soon)  | Format:  `number`  |  Represents the level of intensivity a person has done the workout with. An average level of workout efficiency is 0.5, which represents an average time a person should complete the workout for at least 80% within a specific timeframe. For example, if on average people complete workout X in 15 minutes, but a person Y has completed the workout in 12 minutes, they will have a higher `workout_efficiency` number |
------------------



### Contact
Please contact help@kinestex.com if you have any questions
