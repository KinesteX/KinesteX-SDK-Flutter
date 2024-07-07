import 'package:KinesteX_B2B/export.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider(
      create: (BuildContext context) {
        return KinesteXViewState();
      },
      child: const MyApp(),
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
    );
  }
}
