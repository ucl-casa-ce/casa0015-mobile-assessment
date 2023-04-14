import 'package:elderlyease/Login.dart';
import 'package:elderlyease/home_page.dart';
import 'package:flutter/material.dart';

main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Elderlyease",
      home: LoginPage(),
    );
  }
}
