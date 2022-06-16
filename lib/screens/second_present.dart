// ignore_for_file: prefer_const_constructors

import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class SecondPresentScreen extends StatefulWidget {
  const SecondPresentScreen({Key? key}) : super(key: key);

  @override
  State<SecondPresentScreen> createState() => _SecondPresentScreenState();
}

class _SecondPresentScreenState extends State<SecondPresentScreen> {
  final List<String> _checkinList = [
    '아직 파티에 도착하지 않았어요ㅠㅠ\n(hasn\'t arrived at the party yet.)',
    '파티에 도착해있어요\n(already arrived at the party)'
  ];
  int checkInIdx = 0;
  Future<Map<String, dynamic>> getDataFromPhone(String phone) async {
    final result = await FirebaseDatabase.instance
        .ref('jpc/second/members')
        .orderByChild('phone')
        .equalTo(phone)
        .get();
    final userData = result.children.first.value as Map<String, dynamic>;
    userData['key'] = result.children.first.key;
    if (userData['code'] != null) {
      final pairData = (await FirebaseDatabase.instance
              .ref('jpc/second/members')
              .orderByChild('code')
              .equalTo(userData['code'])
              .get())
          .children
          .where((data) => data.key != userData['key']);
      userData['pairHint'] =
          (pairData.first.value as Map<String, dynamic>)['hint'];
    }
    return userData;
  }

  Widget presentCode(String value) {
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
            children: [
              Text(
                'PRIZE CODE',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Color(0xFF172E63)),
              ),
              Text(
                '$value',
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

  Widget _buildResultPage(Map<String, dynamic> data) {
    return Container(
      height: double.infinity,
      constraints: const BoxConstraints(maxWidth: 500),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(children: [
          presentCode(data['key']),
          title('SECRET CODE',
              '같은 시크릿코드를 가진 파트너를 찾아, 선물을 교환하세요!\n(Find a partner who has the same secret code as you and exchange gifts!)'),
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
                '${data['code'] ?? '-'}',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: Colors.white),
              )),
          const SizedBox(height: 20),
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text("당신의 파트너는 지금?\n(Your partner..)",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        height: 1.2,
                        color: Color(0xFF172E63))),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF172E63),
                      onPrimary: Theme.of(context).colorScheme.onPrimary,
                      alignment: Alignment.center,
                      minimumSize: Size.zero, // default padding 제거
                      padding: EdgeInsets.fromLTRB(10, 13, 10, 13),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                    ),
                    onPressed: () => reload(),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Text('RELOAD', style: TextStyle(fontSize: 10)),
                        const SizedBox(width: 5),
                        Image.asset(
                          'assets/images/reload.png',
                          width: 10,
                          height: 10,
                        ),
                      ],
                    ))
              ]),
          const SizedBox(height: 8),
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
                _checkinList[checkInIdx],
                style: TextStyle(fontSize: 13, color: Color(0xFF172E63)),
              )),
          const SizedBox(height: 20),
          title('PARTNER HINT',
              '파트너를 알아볼 수 있는 특징은? \n(the hint for you to recognize your partner)'),
          Container(
              height: 80,
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
              child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Text(
                    // '${data['pairHint'] ?? '-'}',
                    "I was the one who taught josh how to drink alcohol",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF172E63)),
                  ))),
          const SizedBox(height: 20),
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
          child: Text(
              '해당 번호로 등록된 멤버가 없습니다.\nNo matching member found. \nPlease check if it is the correct number.',
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: Theme.of(context).primaryColor,
              onPrimary: Theme.of(context).colorScheme.onPrimary,
            ),
            onPressed: () => Navigator.pop(context),
            child: const Text('BACK')),
      ],
    );
  }

  reload() {
    //새로고침 동작
    setState(() {
      checkInIdx = (checkInIdx - 1).abs();
    });
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
            ? FutureBuilder<Map<String, dynamic>>(
                future: getDataFromPhone(phone),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return snapshot.hasData
                        ? _buildResultPage(snapshot.data!)
                        : _buildErrorPage();
                  }

                  if (snapshot.hasError) {
                    return _buildErrorPage();
                  }

                  return const CircularProgressIndicator();
                })
            : _buildErrorPage(),
      ),
    );
  }
}
