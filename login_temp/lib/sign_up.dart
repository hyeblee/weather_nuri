//회원가입 화면

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'main.dart';
import 'package:geolocator/geolocator.dart';
import 'signUp_service.dart';

Service service = Service();
int radiobutton_hot = 0;

// 위치 정보 가져오는 함수
void getLocation(User user) async {
  try {
    LocationPermission permission = await Geolocator.requestPermission();
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    String _latitude = position.latitude.toString();
    String _longitude = position.longitude.toString();
    print('Latitude: ${_latitude}, Longitude: ${_longitude}');

    user.latitude = position.latitude;
    user.longitude = position.longitude;
  } catch (e) {
    print('Error: $e');
  }
}

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
  late double latitude;
  late double longitude;
  late int hot_degree;
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
    style: TextStyle(color: Colors.black, fontFamily: "MyKoreanFont"),
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

late TextEditingController _nameController = TextEditingController();
late TextEditingController _userIDController = TextEditingController();
late TextEditingController _passwordController = TextEditingController();

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

  if (user.agree == false) return 'location';
  getLocation(user);

  if (user.hot_degree == false) return 'hot';
  user.hot_degree = radiobutton_hot;

  return 'success';
}



class _SignUpScreenState extends State {
  // 성별 버튼 클릭시 호출되는 함수
  void selectGender(Gender gender) {
    setState(() {
      myUser.gender = gender;
      print(myUser.gender);
    });
  }

  void signUp() {
    print('gender = ${myUser.gender}');
    print('location = ${myUser.agree}');
    String result = setUser(myUser);
    if (result == 'success') {
      service.signUpMember(myUser.name, myUser.userID, myUser.password,
          myUser.gender.toString(), myUser.hot_degree.toString());
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyLoginPage()),
      );
      return;
    } else if (result == 'username') {
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
    } else if (result == 'hot') {
      showErrorDialog(context, '추위를 느끼는 정도를 선택해주세요!');
      print('hot');
    }
  }

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _userIDController = TextEditingController();
    _passwordController = TextEditingController();
  }

  Widget build(BuildContext context) {
    theme:
    CupertinoThemeData(
        textTheme: CupertinoTextThemeData(
            textStyle:
                TextStyle(fontFamily: 'MyKoreanFont', color: Colors.black)));
    return CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
          backgroundColor: Colors.transparent,
          leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => MyLoginPage()));
            },
            child: Icon(
              CupertinoIcons.back,
              color: myBlue,
            ),
          ),
        ),
        child: SingleChildScrollView(
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
                            color: myUser.gender == Gender.female
                                ? myBlue
                                : myBlue.withOpacity(0.5),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  '여성',
                                  style: TextStyle(
                                      color: CupertinoColors.white,
                                      fontFamily: "MyKoreanFont"),
                                ),
                              ),
                            ),
                            onPressed: () {
                              selectGender(Gender.female);
                            }),
                        CupertinoButton(
                            color: myUser.gender == Gender.male
                                ? myBlue
                                : myBlue.withOpacity(0.5),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  '남성',
                                  style: TextStyle(
                                      color: CupertinoColors.white,
                                      fontFamily: "MyKoreanFont"),
                                ),
                              ),
                            ),
                            onPressed: () {
                              selectGender(Gender.male);
                            }),
                      ],
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      '추위를 느끼는 정도를 선택해주세요!',
                      style: TextStyle(
                          color: CupertinoColors.black,
                          fontSize: 18,
                          fontFamily: "MyKoreanFont"),
                    ),
                    const SizedBox(height: 20),

                    Row(
                      children: [
                        CupertinoRadio<int>(
                          value: 1, // 이 옵션의 값
                          groupValue: radiobutton_hot, // 그룹 내 현재 선택된 값
                          onChanged: (value) {
                            setState(() {
                              radiobutton_hot = value!; // 선택된 값 업데이트
                            });
                          },
                          activeColor: myBlue,
                        ),
                        Text(' 추위를 많이 타요.', style: TextStyle(color: Colors.black),),
                      ],
                    ),
                    Row(
                      children: [
                        CupertinoRadio<int>(
                          value: 2, // 이 옵션의 값
                          groupValue: radiobutton_hot, // 그룹 내 현재 선택된 값
                          onChanged: (value) {
                            setState(() {
                              radiobutton_hot = value!; // 선택된 값 업데이트
                            });
                          },
                          activeColor: myBlue,
                        ),
                        Text(' 평균이에요.', style: TextStyle(color: Colors.black),),
                      ],
                    ),
                    Row(
                      children: [
                        CupertinoRadio<int>(
                          value: 3, // 이 옵션의 값
                          groupValue: radiobutton_hot, // 그룹 내 현재 선택된 값
                          onChanged: (value) {
                            setState(() {
                              radiobutton_hot = value!; // 선택된 값 업데이트
                            });
                          },
                          activeColor: myBlue,
                        ),
                        Text(' 더위를 많이 타요.', style: TextStyle(color: Colors.black),),
                      ],
                    ),
                    const SizedBox(height: 20),

                    Row(
                      children: [
                        const Text(
                          '위치 정보를 제공하는 것에 동의하십니까?',
                          style: TextStyle(
                              color: CupertinoColors.systemGrey,
                              fontSize: 18,
                              fontFamily: "MyKoreanFont"),
                        ),
                        Spacer(),
                        Container(
                          width: 50, // 체크박스의 가로 크기 조정
                          height: 50,
                          child: CupertinoCheckbox(
                            value: myUser.agree,
                            onChanged: (value) {
                              setState(() {
                                myUser.agree = value!;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
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
                              style: TextStyle(
                                  color: CupertinoColors.white,
                                  fontFamily: "MyKoreanFont"),
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
        ));
  }
}
