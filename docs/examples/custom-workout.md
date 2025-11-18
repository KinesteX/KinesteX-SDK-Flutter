# Custom Workout - Complete Example

A complete, ready-to-use example for implementing custom workout sequences.

```dart
// custom_workout_always_mounted_with_loading.dart
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
    _disposeKinesteX();
    super.dispose();
  }

  Future<void> _disposeKinesteX() async {
    await KinesteXAIFramework.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KinesteX Custom Workout',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const CustomWorkoutPage(),
    );
  }
}
class CustomWorkoutPage extends StatefulWidget {
  const CustomWorkoutPage({super.key});

  @override
  State<CustomWorkoutPage> createState() => _CustomWorkoutPageState();
}

class _CustomWorkoutPageState extends State<CustomWorkoutPage> {
  // The KinesteX view is ALWAYS mounted. We only toggle visibility.
  final ValueNotifier<bool> showKinesteX = ValueNotifier<bool>(false);

  // Signals when SDK reports all resources loaded.
  final ValueNotifier<bool> allResourcesLoaded = ValueNotifier<bool>(false);

  // Optional: SDK loading notifier (not used by host UI).
  final ValueNotifier<bool> sdkLoading = ValueNotifier<bool>(false);

  bool permissionGranted = false;

  late final List<WorkoutSequenceExercise> customWorkoutExercises;

  @override
  void initState() {
    super.initState();
    _requestCameraPermission();

    customWorkoutExercises = const [
      WorkoutSequenceExercise(
        exerciseId: "jz73VFlUyZ9nyd64OjRb",
        reps: 15,
        duration: null,
        includeRestPeriod: true,
        restDuration: 20,
      ),
      WorkoutSequenceExercise(
        exerciseId: "ZVMeLsaXQ9Tzr5JYXg29",
        reps: 10,
        duration: 30,
        includeRestPeriod: true,
        restDuration: 15,
      ),
      WorkoutSequenceExercise(
        exerciseId: "ZVMeLsaXQ9Tzr5JYXg29",
        reps: 10,
        duration: 30,
        includeRestPeriod: true,
        restDuration: 15,
      ),
      WorkoutSequenceExercise(
        exerciseId: "gJGOiZhCvJrhEP7sTy78",
        reps: 20,
        duration: null,
        includeRestPeriod: false,
        restDuration: 0,
      ),
    ];
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.request();
    if (status == PermissionStatus.granted) {
      setState(() => permissionGranted = true);
    } else {
      setState(() => permissionGranted = false);
      _showCameraAccessDeniedAlert();
    }
  }

  void _showCameraAccessDeniedAlert() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Camera Permission Denied"),
            content: const Text(
              "Camera access is required for this feature to work "
                  "correctly.",
            ),
            actions: <Widget>[
              TextButton(
                child: const Text("OK"),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          );
        },
      );
    });
  }

  // Handle messages from the SDK (postMessage bridge).
  void handleWebViewMessage(WebViewMessage message) {
    // Some SDK builds might send typed messages like ExitKinestex.
    if (message is ExitKinestex) {
      allResourcesLoaded.value = false;
      showKinesteX.value = false;
      return;
    }

    try {
      final data = message.data;
      final type = data['type'];

      switch (type) {
        case 'all_resources_loaded':
          allResourcesLoaded.value = true;
          showKinesteX.value = true; // Reveal the SDK layer
          KinesteXAIFramework.sendAction(
            "workout_activity_action",
            "start",
          );
          break;

        case 'workout_exit_request':
        // Keep mounted but hide behind host UI.
          allResourcesLoaded.value = false;
          showKinesteX.value = false;
          break;

        case 'workout_overview':
        // Optional: handle overview
          break;

        case 'error_occurred':
          final errorMsg = data['message']?.toString() ?? 'Unknown error';
          print('Error from KinesteX SDK: $errorMsg');
          break;

        default:
          break;
      }
    } catch (_) {
      allResourcesLoaded.value = false;
      showKinesteX.value = false;
    }
  }

  // Always-mounted background KinesteX layer, invisible until loaded.
  Widget buildAlwaysMountedKinesteXLayer() {
    return ValueListenableBuilder<bool>(
      valueListenable: showKinesteX,
      builder: (context, isVisible, _) {
        return IgnorePointer(
          ignoring: !isVisible,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 250),
            opacity: isVisible ? 1.0 : 0.0,
            child: KinesteXAIFramework.createCustomWorkoutView(
              customWorkouts: customWorkoutExercises,
              isShowKinestex: showKinesteX,
              isLoading: sdkLoading,
              onMessageReceived: handleWebViewMessage,
            ),
          ),
        );
      },
    );
  }

  // Small corner status indicator (top-right). Not fullscreen.
  Widget buildCornerIndicator() {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 8, right: 8),
        child: ValueListenableBuilder<bool>(
          valueListenable: allResourcesLoaded,
          builder: (context, loaded, _) {
            return ValueListenableBuilder<bool>(
              valueListenable: showKinesteX,
              builder: (context, visible, __) {
                // Decide appearance
                Color bg = Colors.black.withOpacity(0.75);
                Color text = Colors.white;
                IconData icon = Icons.hourglass_bottom;
                String label = 'KinesteX loading...';

                if (!permissionGranted) {
                  bg = Colors.red.withOpacity(0.85);
                  icon = Icons.videocam_off;
                  label = 'Camera permission required';
                } else if (!loaded) {
                  bg = Colors.orange.withOpacity(0.85);
                  icon = Icons.downloading;
                  label = 'Loading in background';
                } else if (loaded && visible) {
                  bg = Colors.green.withOpacity(0.85);
                  icon = Icons.check_circle;
                  label = 'All resources loaded';
                } else if (loaded && !visible) {
                  bg = Colors.grey.withOpacity(0.85);
                  icon = Icons.visibility_off;
                  label = 'KinesteX hidden';
                }

                return Container(
                  constraints: const BoxConstraints(maxWidth: 260),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(icon, color: text, size: 18),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          label,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: text,
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      if (!permissionGranted)
                        TextButton(
                          onPressed: _requestCameraPermission,
                          child: const Text(
                            'Grant',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      else if (loaded && !visible)
                        TextButton(
                          onPressed: () {
                            showKinesteX.value = true;
                            KinesteXAIFramework.sendAction(
                              "workout_activity_action",
                              "start",
                            );
                          },
                          child: const Text(
                            'Show',
                            style: TextStyle(color: Colors.white),
                          ),
                        )
                      else if (!loaded)
                          const SizedBox(
                            height: 16,
                            width: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    // KinesteX is ALWAYS mounted at the back. A small corner indicator
    // shows status; no fullscreen overlays.
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(child: buildAlwaysMountedKinesteXLayer()),
          Positioned(top: 0, right: 0, child: buildCornerIndicator())
        ],
      ),
    );
  }
}

```

## Next Steps

- **[View integration guide](../integration/custom/custom-workout.md)**
- **[See all message types](../data.md)**
