import 'package:flutter/material.dart';
import 'package:mobileapp/bottomBar.dart';

class Home extends StatefulWidget {
  const Home({Key ? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home>{
  int _currentIndex = 0;

  List<String> titles = ["My Adventures", "Home", "Settings"];

  Color backgroundColor = Color(0xff050B18);

  List<Widget>? _pages;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        backgroundColor: backgroundColor,
        automaticallyImplyLeading: false,
        title: Text("Journey Tracker", style: TextStyle(color: Colors.white),),
      ),
      body: getBody(),
      bottomNavigationBar: BottomBar(
        containerHeight: 56,
        onItemSelected: (index){
          setState(() {
            _currentIndex = index;
          });
        },
        items: List.generate(titles.length, (index) {
          return Text(titles[index], style: TextStyle(
            color: Colors.white,
          ),);
        }),
      ),
    );
  }

  Widget getBody() {

    return Container(
      child: Center(
        child: Text(titles[_currentIndex], style: TextStyle(color: Colors.white),),
      ),
    );
  }
}