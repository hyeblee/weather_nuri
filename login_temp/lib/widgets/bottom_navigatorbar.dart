import 'package:flutter/material.dart';
import 'package:login_temp/user_info.dart';
import 'package:login_temp/chatting.dart';
import 'package:login_temp/weather.dart';

class BottomNavigator extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  BottomNavigator({required this.currentIndex, required this.onTap});

  @override
  _BottomNavigatorState createState() => _BottomNavigatorState();
}

class _BottomNavigatorState extends State<BottomNavigator> {
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
            MaterialPageRoute(builder: (context) => ChatScreen()),
          );
        }
        else{
          MaterialPageRoute(builder: (context) => UserInfoScreen());
        }
      },
    );
  }
}
