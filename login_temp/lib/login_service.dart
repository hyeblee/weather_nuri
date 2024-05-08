import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Service {
  Future<http.Response> saveMember(
      String memberemail, String memberpassword) async {
    var uri = Uri.parse("http://10.0.2.2:8080/member/login");
    Map<String, String> headers = {"Content-Type": "application/json"};

    Map data = {
      'memberEmail' : '$memberemail',
      'memberPassword' : '$memberpassword'
    };
    var body = json.encode(data);
    var response = await http.post(uri, headers: headers, body: body);

    print("${response.body}");

    return response;
  }
}