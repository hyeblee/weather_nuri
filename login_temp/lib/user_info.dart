import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_temp/main.dart';
import 'package:login_temp/sign_up.dart' as signup;
import 'package:login_temp/user_info_edit.dart';
import 'package:login_temp/weather.dart';
import 'package:login_temp/chatting.dart';
import 'package:login_temp/user_info_edit.dart';
import 'widgets/bottom_navigatorbar.dart';

String nickname = '비똑이';
TextEditingController nameController = TextEditingController(text: nickname); // 전역 변수로 컨트롤러 선언

void main() {
  runApp(UserInfoScreen());
}

class User {
  String name;
  String email;
  int age;

  User({required this.name, required this.email, required this.age});
}

class UserInfoScreen extends StatefulWidget {
  @override
  _UserInfoScreenState createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  // late User _user;

  @override
  void initState() {

    print('USerID=$nickname');
    super.initState();
    // _user = User(name: '비똑이', email: 'john@example.com', age: 30);
    nameController = TextEditingController(text: nickname);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          fontFamily: 'MyKoreanFont',
          textSelectionTheme: TextSelectionThemeData(cursorColor: myBlue)),
      home: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 100.0),
                Center(
                  child: Image.asset(
                    'assets/images/user_profile.png', // 프로필 이미지 경로
                    width: 180.0, // 원하는 너비로 설정
                    height: 180.0, // 원하는 높이로 설정
                    fit: BoxFit.cover, // 이미지를 컨테이너에 맞추어 확대
                  ),
                ),
                SizedBox(height: 100),
                TextField(
                  controller: nameController,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: '닉네임',
                    hintText: 'Enter your nickname',
                    enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey)),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 32.0),
                ElevatedButton(
                  onPressed: () {
                    print('change');
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => UserInfoEditScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFE8EFFF), // 버튼 배경색을 파란색으로 설정
                    textStyle: TextStyle(
                        fontFamily: 'MyKoreanFont'), // 버튼 텍스트 색상을 흰색으로 설정
                  ),
                  child: Text(
                    'Edit',
                    style: TextStyle(color: myBlue),
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    messages.clear();
                    // 로그아웃 동작
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyLoginPage()),
                    );
                    print('end');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFE8EFFF), // 버튼 배경색을 파란색으로 설정
                    textStyle: TextStyle(
                        fontFamily: 'MyKoreanFont'), // 버튼 텍스트 색상을 흰색으로 설정
                  ),
                  child: Text(
                    'Logout',
                    style: TextStyle(color: myBlue),
                  ),
                ),
              ],
            ),
          ),
        ),
          bottomNavigationBar: MyBottomNavigator(
            currentIndex: 2,
            onTap: (currentIndex) {
              if (currentIndex == 0) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyWeatherApp()),
                );
              } else if (currentIndex == 1) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ChatScreen()),
                );
              } else if (currentIndex == 2) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserInfoScreen()),
                );
              }
            },
          ),

      ),
    );
  }
}
