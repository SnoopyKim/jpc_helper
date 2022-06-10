import 'dart:async';
import 'dart:developer';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:jpc_second/data/member.dart';

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
        content: const Text('비밀번호가 일치하지 않습니다.'),
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
        child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _isAdmin
                ? Container(
                    constraints: const BoxConstraints(maxWidth: 1000),
                    padding: const EdgeInsets.all(30.0),
                    child: const EditContainer())
                : Container(
                    constraints: const BoxConstraints(maxWidth: 500),
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Column(
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
                  )),
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
  final DatabaseReference _database = FirebaseDatabase.instance.ref('jpc/second');
  late StreamSubscription<DatabaseEvent> changedSubscription;

  ScrollController manSC = ScrollController();
  ScrollController womanSC = ScrollController();
  ScrollController pairSC = ScrollController();

  TextEditingController phoneOneTec = TextEditingController();
  TextEditingController phoneTwoTec = TextEditingController();
  TextEditingController codeTec = TextEditingController();

  List<Member> userList = [];
  List<Map<String, dynamic>> pairList = [];
  int? selectedPairIdx;

  @override
  void initState() {
    init();
    changedSubscription = _database.child('members').onChildChanged.listen((event) {
      final member =
          Member.fromFirebase(event.snapshot.key.toString(), event.snapshot.value as Map);
      if (event.type == DatabaseEventType.childChanged) {
        updateUserList(member);
        removeMemberFromPair(member);
      }
      final idx = pairList.indexWhere((pair) => pair['code'] == member.code);
      if (idx != -1) {
        addMemberToPair(idx, member);
      }
    }, onError: (err) => log('ERROR! $err'));
    super.initState();
  }

  init() async {
    final codes = await _database.child('codes').get();
    for (var code in codes.children) {
      final map = {'code': code.value.toString(), 'one': '{}', 'two': '{}'};
      pairList.add(map);
    }

    final users = await _database.child("members").get();
    for (var m in users.children) {
      final member = Member.fromFirebase(m.key.toString(), m.value as Map);
      if (member.code.isNotEmpty) {
        final idx = pairList.indexWhere((pair) => pair['code'] == member.code);
        addMemberToPair(idx, member);
      }
      userList.add(member);
    }
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    changedSubscription.cancel();

    phoneOneTec.dispose();
    phoneTwoTec.dispose();
    codeTec.dispose();

    manSC.dispose();
    womanSC.dispose();
    pairSC.dispose();
  }

  updateUserList(Member member) {
    final idx = userList.indexWhere((m) => m.key == member.key);
    if (idx != -1) {
      userList[idx] = member;
      setState(() {});
    }
  }

  addCodeToMember(String key) {
    if (selectedPairIdx == null ||
        (pairList[selectedPairIdx!]['one'] != '{}' && pairList[selectedPairIdx!]['two'] != '{}'))
      return;
    String code = pairList[selectedPairIdx!]['code'];
    _database.child('members/$key').update({'code': code});
  }

  addMemberToPair(int idx, Member member) {
    if (pairList[idx]['one'] == '{}') {
      pairList[idx]['one'] = member.toJson();
    } else if (pairList[idx]['two'] == '{}') {
      pairList[idx]['two'] = member.toJson();
    }
    setState(() {});
  }

  removeMemberFromPair(Member member) {
    String result = '';
    int idx = pairList.indexWhere((pair) {
      if (pair['one'] != null && Member.fromJson(pair['one']).key == member.key) {
        result = 'one';
        return true;
      }
      if (pair['two'] != null && Member.fromJson(pair['two']).key == member.key) {
        result = 'two';
        return true;
      }
      return false;
    });
    if (idx != -1) {
      pairList[idx][result] = '{}';
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final manList = userList.where((e) => (e.gender == '남자') && (e.code.isEmpty)).toList();
    final womanList = userList.where((e) => e.gender == '여자' && e.code.isEmpty).toList();
    return Row(
      children: [
        SizedBox(
          width: 200,
          child: Column(
            children: [
              Text('남자 참가자'),
              Expanded(
                child: Scrollbar(
                  controller: manSC,
                  interactive: true,
                  thumbVisibility: true,
                  child: ListView.builder(
                    controller: manSC,
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    itemBuilder: (_, idx) {
                      final man = manList[idx];
                      return _MemberItem(
                        man.name,
                        man.phone,
                        onSelect: selectedPairIdx != null ? () => addCodeToMember(man.key) : null,
                      );
                    },
                    itemCount: manList.length,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          width: 200,
          child: Scrollbar(
            controller: womanSC,
            child: Column(
              children: [
                Text('여자 참가자'),
                Expanded(
                  child: ListView.builder(
                    controller: womanSC,
                    padding: const EdgeInsets.symmetric(vertical: 20.0),
                    itemBuilder: (_, idx) {
                      final woman = womanList[idx];
                      return _MemberItem(
                        woman.name,
                        woman.phone,
                        onSelect: selectedPairIdx != null ? () => addCodeToMember(woman.key) : null,
                      );
                    },
                    itemCount: womanList.length,
                  ),
                ),
              ],
            ),
          ),
        ),
        Expanded(
          child: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('짝'),
                Visibility(
                    visible: selectedPairIdx != null,
                    child: IconButton(
                        icon: Icon(Icons.edit_off_rounded, color: Theme.of(context).primaryColor),
                        onPressed: () => setState(
                              () {
                                selectedPairIdx = null;
                              },
                            )))
              ],
            ),
            Expanded(
              child: Scrollbar(
                controller: pairSC,
                child: ListView.builder(
                  controller: pairSC,
                  padding: const EdgeInsets.symmetric(vertical: 20.0),
                  itemBuilder: (_, idx) {
                    final pair = pairList[idx];
                    return GestureDetector(
                        behavior: HitTestBehavior.translucent,
                        onTap: () => setState(() {
                              selectedPairIdx = idx;
                            }),
                        child: _PairItem(
                            isSelected: selectedPairIdx == idx,
                            one: Member.fromJson(pair['one'] ?? "{}"),
                            two: Member.fromJson(pair['two'] ?? "{}"),
                            code: pair['code']));
                  },
                  itemCount: pairList.length,
                ),
              ),
            ),
          ]),
        )
      ],
    );
  }
}

class _MemberItem extends StatelessWidget {
  const _MemberItem(this.name, this.phone, {Key? key, this.onSelect}) : super(key: key);
  final String name;
  final String phone;
  final Function()? onSelect;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(name),
      subtitle: Text(phone),
      trailing: IconButton(
        icon: Icon(Icons.send_rounded),
        onPressed: onSelect,
        color: Theme.of(context).primaryColor,
      ),
    );
  }
}

class _PairItem extends StatelessWidget {
  const _PairItem({Key? key, this.isSelected = false, this.one, this.two, required this.code})
      : super(key: key);

  final isSelected;
  final Member? one, two;
  final String code;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border:
              Border.all(color: isSelected ? Theme.of(context).primaryColor : Colors.transparent)),
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            code,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
          ),
          const SizedBox(height: 4.0),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(
                      '멤버1',
                      textAlign: TextAlign.center,
                    ),
                    one?.key != ""
                        ? Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                children: [
                                  Text('${one!.name} | ${one!.gender}'),
                                  Text(one!.phone),
                                ],
                              ),
                              IconButton(
                                  onPressed: () {
                                    FirebaseDatabase.instance
                                        .ref('jpc/second/members/${one!.key}/code')
                                        .set(null);
                                  },
                                  icon: Icon(
                                    Icons.delete_rounded,
                                    color: Theme.of(context).primaryColor,
                                  ))
                            ],
                          )
                        : const SizedBox.shrink(),
                  ],
                ),
              ),
              Expanded(
                  child: Column(
                children: [
                  Text(
                    '멤버2',
                    textAlign: TextAlign.center,
                  ),
                  two?.key != ""
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              children: [
                                Text('${two!.name} | ${two!.gender}'),
                                Text(two!.phone),
                              ],
                            ),
                            IconButton(
                                onPressed: () {
                                  FirebaseDatabase.instance
                                      .ref('jpc/second/members/${two!.key}/code')
                                      .set(null);
                                },
                                icon: Icon(
                                  Icons.delete_rounded,
                                  color: Theme.of(context).primaryColor,
                                ))
                          ],
                        )
                      : const SizedBox.shrink(),
                ],
              ))
            ],
          )
        ],
      ),
    );
  }
}
