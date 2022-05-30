import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class SecondPresentScreen extends StatefulWidget {
  const SecondPresentScreen({Key? key}) : super(key: key);

  @override
  State<SecondPresentScreen> createState() => _SecondPresentScreenState();
}

class _SecondPresentScreenState extends State<SecondPresentScreen> {
  Future getDataFromPhone(String phone) async {
    final result = await FirebaseDatabase.instance
        .ref('jpc/second/present')
        .orderByChild('one')
        .equalTo(phone)
        .once();
    log("Result  ${result.snapshot.children.first.value}");
    return result.snapshot.children.first.value;
  }

  Widget presentCode() {
    return Container(
        height: 150,
        width: 150,
        margin: const EdgeInsets.symmetric(vertical: 30.0),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFF172E63), width: 4),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                  color: const Color(0xFF172E63).withOpacity(0.4),
                  spreadRadius: 2,
                  blurRadius: 6,
                  offset: const Offset(3, 3))
            ]),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                '경품 추첨 코드',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Color(0xFF172E63)),
              ),
              Text(
                '54',
                textAlign: TextAlign.center,
                style: TextStyle(
                    height: 1.2,
                    fontWeight: FontWeight.bold,
                    fontSize: 55,
                    color: Color(0xFF172E63)),
              ),
            ]));
  }

  Widget title(String title, String desc) {
    return Container(
        alignment: Alignment.topLeft,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Color(0xFF172E63))),
          Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: Text(desc,
                style: const TextStyle(
                  height: 1.2,
                  fontSize: 13,
                )),
          )
        ]));
  }

  Widget _buildResultPage(Object? data) {
    final map = data as Map<String, dynamic>;
    return Container(
      height: double.infinity,
      constraints: const BoxConstraints(maxWidth: 500),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(children: [
          presentCode(),
          title('KEYWORD', '당신과 같은 키워드를 가진 파트너를 찾아, 선물을 교환하세요!'),
          Container(
              height: 100,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: const Color(0xFF172E63),
                  boxShadow: [
                    BoxShadow(
                        color: const Color(0xFF172E63).withOpacity(0.4),
                        spreadRadius: 2,
                        blurRadius: 6,
                        offset: const Offset(3, 3))
                  ],
                  borderRadius: BorderRadius.circular(10)),
              child: Text(
                '${data['code']}',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.white),
              )),
          const SizedBox(height: 20),
          title('HINT', '파트너를 알아볼 수 있는 특징은?'),
          Container(
              height: 60,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: const Color(0xFF172E63).withOpacity(0.4),
                        spreadRadius: 2,
                        blurRadius: 6,
                        offset: const Offset(3, 3))
                  ],
                  border: Border.all(color: const Color(0xFF172E63), width: 2),
                  borderRadius: BorderRadius.circular(10)),
              child: Text(
                '${data['twoHint']}',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFF172E63)),
              )),
        ]),
      ),
    );
  }

  Widget _buildErrorPage() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.error_outline,
          size: 100,
          color: Theme.of(context).colorScheme.primary,
        ),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 20.0),
          child: Text('해당 번호로 등록된 멤버가 없습니다'),
        ),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Theme.of(context).primaryColor,
              onPrimary: Theme.of(context).colorScheme.onPrimary,
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text('뒤로가기')),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    String phone = (ModalRoute.of(context)?.settings.arguments ?? '') as String;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        toolbarHeight: 90,
        title: Image.asset(
          'assets/images/logo.png',
          height: 50,
        ),
        centerTitle: true,
      ),
      body: Center(
        child: phone.isNotEmpty
            ? FutureBuilder(
                future: getDataFromPhone(phone),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done &&
                      snapshot.hasData) {
                    return _buildResultPage(snapshot.data);
                  }

                  if (snapshot.hasError || snapshot.data == null) {
                    return _buildErrorPage();
                  }

                  return const CircularProgressIndicator();
                })
            : _buildErrorPage(),
      ),
    );
  }
}
