
import 'package:flutter/material.dart';
import 'package:kinestex_sdk_flutter/kinestex_sdk_flutter.dart';
import 'package:kinestex_sdk_flutter/models/plan_category.dart';
import 'package:kinestex_sdk_flutter/models/work_out_category.dart';

import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {

  bool _isLottieVisible =
      true; // State to control Lottie visibility and animation

  bool showWebView = false; // Flag to control WebView visibility
  List<String> workoutLogs = [];

  late AnimationController _scaleController;
  late AnimationController _opacityController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
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

  @override
  void initState() {
    super.initState();
    _checkCameraPermission();
    // Initialize the scale controller and its animation first
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1, end: 2).animate(_scaleController);

    // Then, initialize the opacity controller and its animation
    _opacityController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _opacityAnimation =
        Tween<double>(begin: 1.0, end: 0).animate(_opacityController);

    // Now, add listeners to the animations
    _scaleAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _opacityController.forward(); // Start opacity animation after scale
      }
    });

    _opacityAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _isLottieVisible =
              false; // Hide the Lottie after animations are completed
        });
      }
    });
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _opacityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (showWebView) {
      // Fullscreen WebView without AppBar
      return SafeArea(
        child: Stack(
          children: [
            _buildWebView(),
            _buildLottieAnimation(),
          ],
        ),
      );
    } else {
      // Regular UI with AppBar
      return Scaffold(
        appBar: AppBar(
          title: const Text("KinesteX"),
          actions: [
            IconButton(
              icon: const Icon(Icons.info_outline),
              onPressed: () => showInfoDialog(context),
            ),
            IconButton(
              icon: const Icon(Icons.list),
              onPressed: () => showLogsSheet(context),
            ),
          ],
        ),
        body: _buildOpenButton(),
      );
    }
  }

  Widget _buildWebView() {
    return KinesteXWebView(
      apiKey: 'YOUR API KEY',
      userId:  'YOUR USER ID',
      workOutCategory: CustomWorkOutCategory(""),
      planCategory: WeightManagementPlanCategory(),
      companyName: 'COMPANY NAME',
      onLoadStop: () {},
      onHandleMessage: _handleMessage,
    );
  }

  void _handleMessage(Map<String, dynamic> message) {
    print("RECEIVED A MESSAGE: $message");
    String currentTime =
        "${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second}";
//data handling. HTTP post communication
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

  void showLogsSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView.builder(
          itemCount: workoutLogs.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(workoutLogs[index]),
            );
          },
        );
      },
    );
  }

  Widget _buildOpenButton() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _isLottieVisible = true;
            _scaleController.reset(); // Reset scale animation controller
            _opacityController.reset(); // Reset opacity animation controller
            _scaleController.forward(); // Restart scale animation
            showWebView = true;
          });
        },
        child: const Text('Open KinesteX'),
      ),
    );
  }

  void showInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("KinesteX B2B"),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    "KinesteX B2B is an excellent solution for your app to increase user engagement with real-time feedback on user's movements and invaluable stats, including reps, calories burnt, and even mistakes a user might have made during the workout"),
                Text(
                    "KinesteX provides expansive workout collecion with a variety of routines spanning from Fitness to Rehabilitation!"),
                Text(
                    "Please contact support@kinestex.com for any questions or inquiries!"),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildLottieAnimation() {
    if (!_isLottieVisible) return const SizedBox.shrink();

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return AnimatedBuilder(
          animation: _opacityAnimation,
          builder: (context, child) {
            return Opacity(
              opacity: _opacityAnimation.value,
              child: Transform.scale(
                scale: _scaleAnimation.value,
                child: Container(
                  color: Colors.white, // White background
                  alignment: Alignment.center,
                  child: Lottie.asset('assets/yoga_animation.json'),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
