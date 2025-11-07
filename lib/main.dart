import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kinestex_flutter_demo/content/content_view.dart';
import 'package:kinestex_flutter_demo/content/cubit/default_cubit.dart';
import 'package:kinestex_sdk_flutter/kinestex_sdk.dart';
import 'home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await KinesteXAIFramework.initialize(
    apiKey: "13c5398cf7a98e3469f6fc8a9a5b2b9d5c8a4814",
    companyName: "kinestex",
    userId: "SzrSE1XOsSfzwm3h7E18axKMZGE2",
  );
  runApp(BlocProvider(
    create: (context) => DefaultCubit(),
    child: const MaterialApp(
      // home: ContentView(),
      home: MyHomePage(),
    ),
  ));
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
