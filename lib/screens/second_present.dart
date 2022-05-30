// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:developer';

import 'package:flutter/material.dart';

class SecondPresentScreen extends StatelessWidget {
  const SecondPresentScreen({Key? key}) : super(key: key);

  Widget logo() {
    return Image.asset('assets/images/logo.png', width: 100);
  }

  Widget presentCode() {
    // Column에도 mainAxisAlignment에 center하면 가운데임
    // 이 경우엔 굳이 min에다가 center로 감싸주지 않아도 ㄱㅊ
    // 인데 사실 방법의 차이일 뿐 뭐가 더 좋은게 아님
    // 가운데 배치하는 방법이 많아서....
    return Container(
        height: 150,
        width: 150,
        alignment: Alignment.center,
        // 오 Decoration으로 자주 쓰는건 한방에 다 써버렸넼ㅋㅋㅋㅋㅋ 굳
        // 참고로 알겠지만 borderWidth는 width에 포함안되므로 이 위젯의 width/height는 158임
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
              // textScaleFactor는 보통 기본값이 1.0
              Text(
                '경품 추첨 코드',
                textScaleFactor: 1.0,
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
                textScaleFactor: 1.0,
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

  // 옼ㅋㅋㅋㅋㅋㅋ 중복제거용 위젯 함수 굳
  Widget title(String title, String desc) {
    // 알다시피 Container에도 alignment 있슴돠
    return Align(
        alignment: Alignment.topLeft,
        child: Container(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title,
                  textScaleFactor: 1.0,
                  style: TextStyle(
                      height: 1.2,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Color(0xFF172E63))),
              Text(desc,
                  textScaleFactor: 1.0,
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
      // Column이 min이 아니면 가질 수 있는 최대의 높이로 가져감
      // => 해당 Column의 crossAxisAlignment 기본값이 center 이므로, Center로 감싸줄 필요가 없음
      body: Center(
        child: Column(children: [
          const SizedBox(height: 20.0),
          logo(),
          const SizedBox(height: 30.0),
          presentCode(),
          const SizedBox(height: 30.0),
          title('KEYWORD', '당신과 같은 키워드를 가진 사람을 찾아, 선물을 교환하세요!'),
          // 보통 shadow까지 줬다면 horizontal 여백은 최소 20 (앱 기준)
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
                  textScaleFactor: 1.0,
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
                  textScaleFactor: 1.0,
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

// 대체로 잘못한 부분은 전혀 없고
// 사소한 거나 굳이 안해도 되는 부분 같은거 밖에 없네 
// 처음하는걸텐데 아주 굳임. 검색 좀 해본 티가 난다.
