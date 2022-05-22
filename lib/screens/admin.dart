import 'dart:async';
import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({Key? key}) : super(key: key);

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  final String _adminPassword = 'ckwodnjs';
  bool _isAdmin = false;
  String _input = '';

  login() {
    if (_input == _adminPassword) {
      setState(() {
        _isAdmin = true;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('비밀번호가 일치하지 않습니다.'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red.shade700,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500),
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _isAdmin
                ? const EditContainer()
                : Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'ADMIN',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 20.0),
                      TextField(
                        obscureText: true,
                        decoration: const InputDecoration(
                            labelText: '비밀번호',
                            hintText: '비밀번호를 입력하세요.',
                            hintStyle: TextStyle(
                              height: 2.0,
                            ),
                            contentPadding: EdgeInsets.all(10.0)),
                        onChanged: (value) => setState(() {
                          _input = value;
                        }),
                        onSubmitted: (_) => login(),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 16.0),
                        alignment: Alignment.centerRight,
                        child: ElevatedButton(
                          onPressed: login,
                          child: const Text('확인'),
                        ),
                      )
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class EditContainer extends StatefulWidget {
  const EditContainer({Key? key}) : super(key: key);

  @override
  State<EditContainer> createState() => EditContainerState();
}

class EditContainerState extends State<EditContainer> {
  final DatabaseReference _database = FirebaseDatabase.instance.ref('jpc/second/present');

  TextEditingController phoneOneTec = TextEditingController();
  TextEditingController phoneTwoTec = TextEditingController();
  TextEditingController codeTec = TextEditingController();

  @override
  void initState() {
    _database.onChildAdded.listen((event) {
      log(event.type.toString());
      log(event.snapshot.value.toString());
    }, onError: (err) => log('ERROR! $err'));
    _database.onChildChanged.listen((event) {
      log(event.type.toString());
      log(event.snapshot.value.toString());
    }, onError: (err) => log('ERROR! $err'));
    _database.onChildRemoved.listen((event) {
      log(event.type.toString());
      log(event.snapshot.value.toString());
    }, onError: (err) => log('ERROR! $err'));
    super.initState();
  }

  addPair() async {
    if (phoneOneTec.text.isEmpty || phoneTwoTec.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('두 번호는 필수로 입력해야 합니다.'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red.shade700,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      ));
      return;
    }
    final newChild = _database.push();
    await newChild.set({
      'one': phoneOneTec.text,
      'two': phoneTwoTec.text,
      'code': codeTec.text,
    });
    phoneOneTec.clear();
    phoneTwoTec.clear();
    codeTec.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: phoneOneTec,
          decoration: InputDecoration(
              labelText: '휴대폰번호1 *',
              hintText: '',
              hintStyle: TextStyle(height: 2.0),
              contentPadding: EdgeInsets.all(10.0)),
        ),
        TextField(
          controller: phoneTwoTec,
          decoration: InputDecoration(
              labelText: '휴대폰번호2 *',
              hintText: '',
              hintStyle: TextStyle(height: 2.0),
              contentPadding: EdgeInsets.all(10.0)),
        ),
        TextField(
          controller: codeTec,
          decoration: InputDecoration(
              labelText: '코드',
              hintText: '',
              hintStyle: TextStyle(height: 2.0),
              contentPadding: EdgeInsets.all(10.0)),
        ),
        ElevatedButton(onPressed: addPair, child: Text('추가하기'))
      ],
    );
  }
}
