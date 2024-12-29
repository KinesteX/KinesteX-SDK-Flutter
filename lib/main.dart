import 'package:flutter/material.dart';
import 'home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    const MaterialApp(
      home: MyHomePage(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
