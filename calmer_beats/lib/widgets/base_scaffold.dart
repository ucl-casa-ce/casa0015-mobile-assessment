import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

//creating a wrapper scaffold to diplay the appbar on all screens
class BaseScaffold extends StatelessWidget {
  final Widget body;
  final String title;

  const BaseScaffold({super.key, required this.body, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /*appBar: AppBar(
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        title: Text(title),
        actions: [
          IconButton(
            onPressed: () {
              context.go('/routes/Activity');
            },
            icon: Icon(Icons.tap_and_play),
            color: Colors.lightGreenAccent,
          ),
          IconButton(
            onPressed: () {}, // Implement navigation or functionality
            icon: Icon(Icons.login),
            color: Colors.pink,
          ),
          IconButton(
            onPressed: () {}, // Implement navigation or functionality
            icon: Icon(Icons.info_outline_rounded),
          ),
        ],
      ),

       */
      body: body,
    );
  }
}