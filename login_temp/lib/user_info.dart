import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:login_temp/main.dart';
import 'package:login_temp/weather.dart';
import 'package:login_temp/chatting.dart';
import 'widgets/bottom_navigatorbar.dart';

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
  // 가짜 사용자 데이터
  User _user = User(name: 'John Doe', email: 'john@example.com', age: 30);

  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _ageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // 현재 사용자 정보로 컨트롤러 초기화
    _nameController.text = _user.name;
    _emailController.text = _user.email;
    _ageController.text = _user.age.toString();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'MyKoreanFont'),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Edit User Info'),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Name:',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'Enter your name',
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Email:',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'Enter your email',
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Age:',
                style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              ),
              TextField(
                controller: _ageController,
                decoration: InputDecoration(
                  hintText: 'Enter your age',
                ),
              ),
              SizedBox(height: 32.0),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // 수정된 정보 저장
                    setState(() {
                      _user.name = _nameController.text;
                      _user.email = _emailController.text;
                      _user.age = int.tryParse(_ageController.text) ?? 0;
                    });
                    // 여기서 수정된 정보를 서버에 전송하거나 로컬에 저장할 수 있습니다.
                    // 저장 후 이전 화면으로 돌아가는 등의 작업을 수행할 수 있습니다.
                  },
                  child: Text('Save'),
                ),
              ),
              SizedBox(height: 16.0), // 로그아웃 버튼과의 간격을 주기 위해 추가
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // 로그아웃 동작
                    messages.clear();
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => MyLoginPage()), // 로그인 화면으로 이동
                    );
                  },
                  child: Text('Logout'), // 로그아웃 버튼 텍스트
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: MyBottomNavigator(currentIndex: 2,onTap: (currentIndex) {
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
        }

      ),
    ),
    );
  }
}
