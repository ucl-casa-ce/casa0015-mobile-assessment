import 'package:firebase_auth/firebase_auth.dart'
    hide EmailAuthProvider, PhoneAuthProvider;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app_state.dart';
import 'src/authentication.dart';
import 'src/widgets.dart';
import 'guest_book.dart';


class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(
      builder: (context, appState, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (appState.loggedIn) ...[
            const Header('Discussion'),
            GuestBook(
              addMessage: (message) => appState.addMessageToGuestBook(message),
              messages: appState.guestBookMessages, // new
            ),
          ],

        ],
      ),
    );
  }
}
