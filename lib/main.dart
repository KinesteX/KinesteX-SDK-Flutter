import 'package:KinesteX_B2B/kinestex_web_view_example.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KinesteX B2B App',
      theme: ThemeData(primarySwatch: Colors.blue),
        builder: (context, snapshot) {
          return MyHomePage();

          }
          // Updated CircularProgressIndicator with size and centering
    );
  }
}
