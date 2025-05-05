import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';

import 'app_state.dart';

import 'src/authentication.dart';
import 'src/widgets.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(
      builder: (context, appState, _) {
        // 添加自动跳转逻辑
        if (appState.loggedIn) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            context.go('/first');
          });
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Weatherfit'),
          ),
          body: Column(
            children: <Widget>[
              const Padding(
                padding: EdgeInsets.only(top: 40, bottom: 20),
                child: Header("Know what to wear for different weather?"),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Paragraph(
                  "Based on the temperature, we recommend the most suitable dressing combination for you!",
                ),
              ),
              Center(
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.35,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Image.asset(
                    'assets/introductionfigure.jpg',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              if (!appState.loggedIn) // 仅未登录时显示
                AuthFunc(
                  loggedIn: appState.loggedIn,
                  signOut: () => FirebaseAuth.instance.signOut(),
                ),
              const Spacer(),
              
            ],
          ),
        );
      },
    );
  }
}
