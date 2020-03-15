import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tracery_app/api/user_repository.dart';
import 'package:tracery_app/screens/account_screen.dart';
import 'package:tracery_app/screens/history_screen.dart';
import 'package:tracery_app/screens/near_me.dart';
import 'package:tracery_app/screens/qrcode_screen.dart';
import 'package:tracery_app/screens/scan_screen.dart';


class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedPage = 0;
  final List<Widget> _mainPages = [
    NearMeScreen(),
    ScanScreen(),
    QRScreen(),
    HistoryScreen(),
    AccountScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    final userRepo = Provider.of<UserRepository>(context);
    print(userRepo.user);
    return Scaffold(
      backgroundColor: Color(0xFFF3F5F7),
      body: _mainPages[_selectedPage],
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Color.fromRGBO(0, 0, 0, 0),
        animationCurve: Curves.easeInOutSine,
        animationDuration: Duration(milliseconds: 400),
        index: _selectedPage,
        onTap: (int value) {
          print(userRepo.user);
          setState(() {
            _selectedPage = value;
          });
        },
        items: <Widget>[
          Icon(Icons.near_me, size: 30, color: _selectedPage == 0 ? Theme.of(context).scaffoldBackgroundColor : Colors.black,),
          Icon(Icons.add, size: 30, color: _selectedPage == 1 ? Theme.of(context).scaffoldBackgroundColor : Colors.black,),
          Icon(Icons.memory, color: _selectedPage == 2 ? Theme.of(context).scaffoldBackgroundColor : Colors.black,),
          Icon(Icons.list, size: 30, color: _selectedPage == 3 ? Theme.of(context).scaffoldBackgroundColor : Colors.black,),
          Icon(Icons.account_circle, size: 30, color: _selectedPage == 4 ? Theme.of(context).scaffoldBackgroundColor : Colors.black,),
        ],
      ),
    );
  }
}