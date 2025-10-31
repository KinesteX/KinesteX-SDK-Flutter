import 'package:flutter/material.dart';
import 'package:kinestex_sdk_flutter/kinestex_sdk.dart';
import 'home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await KinesteXAIFramework.initialize(
    apiKey: "your_api_key",
    companyName: "your_company_name",
    userId: "your_user_id",
  );
  runApp(
    const MaterialApp(
      home: MyHomePage(),
    ),
  );
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
      title: 'KinesteX SDK App',
      home: const MyHomePage(),
      theme: ThemeData(primarySwatch: Colors.blue),

      // Updated CircularProgressIndicator with size and centering
    );
  }
}
