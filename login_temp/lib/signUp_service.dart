import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Service {
  Future<String> loginMember(
      String memberemail, String memberpassword) async {
    var uri = Uri.parse("http://34.64.61.102:8080/member/login");
    Map<String, String> headers = {"Content-Type": "application/json"};

    Map data = {
      'memberEmail' : '$memberemail',
      'memberPassword' : '$memberpassword'
    };
    var body = json.encode(data);
    var response = await http.post(uri, headers: headers, body: body);
    print(response);
    print("!!${response.body}");
    String message = response.body.toString();
    print(message);
    return message;
  }

  Future<http.Response> signUpMember(
      String membername, String memberemail, String memberpassword, String gender, String hot) async {
    var uri = Uri.parse("http://34.64.61.102:8080/member/save");
    Map<String, String> headers = {"Content-Type": "application/json"};

    Map data = {
      'memberEmail' : '$memberemail',
      'memberPassword' : '$memberpassword',
      'memberName' : '$membername',
      'gender' : '$gender',
      'hot' : '$hot',
    };
    var body = json.encode(data);
    var response = await http.post(uri, headers: headers, body: body);

    print("${response}");

    return response;
  }
}