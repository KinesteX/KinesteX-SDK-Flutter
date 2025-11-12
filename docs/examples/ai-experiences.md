Complete code example for the `createExperienceView` function:

```dart
import 'package:flutter/material.dart';
import 'package:kinestex_sdk_flutter/kinestex_sdk.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
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
      title: 'KinesteX Challenge',
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

  Widget createExperienceView() {
    return Center(
      child: KinesteXAIFramework.createExperienceView(
        isShowKinestex: showKinesteX,
        experience: "assessment",
        customParams: {
          "style": "dark", // light or dark theme (default is dark)
          "exercise": "balloonpop" // which activity to display. Please contact us for details
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
                child: createExperienceView(),
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
                      'Start Challenge',
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
