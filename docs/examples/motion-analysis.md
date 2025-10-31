Complete code example for the `createCameraComponent` function:
```dart
import 'package:flutter/material.dart';
import 'package:kinestex_sdk_flutter/kinestex_sdk.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> main() async {
  await KinesteXAIFramework.initialize(
    apiKey: "your_api_key",
    companyName: "your_company_name",
    userId: "your_user_id",
  );
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void dispose() {
    disposeKinesteXAIFramework();
    super.dispose();
  }

  Future<void> disposeKinesteXAIFramework() async {
    await KinesteXAIFramework.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KinesteX Camera Component',
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
  ValueNotifier<int> reps = ValueNotifier<int>(0);
  ValueNotifier<String> mistake = ValueNotifier<String>("--");
  ValueNotifier<String?> updateExercise = ValueNotifier<String?>("Squats");

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
              onPressed: () {
                Navigator.of(context).pop();
              },
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
    } else if (message is Reps) {
      setState(() {
        reps.value = message.data['value'] ?? 0;
      });
    } else if (message is Mistake) {
      setState(() {
        mistake.value = message.data['value'] ?? '--';
      });
    } else {
      print("Unhandled message: ${message.data}");
    }
  }

  Widget createCameraComponent() {
    return Stack(
      children: [
        Center(
          child: ValueListenableBuilder<String?>(
            valueListenable: updateExercise,
            builder: (context, value, _) {
              return KinesteXAIFramework.createCameraComponent(
                isShowKinestex: showKinesteX,
                exercises: ["Squats", "Jumping Jack"],
                currentExercise: value ?? "Squats",
                updatedExercise: value,
                isLoading: ValueNotifier<bool>(false),
                onMessageReceived: handleWebViewMessage,
              );
            },
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ElevatedButton(
                onPressed: () {
                  updateExercise.value = "Jumping Jack";
                },
                child: const Text("Switch to Jumping Jack"),
              ),
              ValueListenableBuilder<int>(
                valueListenable: reps,
                builder: (context, value, child) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      "Reps: $value",
                      style: const TextStyle(fontSize: 18, color: Colors.white),
                    ),
                  );
                },
              ),
              ValueListenableBuilder<String>(
                valueListenable: mistake,
                builder: (context, value, child) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      "Mistakes: $value",
                      style: const TextStyle(fontSize: 18, color: Colors.red),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: showKinesteX,
      builder: (context, isShowKinesteX, child) {
        return isShowKinesteX
            ? SafeArea(child: createCameraComponent())
            : Scaffold(
          backgroundColor: Colors.black,
          body: Center(
            child: ElevatedButton(
              onPressed: () {
                showKinesteX.value = true;
              },
              child: const Text("Start Camera Component"),
            ),
          ),
        );
      },
    );
  }
}


```