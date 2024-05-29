import 'package:flutter/material.dart';
import 'package:login_temp/main.dart';
import 'package:login_temp/user_info.dart';
import 'package:login_temp/chatting.dart';
import 'package:login_temp/weather.dart';

class MyBottomNavigator extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  MyBottomNavigator({required this.currentIndex, required this.onTap});

  @override
  _MyBottomNavigatorState createState() => _MyBottomNavigatorState();
}

class _MyBottomNavigatorState extends State<MyBottomNavigator> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: widget.currentIndex,
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
      onTap: (currentIndex) {
        if (currentIndex == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyWeatherApp()),
          );
        } else if (currentIndex == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyLoginPage()),
            // MaterialPageRoute(builder: (context) => ChatScreen()),
          );
        } else if (currentIndex == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => UserInfoScreen()),
          );
        }
      },
    );
  }
}
