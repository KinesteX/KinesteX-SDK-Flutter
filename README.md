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

    - `kinestex_launched`: Logs when KinesteX is successfully launched.
    - `workout_opened`: Logs when a workout is opened.
    - `workout_started`: Logs when a workout is started.
    - `plan_unlocked`: Logs when a user unlocks a plan.
    - `finished_workout`: Logs when a workout is finished.
    - `error_occured`: Logs when there's an error.
    - `exercise_completed`: Logs when an exercise is completed.
    - `exitApp`: Logs when the KinesteX window is closed and sets the `showWebview` to false, which will hide the WebView.
    - `default`: For all other message types, it just logs the received type and data.


### Contact
Please contact help@kinestex.com if you have any questions
