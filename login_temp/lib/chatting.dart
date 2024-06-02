import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:login_temp/user_info.dart';
import 'package:login_temp/weather.dart';
import 'dart:convert';
import 'dart:async';
import 'main.dart';
import 'api_key.dart';

String myKey = APIKeys.myAPIKey;
//채팅 화면

Future<String> fetchGptResponse(String text) async {
  final response = await http.post(
    Uri.parse('http://10.0.2.2:8080/chat/ask'),
    body: jsonEncode({
      "question": text,
    }),
  );
  print(response.body);

  if (response.statusCode == 200) {
    var data = json.decode(response.body);
    print('$data');
    print(response.body);
    return '성공하였습니다.';
  } else {
    throw Exception('Failed to load GPT response');
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      theme: const CupertinoThemeData(
        textTheme: CupertinoTextThemeData(
          textStyle: TextStyle(
            fontFamily: 'MyKoreanFont',
            color: Colors.red// 전체 테마에 적용할 폰트 패밀리 지정
            // 다른 텍스트 스타일 속성들을 설정할 수 있습니다.
          ),
        ),

      ),
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}
final List<ChatMessage> messages = [];
class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _textController = TextEditingController();
  bool _isLoading = false; // 로딩 상태 관리 변수

  void _handleSubmitted(String text) async {
    _textController.clear();
    setState(() {
      _isLoading = true; // 로딩 시작
    });

    // 사용자 메시지를 채팅 목록에 추가
    _addMessage(text: text, isSentByMe: true);

    // "입력 중..." 메시지 추가
    final typingMessage = ChatMessage(
      text: "답변을 입력 중입니다...",
      isSentByMe: false,
    );
    setState(() {
      messages.insert(0, typingMessage);
    });

    try {
      String responseText = await fetchGptResponse(text);

      // "입력 중..." 메시지를 실제 응답으로 대체
      setState(() {
        _isLoading = false; // 로딩 완료
        messages.removeAt(0); // "입력 중..." 메시지 제거
        _addMessage(text: responseText, isSentByMe: false); // 실제 응답 메시지 추가
      });
    } catch (e) {
      setState(() {
        _isLoading = false; // 에러 발생 시 로딩 완료
        messages.removeAt(0); // "입력 중..." 메시지 제거
        _addMessage(text: "응답을 받아오는데 실패했습니다.", isSentByMe: false); // 에러 메시지 추가
      });
      print(e.toString());
    }
  }

  void _addMessage({required String text, required bool isSentByMe}) {
    ChatMessage message = ChatMessage(
      text: text,
      isSentByMe: isSentByMe,
    );
    setState(() {
      messages.insert(0, message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        backgroundColor: Colors.transparent,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => MyWeatherApp()));
            // MaterialPageRoute(builder: (context) => UserInfoScreen()));
          },
          child: Icon(
            CupertinoIcons.back,
            color: myBlue,
          ),
        ),
      ),
      child: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                reverse: true,
                itemCount: messages.length,
                itemBuilder: (BuildContext context, int index) {
                  return messages[index];
                },
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10, bottom: 15, left: 7, right: 7),
              decoration: BoxDecoration(
                border: Border.all(
                  color: myBlue, // 테두리 색상
                  width: 2.0, // 테두리 두께
                ),
                borderRadius: BorderRadius.circular(30.0), // 테두리의 둥근 모서리
              ),
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: CupertinoTextField(
                        padding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 10),
                        controller: _textController,
                        placeholder: '질문을 입력하세요',
                        onSubmitted: _handleSubmitted,
                        keyboardType: TextInputType.text,
                        cursorColor: myBlue,
                        maxLines: 5,
                        minLines: 1,
                        style: TextStyle(fontFamily: 'MyKoreanFont', color: Colors.black),

                        decoration: BoxDecoration(
                          // 이 부분을 수정하여 테두리를 제거합니다.
                          border: Border.all(
                              style: BorderStyle.none), // 테두리 스타일을 none으로 설정
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 2.5,
                      ),
                      child: SizedBox(
                        width: 30,
                        height: 30,
                        child: CupertinoButton(
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            String text = _textController.text.trim();
                            if (text.isNotEmpty) {
                              _handleSubmitted(text);
                            }
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: AssetImage('assets/images/Send.png'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isSentByMe;
  final double maxWidthRatio = 0.8; // 화면 너비의 일정 비율로 말풍선 최대 너비 설정

  const ChatMessage({Key? key, required this.text, this.isSentByMe = false})
      : super(key: key);

  String _getTime() {
    String time =
        "${DateTime.now().hour.toString().padLeft(2, '0')}:${DateTime.now().minute.toString().padLeft(2, '0')}";
    return time;
  }

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = TextStyle(
      fontFamily: 'MyKoreanFont',
      color: isSentByMe ? Colors.white : Colors.black,
      fontSize: 16.0,
    );

    return Column(
      crossAxisAlignment:
      isSentByMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment:
          isSentByMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            if (!isSentByMe)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  backgroundImage: AssetImage(
                      "assets/images/bittok_icon.png"), // 상대방 프로필 이미지
                ),
              ),
            Container(
              margin: EdgeInsets.only(
                left: isSentByMe ? 10 : 0,
                right: isSentByMe ? 0 : 10,
              ),
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * maxWidthRatio,
              ),
              decoration: BoxDecoration(
                color: isSentByMe ? myBlue : Colors.grey[200],
                borderRadius: BorderRadius.circular(12.0),
              ),
              padding: EdgeInsets.all(12.0),
              child: Text(
                text,
                style: textStyle,
              ),
            ),
            if (isSentByMe)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: CircleAvatar(
                  backgroundImage: AssetImage(
                      'assets/images/user_profile.png'), // 사용자 프로필 이미지
                ),
              ),
          ],
        ),
        Padding(
            padding: EdgeInsets.only(
              top: 4.0,
              right: isSentByMe ? 40 : 0,
              left: isSentByMe ? 0 : 40,
            ),
            child: Align(
              alignment: isSentByMe ? Alignment.topRight : Alignment.topLeft,
              child: Padding(
                padding: EdgeInsets.only(
                  bottom: 5, // 여기를 조절하여 시간 텍스트와 말풍선의 간격을 줄입니다.
                  right: isSentByMe ? 10 : 0,
                  left: isSentByMe ? 0 : 10,
                ),
                child: Text(
                  _getTime(),
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 12.0,
                    fontFamily: 'MyKoreanFont'
                  ),
                ),
              ),
            )),
      ],
    );
  }
}

