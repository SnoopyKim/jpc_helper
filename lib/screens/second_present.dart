// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class SecondPresentScreen extends StatelessWidget {
  const SecondPresentScreen({Key? key}) : super(key: key);

  Widget logo() {
    return Image.asset('assets/images/logo.png', width: 100);
  }

  Widget presentCode() {
    return Container(
        height: 150,
        width: 150,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Color(0xFF172E63), width: 4),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                  color: Color(0xFF172E63).withOpacity(0.4),
                  spreadRadius: 2,
                  blurRadius: 6,
                  offset: Offset(3, 3))
            ]),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '경품 추첨 코드',
                textAlign: TextAlign.center,
                style: TextStyle(
                    height: 1.2,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Color(0xFF172E63)
                    // color: Colors.white
                    ),
              ),
              Text(
                '54',
                textAlign: TextAlign.center,
                style: TextStyle(
                    height: 1.2,
                    fontWeight: FontWeight.bold,
                    fontSize: 55,
                    color: Color(0xFF172E63)
                    // color: Colors.white
                    ),
              ),
            ]));
  }

  Widget title(String title, String desc) {
    return Align(
        alignment: Alignment.topLeft,
        child: Container(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title,
                  style: TextStyle(
                      height: 1.2,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Color(0xFF172E63))),
              Text(desc,
                  style: TextStyle(
                    height: 1.2,
                    fontWeight: FontWeight.normal,
                    fontSize: 13,
                  ))
            ])));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(children: [
          const SizedBox(height: 20.0),
          logo(),
          const SizedBox(height: 30.0),
          presentCode(),
          const SizedBox(height: 30.0),
          title('KEYWORD', '당신과 같은 키워드를 가진 사람을 찾아, 선물을 교환하세요!'),
          Container(
              width: double.infinity,
              height: 100,
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Color(0xFF172E63),
                  boxShadow: [
                    BoxShadow(
                        color: Color(0xFF172E63).withOpacity(0.4),
                        spreadRadius: 2,
                        blurRadius: 6,
                        offset: Offset(3, 3))
                  ],
                  borderRadius: BorderRadius.circular(10)),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  '혹시 당근?',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white),
                ),
              )),
          const SizedBox(height: 10),
          title('HINT', '파트너를 알아볼 수 있는 특징은?'),
          Container(
              width: double.infinity,
              height: 60,
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Color(0xFF172E63).withOpacity(0.4),
                        spreadRadius: 2,
                        blurRadius: 6,
                        offset: Offset(3, 3))
                  ],
                  border: Border.all(color: Color(0xFF172E63), width: 2),
                  borderRadius: BorderRadius.circular(10)),
              child: Align(
                alignment: Alignment.center,
                child: Text(
                  '술톤 개구리',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Color(0xFF172E63)),
                ),
              ))
        ]),
      ),
    );
  }
}
