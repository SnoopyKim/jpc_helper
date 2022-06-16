import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Text(
            //   'WELCOME',
            //   style: Theme.of(context).textTheme.titleLarge,
            // ),
            // TextButton(
            //   onPressed: () => Navigator.pushNamed(context, '/admin'),
            //   child: Text('Admin'),
            // ),
            // TextButton(
            //   onPressed: () => Navigator.pushNamed(context, '/second'),
            //   child: Text('Second'),
            // ),
          ],
        ),
      ),
    );
  }
}
