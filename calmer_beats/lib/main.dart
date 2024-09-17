// Copyright 2022 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart'; // new
import 'package:firebase_ui_auth/firebase_ui_auth.dart'; // new
import 'package:go_router/go_router.dart'; // new
import 'widgets/app_state.dart'; // new
import 'routes/home_page.dart';
import 'routes/activity.dart';
import 'routes/observe.dart';
import 'routes/sight.dart';
import 'routes/breath.dart';
import 'widgets/base_scaffold.dart';
import 'widgets/ble_widget.dart';
import 'routes/sound.dart';
import 'routes/info_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(ChangeNotifierProvider(
    create: (context) => ApplicationState(), // holds the globally available data
    builder: ((context, child) => const App()),
  ));

}

// Add GoRouter configuration outside the App class
final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => BaseScaffold(body: HomePage(), title: 'Calmer Beats'),
      routes: [
        GoRoute(
          //  ******** pay close attention to the format of the path: the ActivityScreen params
          path: 'sight/:activityName/:duration',
          builder: (context, state) {
            final activityName = state.pathParameters ['activityName'];
            final iDuration = int.parse(state.pathParameters['duration']!);
            //print("-------------------- $activityName:$iDuration");
            return BaseScaffold(body: SightScreen(activityName:activityName!, duration:iDuration!,), title: activityName);  // Pass activity parameters
          },
        ),
        GoRoute(
            //  ******** pay close attention to the format of the path: the ActivityScreen params
            path: 'observe/:activityName/:duration',
            builder: (context, state) {
              final activityName = state.pathParameters ['activityName'];
              final iDuration = int.parse(state.pathParameters['duration']!);
              //print("-------------------- $activityName:$iDuration");
              return BaseScaffold(body: ObserveScreen(activityName:activityName!, duration:iDuration!,), title: activityName);  // Pass activity parameters

            },
          ),

        GoRoute(
          //  ******** pay close attention to the format of the path: the ActivityScreen params
          path: 'breath/:activityName/:duration',
          builder: (context, state) {
            final activityName = state.pathParameters ['activityName'];
            final iDuration = int.parse(state.pathParameters['duration']!);
            //print("-------------------- $activityName:$iDuration");
            return BaseScaffold(body: BreathScreen(activityName:activityName!, duration:iDuration!,), title: activityName);  // Pass activity parameters

          },
        ),
        GoRoute(
          //  ******** pay close attention to the format of the path: the ActivityScreen params
          path: 'sound/:activityName/:duration',
          builder: (context, state) {
            final activityName = state.pathParameters ['activityName'];
            final iDuration = int.parse(state.pathParameters['duration']!);
            //print("-------------------- $activityName:$iDuration");
            return BaseScaffold(body: SoundScreen(activityName:activityName!, duration:iDuration!,), title: activityName);  // Pass activity parameters
          },
        ),
        GoRoute(
          //  ******** pay close attention to the format of the path: the ActivityScreen params
          path: 'info_screen',
          builder: (context, state) {
            return BaseScaffold(body: IntroScreen(),title: "Calmer Beats");
          },
        ),
        GoRoute(
          path: 'sign-in',
          builder: (context, state) {
            return SignInScreen(
              actions: [
                ForgotPasswordAction(((context, email) {
                  final uri = Uri(
                    path: '/sign-in/forgot-password',
                    queryParameters: <String, String?>{
                      'email': email,
                    },
                  );
                  context.push(uri.toString());
                })),
                AuthStateChangeAction(((context, state) {
                  final user = switch (state) {
                    SignedIn state => state.user,
                    UserCreated state => state.credential.user,
                    _ => null
                  };
                  if (user == null) {
                    return;
                  }
                  if (state is UserCreated) {
                    user.updateDisplayName(user.email!.split('@')[0]);
                  }
                  if (!user.emailVerified) {
                    user.sendEmailVerification();
                    const snackBar = SnackBar(
                        content: Text(
                            'Please check your email to verify your email address'));
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                  context.pushReplacement('/');
                })),
              ],
            );
          },
          routes: [
            GoRoute(
              path: 'forgot-password',
              builder: (context, state) {
                final arguments = state.uri.queryParameters;
                return ForgotPasswordScreen(
                  email: arguments['email'],
                  headerMaxExtent: 200,
                );
              },
            ),
          ],
        ),
        GoRoute(
          path: 'profile',
          builder: (context, state) {
            //firebase ui
            return ProfileScreen(
              providers: const [],
              actions: [
                SignedOutAction((context) {
                  context.pushReplacement('/');
                }),
              ],
            );
          },
        ),
      ],
    ),
  ],
);
// end of GoRouter configuration

// Changed MaterialApp to MaterialApp.router
class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Calmer Beats',
      theme: ThemeData(
        buttonTheme: Theme.of(context).buttonTheme.copyWith(
          highlightColor: Colors.blueAccent,
        ),
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.dmSansTextTheme(
          Theme.of(context).textTheme,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
        useMaterial3: true,
      ),
      routerConfig: _router, // new
    );
  }
}


