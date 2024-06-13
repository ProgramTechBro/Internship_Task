import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:internship_task/View/MainScreen.dart';
import 'package:provider/provider.dart';
import 'Controller/Provider/Imageprovider.dart';
import 'firebase_options.dart';
import 'package:internship_task/Theme/scanner_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key); // Fixed key definition.

  @override
  Widget build(BuildContext context) {
    final scannerTheme = ScannerTheme();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ImageClassProvider>(
          create: (context) => ImageClassProvider(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: "Material Scanner",
        theme: scannerTheme.lightTheme(),
        darkTheme: scannerTheme.darkTheme(),
        home: const MainScreen(),
      ),
    );
  }
}
