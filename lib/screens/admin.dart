import 'dart:async';
import 'dart:convert';
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
  bool _isAdmin = true;
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
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
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
  final DatabaseReference _database =
      FirebaseDatabase.instance.ref('jpc/second/present');
  late StreamSubscription<DatabaseEvent> addedSubscription;
  late StreamSubscription<DatabaseEvent> changedSubscription;
  late StreamSubscription<DatabaseEvent> removedSubscription;

  TextEditingController phoneOneTec = TextEditingController();
  TextEditingController phoneTwoTec = TextEditingController();
  TextEditingController codeTec = TextEditingController();

  List<Map<dynamic, dynamic>> pairList = [];

  @override
  void initState() {
    addedSubscription = _database.onChildAdded.listen((event) {
      // log(event.type.toString());
      // log(event.snapshot.value.toString());
      // log(event.snapshot.runtimeType.toString());

      pairList.add((event.snapshot.value as Map)..['key'] = event.snapshot.key);
      // pairList.last.addAll(<dynamic, dynamic>{'key': event.snapshot.key});
      // ..addAll({'key': event.snapshot.key}));
      setState(() {});
    }, onError: (err) => log('ERROR! $err'));
    changedSubscription = _database.onChildChanged.listen((event) {
      log(event.type.toString());
      final Map data = (event.snapshot.value as Map)
        ..['key'] = event.snapshot.key;
      log(data.toString());
      int idx = pairList.indexWhere((pair) => pair['key'] == data['key']);
      pairList.replaceRange(idx, idx + 1, [data]);
      setState(() {});
    }, onError: (err) => log('ERROR! $err'));
    removedSubscription = _database.onChildRemoved.listen((event) {
      log(event.type.toString());
      log(event.snapshot.value.toString());
      int idx =
          pairList.indexWhere((pair) => pair['key'] == event.snapshot.key);
      pairList.removeAt(idx);
      setState(() {});
    }, onError: (err) => log('ERROR! $err'));
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    addedSubscription.cancel();
    changedSubscription.cancel();
    removedSubscription.cancel();
  }

  addPair() async {
    if (phoneOneTec.text.isEmpty || phoneTwoTec.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('두 번호는 필수로 입력해야 합니다.'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red.shade700,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
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
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              border: Border.all(color: Theme.of(context).primaryColor)),
          padding: const EdgeInsets.all(20.0),
          margin: const EdgeInsets.symmetric(vertical: 20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
              const SizedBox(height: 20.0),
              ElevatedButton(onPressed: addPair, child: Text('추가하기')),
            ],
          ),
        ),
        Text(
          '현재 입력된 짝궁 수 : ${pairList.length}쌍',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            itemBuilder: (_, idx) {
              return _PairItem(pairList[idx]);
            },
            itemCount: pairList.length,
          ),
        )
      ],
    );
  }
}

class _PairItem extends StatefulWidget {
  const _PairItem(this.pair, {Key? key}) : super(key: key);
  final Map<dynamic, dynamic> pair;

  @override
  State<_PairItem> createState() => _PairItemState();
}

class _PairItemState extends State<_PairItem> {
  late TextEditingController controller;

  @override
  void initState() {
    controller = TextEditingController(text: widget.pair['code']);
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  _updateCode() {
    String inputText = controller.text;
    if (inputText.isEmpty || inputText == widget.pair['code']) return;

    FirebaseDatabase.instance
        .ref('jpc/second/present/${widget.pair['key']}')
        .update({'code': inputText});
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('코드가 수정되었습니다'),
      behavior: SnackBarBehavior.floating,
      backgroundColor: Theme.of(context).primaryColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
    ));
    FocusScope.of(context).unfocus();
  }

  _removePair() async {
    await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: Text('삭제하시겠습니까?'),
              actions: [
                TextButton(
                    onPressed: () {
                      FirebaseDatabase.instance
                          .ref('jpc/second/present/${widget.pair['key']}')
                          .remove();
                      Navigator.of(context).pop();
                    },
                    child: Text('네')),
                TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('아니오'))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: [
          Text('${widget.pair['one']}'),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0),
            child: Text('⇋'),
          ),
          Text('${widget.pair['two']}'),
          const Spacer(),
          IconButton(
            onPressed: _removePair,
            splashRadius: 26.0,
            icon: Icon(
              Icons.delete,
              size: 26.0,
              color: Colors.red.shade700,
            ),
          )
        ],
      ),
      subtitle: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: '코드',
            border: OutlineInputBorder(),
            suffixIcon: IconButton(
              constraints: BoxConstraints(),
              padding: EdgeInsets.zero,
              onPressed: _updateCode,
              splashRadius: 20.0,
              icon: Icon(
                Icons.edit,
                size: 24.0,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
          maxLines: 1,
          textAlignVertical: TextAlignVertical.center,
        ),
      ),
    );
  }
}
