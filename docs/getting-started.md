### Minimum Device Requirements: 
- Android: Android 8.0 (API level 26) or higher
- iOS: iOS 14.0 or higher

## Configuration

### 1. Add Permissions

#### AndroidManifest.xml

Add the following permissions for camera usage:

```xml
<!-- Add this line inside the <manifest> tag -->
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.INTERNET"/>
<uses-feature android:name="android.hardware.camera" android:required="false" />
<!-- Optional: To detect device orientation when prompting to position phone correctly-->
<uses-feature android:name="android.hardware.sensor.accelerometer" android:required="false" />
<uses-feature android:name="android.hardware.sensor.gyroscope" android:required="false" />
```

#### Info.plist

Add the following keys for camera usage:

```xml
<key>NSCameraUsageDescription</key>
<string>Please grant access to camera to start AI Workout</string>
<key>NSMotionUsageDescription</key>
<string>We need access to your device's motion sensors to properly position your phone for the workout</string>
```

### 2. Install libraries

Add the following dependency to your `pubspec.yaml`:

```yaml
dependencies:
   kinestex_sdk_flutter: ^@latest
   permission_handler: ^11.3.1
```

### 3. Request camera permission from user before launching KinesteX

1. **Prerequisites**: Ensure you’ve added the necessary permissions in `AndroidManifest.xml` and `Info.plist`.

2. **Launching the View**: Initialize essential widgets, check, and request for camera permission before launching KinesteX.

Add to your Podfile:
```dart
post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)

    target.build_configurations.each do |config|
      # You can remove unused permissions here
      # for more information: https://github.com/BaseflowIT/flutter-permission-handler/blob/master/permission_handler/ios/Classes/PermissionHandlerEnums.h
      # e.g. when you don't need camera permission, just add 'PERMISSION_CAMERA=0'
      config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] ||= [
        '$(inherited)',
        ## dart: PermissionGroup.camera
        'PERMISSION_CAMERA=1',
      ]

    end
  end
end
```

Request camera permission before launching KinesteX:
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
### 4. Initialize KinesteX on app launch for warm up: 
```dart
// main.dart or your app launcher file
Future<void> main() async {
  await KinesteXAIFramework.initialize(
    apiKey: YOUR_API_KEY, // get it from KinesteX admin dashboard 
    companyName: YOUR_COMPANY_NAME, // get it from KinesteX admin dashboard 
    userId: YOUR_USER_ID, // any unique string you use to identify users
  );

    runApp(
    const MaterialApp(
      home: MyHomePage(),
    ),
  );
}
```
### 5. Setup recommendations
1. Add a ValueNotifier value to manage the presentation of KinesteX: `ValueNotifier<bool> showKinesteX = ValueNotifier<bool>(false);`.   
2. Import KinesteX Module: `import 'package:kinestex_sdk_flutter/kinestex_sdk_flutter.dart';`.
3. Add a function to handle data from a callback function: 
 ```dart
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
# Next Steps
### **[Available Integration Options](integration/overview.md)**


