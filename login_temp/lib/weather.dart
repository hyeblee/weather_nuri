import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart'; // 플러터 머티리얼 패키지 임포트
import 'package:login_temp/user_info.dart';
import 'sign_up.dart'; // 회원가입 화면 클래스 임포트
import 'chatting.dart'; // 채팅 화면 클래스 임포트
import 'main.dart'; // 메인 화면 클래스 임포트
import 'package:http/http.dart' as http; // HTTP 패키지 임포트
import 'dart:convert'; // JSON 디코딩을 위한 패키지 임포트

String cityDong = '광진구 군자동';

class HourWeatherWidget extends StatelessWidget {
  final String hour;
  final String weatherImage;
  final String degree;

  HourWeatherWidget({
    required this.hour,
    required this.weatherImage,
    required this.degree,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.all(10), // 간격 추가
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
            border: Border.all(
              // 박스 테두리 추가
              color: mySky, // 테두리 색상 설정
              width: 2.0, // 테두리 두께 설정
            ),
          ),
          child: Padding(
            padding: EdgeInsets.only(), // 내부 여백 추가
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(),
                  child: Text(
                    hour,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: myBlue,
                    ),
                  ),
                ),

                SizedBox(height: 1,
                  width: 65,
                  child: Divider(thickness: 2, color: mySky,),
                ),
                SizedBox(height: 5),
                Image.asset(
                  'assets/images/${weatherImage}.png',
                  width: 50,
                  height: 50,
                ),
                SizedBox(height: 5),
                Text(
                  degree,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: myBlue,
                  ),
                ),
              ],
            ),
          ),
        ),

      ],
    );
  }
}



void main() {
  runApp(MyWeatherApp()); // MyWeatherApp 위젯을 루트로 하는 앱 실행
}

class MyWeatherApp extends StatefulWidget {
  @override
  _MyWeatherAppState createState() =>
      _MyWeatherAppState(); // 상태를 관리하는 State 클래스 반환
}

class _MyWeatherAppState extends State<MyWeatherApp> {
  List<Map<String, dynamic>> dataList = []; // 날씨 데이터를 저장할 리스트

  void initState() {
    // print(getAddress());
    super.initState();
  }

  Future<void> getWeathers() async {
    //날씨 받아오는 함수
    getAddress();
    final response = await http
        .get(Uri.parse('http://10.0.2.2:3500')); // 서버로부터 데이터를 가져오는 비동기 함수
    if (response.statusCode == 200) {
      // HTTP 상태 코드가 200(성공)인 경우
      List<dynamic> weatherJsonList = jsonDecode(response.body); // JSON 데이터 디코딩
      print('Received data: $weatherJsonList'); // 받은 데이터 콘솔에 출력
      setState(() {
        // 상태 갱신
        dataList =
            weatherJsonList.cast<Map<String, dynamic>>(); // JSON 데이터를 리스트에 저장
        print(dataList);
        getAddress();
      });
    } else {
      // HTTP 상태 코드가 200이 아닌 경우
      print(
          'Failed to fetch data: ${response.statusCode}'); // 데이터 가져오기 실패 메시지 출력
      throw Exception('Failed to load data'); // 데이터 로드 실패 예외 발생
    }
  }

  Future<String> getAddress() async {
    // myUser.latitude = 35.80157686712525; //전주위도
    // myUser.longitude = 127.13015405967384; //전주경도
    // myUser.latitude = 37.550773227800875;
    // myUser.longitude = 127.07554415194865;

    final url =
        'https://maps.googleapis.com/maps/api/geocode/json?latlng=${myUser.latitude},${myUser.longitude}&language=ko&key=AIzaSyB1TWtIaTe67-W9KQLXM3JYvFpo8FRCkVE';
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'MyKoreanFont'),
      // 앱을 머티리얼 디자인으로 구성
      home: Scaffold(
        // 기본 앱 구조인 스캐폴드 생성
        body: Padding(
          padding: const EdgeInsets.only(top: 40, left: 10, right: 10),
          child: SizedBox(
            // 바디 중앙 정렬
            child: Container(
              child: Column(
                // 세로 방향으로 위젯을 배치하는 컬럼
                mainAxisAlignment: MainAxisAlignment.start,
                // 메인 축(수직축)을 중앙으로 정렬
                children: <Widget>[
                  // 자식 위젯 목록
                  SizedBox(height: 10),
                  Text(
                    cityDong,
                    style: TextStyle(color: myBlue),
                  ),
                  SizedBox(
                    height: 300,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal, // 가로 스크롤을 위해 추가
                      // itemCount: dataList.length,
                      itemCount: 24,
                      itemBuilder: (BuildContext context, int index) {
                        return HourWeatherWidget(
                          hour: '15:00',
                          weatherImage: 'sun',
                          degree: '21℃',
                        );
                      },
                    ),
                  ),
                  ElevatedButton(
                    // 눌러서 액션을 수행할 수 있는 버튼
                    onPressed: getWeathers, // 버튼을 눌렀을 때 fetchData 함수 호출
                    // onPressed: () {},
                    child: Text('Fetch Data'), // 버튼 텍스트 설정
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.sunny),
              label: 'Weather',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
          onTap: (int index) {
            if (index == 1) { // Chat 아이콘을 클릭했을 때
              Navigator.push( // Chat 페이지로 이동
                context,
                MaterialPageRoute(builder: (context) => ChatScreen()),
              );
            }
            else if (index == 2) { // Chat 아이콘을 클릭했을 때
              Navigator.push( // Chat 페이지로 이동
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
