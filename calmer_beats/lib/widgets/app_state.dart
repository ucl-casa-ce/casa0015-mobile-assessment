import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';

import '../firebase_options.dart';

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }

  //gloabally available values
  bool _loggedIn = false;
  bool get loggedIn => _loggedIn;

  int _lastDuration = 3; // default value
  int get lastDuration => _lastDuration;

  bool _displayInstructions = true; // default value
  bool get displayInstructions => _displayInstructions;

  Future<void> init() async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);

    FirebaseUIAuth.configureProviders([
      EmailAuthProvider(),
    ]);

    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _loggedIn = true;
      } else {
        _loggedIn = false;
      }
      notifyListeners();
    });
  }
  //hold any default or updated values
  // Notify all on change
  void setLastDuration(int duration) {
    _lastDuration = duration;
    notifyListeners();
  }

  // Notify all on change
  void setDisplayInstructions(bool display) {
    _displayInstructions = display;
    notifyListeners();
  }
}
