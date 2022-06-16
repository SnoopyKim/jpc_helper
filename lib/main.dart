import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:jpc_second/firebase_options.dart';

import 'screens/admin.dart';
import 'screens/second.dart';
import 'screens/second_present.dart';
import 'screens/welcome.dart';

void main() {
  setUrlStrategy(PathUrlStrategy());
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
                builder: (context, child) {
                  return MediaQuery(
                    data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
                    child: child!,
                  );
                },
                title: 'JPC HELPER',
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                  useMaterial3: true,
                  colorSchemeSeed: Color(0xFF172E63),
                ),
                initialRoute: '/',
                routes: {
                  '/': (context) => const WelcomeScreen(),
                  '/admin': (context) => const AdminScreen(),
                  '/second': (context) => const SecondScreen(),
                  '/second/present': (context) => const SecondPresentScreen(),
                },
              )
            : Center(
                child: SizedBox.fromSize(
                    size: const Size(100, 100),
                    child: const CircularProgressIndicator(
                      color: Color(0xFF172E63),
                    )));
      },
    );
  }
}
