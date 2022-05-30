import 'package:flutter/material.dart';

class SecondScreen extends StatefulWidget {
  const SecondScreen({Key? key}) : super(key: key);

  @override
  State<SecondScreen> createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  String _input = '';

  goNext() {
    // 다른 페이지로 인수 값을 넘길땐 여러 방법이 있지만 argument에 담아보내는게 일반적
    // 블로그 같은 형식일 경우 route 자체에 parameter를 더해서 보내는 경우가 대부분
    // + 우리의 경우 다음 페이지에서 반드시 필요로 하는 정보가 있으므로 (번호)
    // + 여기서 입력값에 대한 validate를 해주거나,
    // + 다음 페이지에서 에러 페이지를 고려해야함.
    // + 이번 케이스에선 둘다 필요할 듯 (여기선 번호 입력에 대한 validate, 다음 페이지에선 DB에 있는지 검사)
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
              // 호옹 styleFrom으로 커스텀한거 개 굳
              // 만약 완전 자유롭게? 만들고 싶다면 GestureDetector가 있음
              style: TextButton.styleFrom(
                  padding: const EdgeInsets.all(20.0),
                  textStyle: const TextStyle(fontSize: 20),
                  primary: Colors.white,
                  backgroundColor: Color(0xFF172E63)),
              // 인자가 같을 경우는 Arrow Function 말고 그냥
              onPressed: () => goNext(),
              child: Text('NEXT'),
            )
          ],
        ),
      ),
    ));
  }

  // state에 따른 변경되는 위젯이 아니거나,
  // 가독성을 높이기 위해서가 아니라면 함수로 빼서 렌더링하는 거는 굳이 불필요
  // 위젯 클래스나 직접 박으면 해당 위젯이 재활용?이 되는 반면에
  // 함수로 렌더링할 경우 똑같은 위젯이여도 아예 삭제 후 재생성을 하기에 성능 상 이슈가 있음
  // (사실 큰 차이 없음 state에 따라 변하는 게 아닌 이상은 거의 고려안해도 될 정도)
  Widget logo() {
    return Image.asset('assets/images/logo.png', width: 217);
    // 참고로 Image에서 width는 보통 이미지를 담고 있는 박스? 의 크기를 뜻함
    // 이미지 자체는 그 안에 BoxFit 설정에 따라 렌더링되는거 (자동 resize?)
  }
}
