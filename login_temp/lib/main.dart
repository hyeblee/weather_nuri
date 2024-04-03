import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Flutter Demo',
      home: const MyLoginPage(),
    );
  }
}

class MyLoginPage extends StatefulWidget {
  const MyLoginPage({super.key});

  @override
  State<MyLoginPage> createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  // TextEditingController instances can be used to retrieve the current value
  // of CupertinoTextField widgets.
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() {
    // Here you would usually include your logic for validating login credentials.
    print('Attempting to log in with username ${_usernameController.text} and password ${_passwordController.text}');
  }

  void _signup() {
    // Here you might navigate to a different widget that handles user sign-up.
    print('Navigating to sign-up screen.');
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 90),
          child: Column(

            children: <Widget>[
              Image.asset("assets/images/bittok_icon.png", width: 170, height: 170,),//아이콘 이미지
              SizedBox(height: 30),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 40.0),
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),// 내부 여백을 추가하여 텍스트 필드 내의 텍스트 위치를 조정합니다.
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(0xFF4073D7), 
                    width: 1.0, 
                  ),
                  borderRadius: BorderRadius.circular(8.0), 
                ),
                child: CupertinoTextField(// 아이디 텍스트필드
                  controller: _usernameController,// 아이디 컨트롤러
                  placeholder: '아이디',
                  decoration: BoxDecoration(), 
                ),
              ),
              SizedBox(height: 20),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 40.0),
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(0xFF4073D7), 
                    width: 1.0, 
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: CupertinoTextField(//비밀번호 텍스트필드
                  controller: _passwordController,//비밀번호 컨트롤러
                  placeholder: '비밀번호',
                  decoration: BoxDecoration(), 
                ),
              ),
              SizedBox(height: 100),
              SizedBox(
                width: 310,
                height: 50,
                child: CupertinoButton(
                  child: Text('로그인',style: TextStyle(fontSize: 18),),
                  onPressed: _login,
                  color: Color(0xFF4073D7),
                ),
              ),
              SizedBox(height: 20), 
              SizedBox(
                width: 310,
                height: 50,
                child: CupertinoButton(
                  child: Text('회원가입',style: TextStyle(fontSize: 18),),
                  onPressed: _signup,
                  color: Color(0xFF4073D7),
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
