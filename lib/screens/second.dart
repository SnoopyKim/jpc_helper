// ignore_for_file: prefer_const_constructors

import 'dart:html';

import 'package:flutter/material.dart';

class SecondScreen extends StatefulWidget {
  const SecondScreen({Key? key}) : super(key: key);

  @override
  State<SecondScreen> createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  String _input = '';

  goNext() {
    Navigator.pushNamed(context, '/second/present');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            logo(), //로고
            Text(
              '당신의 파트너는 누구일까요?',
              textScaleFactor: 1.0,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 30.0),
            TextField(
              decoration: InputDecoration(
                  labelText: '전화번호(\'-\' 없이 입력하세요)',
                  hintText: '01012345678',
                  hintStyle: TextStyle(
                    height: 2.0,
                  ),
                  contentPadding: EdgeInsets.all(10.0)),
              onChanged: (value) => setState(() {
                _input = value;
              }),
              onSubmitted: (_) => goNext(),
            ),
            const SizedBox(height: 30.0),
            TextButton(
              style: TextButton.styleFrom(
                  padding: const EdgeInsets.all(20.0),
                  textStyle: const TextStyle(fontSize: 20),
                  primary: Colors.white,
                  backgroundColor: Color(0xFF172E63)),
              onPressed: () => goNext(),
              child: Text('NEXT'),
            )
          ],
        ),
      ),
    ));
  }

  Widget logo() {
    return Image.asset('assets/images/logo.png', width: 217);
  }
}
