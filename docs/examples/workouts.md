Complete code example for the `createWorkoutView` function:
```dart
import 'package:flutter/material.dart';
import 'package:kinestex_sdk_flutter/kinestex_sdk.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KinesteX Workout',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ValueNotifier<bool> showKinesteX = ValueNotifier<bool>(false);

  // Your KinesteX credentials
  final String apiKey = yourapikey;
  final String company = yourcompanyname;
  final String userId = youruserid;

  @override
  void initState() {
    super.initState();
    _checkCameraPermission();
  }

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
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  void handleWebViewMessage(WebViewMessage message) {
    if (message is ExitKinestex) {
      setState(() {
        showKinesteX.value = false;
      });
    }
  }

  Widget createWorkoutView() {
    return Center(
      child: KinesteXAIFramework.createWorkoutView(
        apiKey: apiKey,
        companyName: company,
        isShowKinestex: showKinesteX,
        userId: userId,
        workoutName: "Fitness Lite", // Specify the workout name or ID here
        customParams: {
          "style": "dark", // light or dark theme (default is dark)
        },
        isLoading: ValueNotifier<bool>(false),
        onMessageReceived: handleWebViewMessage,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: showKinesteX,
      builder: (context, isShowKinesteX, child) {
        return isShowKinesteX
            ? SafeArea(
          child: createWorkoutView(),
        )
            : Scaffold(
          body: Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 20,
                ),
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                showKinesteX.value = true;
              },
              child: const Text(
                'Start Workout',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

```