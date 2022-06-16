import 'package:flutter/material.dart';

class SecondScreen extends StatefulWidget {
  const SecondScreen({Key? key}) : super(key: key);

  @override
  State<SecondScreen> createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  final formKey = GlobalKey<FormState>();

  goNext(String input) {
    if (formKey.currentState?.validate() ?? false) {
      Navigator.pushNamed(context, '/second/present', arguments: input);
    }
  }

  String? phoneValidator(String? phone) {
    if (phone == null || phone.replaceAll(' ', '').isEmpty) {
      return '번호를 입력해주세요';
    }

    if (!RegExp(r'^[0-9](\d{10,10})').hasMatch(phone)) {
      return '숫자로 11자리를 입력해주세요';
    }

    return null;
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
            Image.asset('assets/images/logo.png', width: 217),
            const Text(
              '당신의 파트너는 누구일까요?',
              textScaleFactor: 1.0,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            const SizedBox(height: 30.0),
            Form(
              key: formKey,
              child: TextFormField(
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                    labelText: "전화번호('-' 없이 입력하세요)",
                    hintText: '01012345678',
                    contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5.0)),
                validator: phoneValidator,
                onFieldSubmitted: (input) => goNext(input),
                onSaved: (input) => goNext(input ?? ''),
              ),
            ),
            const SizedBox(height: 30.0),
            TextButton(
              style: TextButton.styleFrom(
                  padding: const EdgeInsets.all(20.0),
                  textStyle: const TextStyle(fontSize: 20),
                  primary: Colors.white,
                  backgroundColor: const Color(0xFF172E63)),
              onPressed: () => formKey.currentState?.save(),
              child: const Text('NEXT'),
            )
          ],
        ),
      ),
    ));
  }
}
