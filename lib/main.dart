import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'pages/weather_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp({super.key});

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print("Error");
          }

          if (snapshot.connectionState == ConnectionState.done) {
            return const WeatherPage();
          }
          return const CircularProgressIndicator();
        },
      ),
    );
  }
}
