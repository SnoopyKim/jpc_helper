import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:jpc_second/firebase_options.dart';

import 'screens/admin.dart';
import 'screens/second.dart';
import 'screens/second_present.dart';
import 'screens/welcome.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(options: DefaultFirebaseOptions.web),
      builder: (context, snapshot) {
        return (snapshot.connectionState == ConnectionState.done && snapshot.hasData)
            ? MaterialApp(
                title: 'JPC HELPER',
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                  useMaterial3: true,
                  colorSchemeSeed: Colors.amber,
                ),
                initialRoute: '/',
                routes: {
                  '/': (context) => WelcomeScreen(),
                  '/admin': (context) => AdminScreen(),
                  '/second': (context) => SecondScreen(),
                  '/second/present': (context) => SecondPresentScreen(),
                },
              )
            : Center(
                child: SizedBox.fromSize(
                    size: Size(100, 100),
                    child: const CircularProgressIndicator(
                      color: Colors.amber,
                    )));
      },
    );
  }
}
