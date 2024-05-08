import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_temp/api_key.dart';
import 'chatting.dart';
import 'sign_up.dart';
import 'login_service.dart';

const Color myBlue = Color(0xFF4073D7);
const Color mySky = Color(0xFFABC3FF);

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Flutter Demo',
      home: MyLoginPage(),
      // home: SignUpScreen(), // Temporary skipping login functionality.
    );
  }
}

class MyLoginPage extends StatefulWidget {
  const MyLoginPage({Key? key}) : super(key: key);

  @override
  State<MyLoginPage> createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  Service service = Service();

  void _login() {
    if(_usernameController.text == 'aaaa' && _passwordController.text == '1111') {
      print('Attempting to log in with username ${_usernameController.text} and password ${_passwordController.text}');
      print('Login success!');

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ChatScreen()),
      );
    }
  }

  void _signup() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => SignUpScreen()),
    );
  }

  Widget _buildTextField({
    TextEditingController? controller,
    String? placeholder,
    bool obscureText = false,
  }) {
    return Container(
      // margin: EdgeInsets.symmetric(horizontal: 40.0),
      padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(
          color: myBlue,
          width: 1.0,
        ),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: CupertinoTextField(
        controller: controller,
        placeholder: placeholder,
        obscureText: obscureText,
        decoration: BoxDecoration(),
      ),
    );
  }

  Widget _buildButton({String? text, VoidCallback? onPressed}) {
    return SizedBox(
      width: double.infinity, // 버튼을 화면 가로폭에 맞추기 위해
      child: CupertinoButton(
        child: Text(text ?? '', style: TextStyle(fontSize: 18)),
        onPressed: onPressed,
        color: myBlue,
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 90),
          child: Column(
            children: <Widget>[
              Image.asset("assets/images/bittok_icon.png", width: 200, height: 200,),
              Padding(
                padding: const EdgeInsets.only(left: 35, right: 35),
                child: Column(
                  children: [
                    SizedBox(height: 40),
                    _buildTextField(controller: _usernameController, placeholder: '아이디'),
                    SizedBox(height: 30),
                    _buildTextField(controller: _passwordController, placeholder: '비밀번호', obscureText: true),
                    SizedBox(height: 80),
                    _buildButton(text: '로그인 하기', onPressed: _login),
                    SizedBox(height: 20),
                    _buildButton(text: '회원가입 하기', onPressed: _signup),
                  ],
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
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
