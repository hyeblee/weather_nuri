import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_temp/api_key.dart';
import 'package:login_temp/sign_up.dart';
import 'package:login_temp/user_info.dart';
import 'package:login_temp/user_info_edit.dart';
import 'package:login_temp/weather.dart';
import 'chatting.dart';
import 'sign_up.dart' as signUp;
import 'package:login_temp/signUp_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

signUp.User myUser = signUp.User();
String UserID = '아이디';

Future<String> getAddress() async {
  // myUser.latitude = 35.80157686712525; //전주위도
  // myUser.longitude = 127.13015405967384; //전주경도
  // myUser.latitude = 37.550773227800875;
  // myUser.longitude = 127.07554415194865;

  // myUser.latitude =  36.0623237;
  // myUser.longitude = 126.7067309;

  final url =
      'https://maps.googleapis.com/maps/api/geocode/json?latlng=${myUser.latitude},${myUser.longitude}&language=ko&key=${googleAPIKey}';
  final response = await http.get(Uri.parse(url));
  Map<String, dynamic> data = jsonDecode(response.body);
  List<dynamic> results = data['results'];
  String formattedAddresses = results[0]['formatted_address'];
  List<String> split_addresses = formattedAddresses.split(' ');
  String city = split_addresses[2];
  String dong = split_addresses[3];


  cityDong = city + ' ' + dong;
  print('citydong = $cityDong');
  return cityDong;
}

Future<void> postLocation(double latitude, double longitude) async {
  print('start');

  final url = Uri.parse("http://10.0.2.2:3500/latitude_longitude");
  final response = await http.post(
    url,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'latitude': latitude, 'longitude': longitude}),
  );

  if (response.statusCode == 200) {
    final responseData = jsonDecode(response.body);
    print('Result: ${responseData['latitude']}');
  } else {
    print('Error: ${response.statusCode}');
  }

  print('end');

}

const Color myBlue = Color(0xFF4073D7);
const Color mySky = Color(0xFFABC3FF);
Service myService = Service();


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Flutter Demo',
      theme: CupertinoThemeData(
        textTheme: CupertinoTextThemeData(textStyle: TextStyle(fontFamily: 'MyKoreanFont'))
      ),
      // home: MyWeatherApp()
      home: MyLoginPage(),
      // home: ChatScreen(),
      // home: SignUpScreen(),
      // home: UserInfoEditScreen(),
      // home: UserInfoScreen(),
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


  @override
  void initState() {
    super.initState();
    getLocation(myUser);
    //주석 해제해야함!!!
    print('InitState: Login Page initialized');
  }


  void _login() async {
    print("login start");
    Service myService = Service();
    String LoginResponse = await myService.loginMember(_usernameController.text.toString(), _passwordController.text.toString());
    print("${LoginResponse},,");

    //우선 임시로 추가해놓은 부분 삭제할 것
    // myUser.latitude = 35.80157686712525; //전주위도
    // myUser.longitude = 127.13015405967384; //전주경도
    //우선 임시로 추가해놓은 부분 삭제할 것


    // await postLocation(myUser.latitude, myUser.longitude);
    // await getAddress();
    print("ee");

    if(LoginResponse == 'success'){
    // if(_usernameController.text == 'bittok' && _passwordController.text == '0000') {
      print('Attempting to log in with username ${_usernameController.text} and password ${_passwordController.text}');
      print('Login success!');
      UserID = _usernameController.text.toString();
      print('id = $UserID');
      await postLocation(myUser.latitude, myUser.longitude);
      await getAddress();
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyWeatherApp()),
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
        style: TextStyle(color: Colors.black, fontFamily: "MyKoreanFont"),
      ),
    );
  }

  Widget _buildButton({String? text, VoidCallback? onPressed}) {
    return SizedBox(
      width: double.infinity, // 버튼을 화면 가로폭에 맞추기 위해
      child: CupertinoButton(
        child: Text(text ?? '', style: TextStyle(fontSize: 18, fontFamily: "MyKoreanFont")),
        onPressed: onPressed,
        color: myBlue,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
        child: SingleChildScrollView(
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
    )
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
