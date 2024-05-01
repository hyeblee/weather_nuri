//회원가입 화면

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'chatting.dart';
import 'main.dart';

enum Gender {
  // 성별 자료형
  female,
  male,
  none
}

//유저 정보 담는 클래스
class User {
  late String name;
  late String userID;
  late String password;
  Gender gender = Gender.none; // late는 나중에 꼭 초기화 해줄거라는 뜻
  bool agree = false;

  User() {}
}

//텍스트 필드 만드는 함수
Widget buildTextField(String placeholder, TextEditingController controller) {
  return CupertinoTextField(
    padding: EdgeInsets.only(left: 15, top: 8, bottom: 8),
    placeholder: placeholder,
    decoration: BoxDecoration(
      border: Border.all(color: myBlue),
      borderRadius: BorderRadius.circular(10),
    ),
    controller: controller,
  );
}

//에러 메세지 출력 함수
void showErrorDialog(BuildContext context, String errorMessage) {
  showCupertinoDialog(
    context: context,
    builder: (BuildContext context) {
      return CupertinoAlertDialog(
        title: Text('에러'),
        content: Text(errorMessage), // 전달된 에러 메시지를 표시
        actions: <Widget>[
          CupertinoDialogAction(
            child: Text('확인'),
            onPressed: () {
              Navigator.of(context).pop(); // 다이얼로그 닫기
            },
          ),
        ],
      );
    },
  );
}


final TextEditingController _nameController = TextEditingController();
final TextEditingController _userIDController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

String setUser(User user) {
  //user정보 채우고 함수 빈 값의 텍스트 필드 알려주는 함수
  if (_nameController.text.isEmpty) return 'username';
  user.name = _nameController.text;

  if (_userIDController.text.isEmpty) return 'userID';
  user.userID = _userIDController.text;

  if (_passwordController.text.isEmpty) return 'password';
  user.password = _passwordController.text;

  if (user.gender == Gender.none) return 'gender';

  if(user.agree == false) return 'location';
  return 'success';
}

User user = User();

class _SignUpScreenState extends State {
  // 성별 버튼 클릭시 호출되는 함수
  void selectGender(Gender gender) {
    setState(() {
      user.gender = gender;
      print(user.gender);
    });
  }

  void signUp() {
    print('gender = ${user.gender}');
    print('location = ${user.agree}');
    String result = setUser(user);
    if (result == 'success') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyLoginPage()),
      );
      return;
    }
    else if (result == 'username') {
     showErrorDialog(context, '이름(닉네임)을 입력하세요');
    } else if (result == 'userID') {
      print('enter userID');
      showErrorDialog(context, '아이디를 입력하세요');
    } else if (result == 'password') {
      print('enter password');
      showErrorDialog(context, '비밀번호를 입력하세요');
    } else if (result == 'gender') {
      showErrorDialog(context, '성별을 선택하세요');
      print('choose gender');
    } else if (result == 'location') {
      showErrorDialog(context, '위치정보 제공에 동의해주세요!');
      print('agree location');
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: Colors.transparent,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MyLoginPage()));
          },
          child: Icon(
            CupertinoIcons.back,
            color: myBlue,
          ),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                SizedBox(
                  height: 50,
                ),
                Image.asset(
                  'assets/images/bittok_icon.png',
                  width: 100,
                  height: 200,
                ),
                SizedBox(
                  height: 50,
                ),
                buildTextField('이름(닉네임)', _nameController),
                SizedBox(
                  height: 20,
                ),
                buildTextField('아이디', _userIDController),
                SizedBox(
                  height: 20,
                ),
                buildTextField('비밀번호', _passwordController),
                SizedBox(height: 20),
                Row(
                  children: [
                    CupertinoButton(
                        color: user.gender == Gender.female
                            ? myBlue
                            : myBlue.withOpacity(0.5),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              '여성',
                              style: TextStyle(color: CupertinoColors.white),
                            ),
                          ),
                        ),
                        onPressed: () {
                          selectGender(Gender.female);
                        }),
                    CupertinoButton(
                        color: user.gender == Gender.male
                            ? myBlue
                            : myBlue.withOpacity(0.5),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Center(
                            child: Text(
                              '남성',
                              style: TextStyle(color: CupertinoColors.white),
                            ),
                          ),
                        ),
                        onPressed: () {
                          selectGender(Gender.male);
                        }),
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                ),
                SizedBox(height: 40),
                Row(
                  children: [
                    Text(
                      '위치 정보를 제공하는 것에\n동의하십니까?',
                      style: TextStyle(
                        color: CupertinoColors.systemGrey,
                        fontSize: 20,
                      ),
                    ),
                    Container(
                      width: 110, // 체크박스의 가로 크기 조정
                      height: 50,
                      child: CupertinoCheckbox(
                        value: user.agree,
                        onChanged: (value) {
                          setState(() {
                            user.agree = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 40),
                CupertinoButton(
                    color: myBlue,
                    child: Container(
                      decoration: BoxDecoration(
                        color: myBlue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Text(
                          '회원가입 완료하기',
                          style: TextStyle(color: CupertinoColors.white),
                        ),
                      ),
                    ),
                    onPressed: () {
                      signUp();
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
