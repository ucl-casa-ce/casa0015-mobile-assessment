// Copyright 2022 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:firebase_auth/firebase_auth.dart' // new
    hide
    EmailAuthProvider,
    PhoneAuthProvider; // new
import 'package:flutter/material.dart'; // new
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart'; // new

import '../widgets/app_state.dart'; // new
import '../authentication.dart'; // new
import '../widgets.dart';
import '../widgets/durationRadios.dart';
import '../widgets/ble_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:calmer_beats/routes/info_screen.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageWidgetState createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePage> {
  bool _isLoggedIn = false;
  bool _isConnected = false;
  String _receivedData = "";
  String _bpmData = "";
  String _hrvData = "";

  String? _selectedValue = "2";
  bool _isFirstLaunch = true;

  @override
  void initState() {
    super.initState();
    _checkFirstLaunch();
  }
  //launch info screen when opening app
  Future<void> _checkFirstLaunch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFirstLaunch = prefs.getBool('first_launch') ?? true;

    if (isFirstLaunch) {
      await prefs.setBool('first_launch', false);
      _isFirstLaunch = true;
    } else {
      _isFirstLaunch = false;
    }

    // Refresh the UI after checking
    setState(() {});
  }

  void _radioValueChange(String? value) {
    setState(() {
      _selectedValue = value;
      //print("Set selected value: $_selectedValue");
    });
  }
  void navigateToBLEConnect() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BLEConnect(
          title: "Create Connection",
          onConnectionStatusChanged: onConnectionStatusChanged,
          onDataReceived: onDataReceived,
        ),
      ),
    );
  }

  void showInfo() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            Scaffold(
              body: Container(
                alignment: Alignment.center,
                color: Colors.black,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Close",
                    style: TextStyle(
                        fontSize: 24,
                      )),
                ),
              ),
            ),
      ),
    );
  }

  //event handlers:
  // for connection
  void onConnectionStatusChanged(bool isConnected) {
    // Handle connection status change
    print("Connection Status: $isConnected");
    _isConnected = isConnected;
  }
  //for remote data
  void onDataReceived(String data) {
    // Handle data received
    print("Data Received: $data");
    _receivedData = data;

    // Split the string - format is "AvgBPM: VALUE1 | Delta: SOMENUMBER | HRV: VALUE2 | SOMEMORETEXT"
    List<String> parts = data.split(' | ');

    // get Avgbpm
    String value1All = parts[0];
    _bpmData = value1All.split(': ')[1];

    // get HRV
    String value2All = parts[2];
    _hrvData = value2All.split(': ')[1];

    print("BPM: $_bpmData");
    print("HRV: $_hrvData");
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<ApplicationState>(context);

    return _isFirstLaunch ? const IntroScreen() :Scaffold(
      appBar: AppBar( backgroundColor: Colors.teal, foregroundColor: Colors.white,
        title: const Text('Calmer Beats'),
        actions: [
          //IconButton(onPressed:(){context.go('/routes/');},icon: Icon(Icons.tap_and_play), color: Colors.lightGreenAccent,), //use lightGreenAccent and pink for good contrast
          IconButton(
            onPressed:(){navigateToBLEConnect();},
            icon: const Icon(Icons.tap_and_play),
            color: Colors.pink,),
          /*AuthFunc(
            loggedIn: _isLoggedIn,
            signOut: () {
              // Implement the signOut functionality
              FirebaseAuth.instance.signOut();
              _isLoggedIn = false;
            },
          ),
           */
          //route to the sign-in page
          IconButton(
            icon: Icon(Icons.login),
            onPressed: () {
              context.go('/sign-in');
            },
            color: Colors.pink,
          ),

          IconButton(
            onPressed: () {context.go('/info_screen');}, // Implement navigation or functionality
            icon: Icon(Icons.info_outline_rounded),
          ),
        ],
      ),



      body: ListView(
        children: <Widget>[
          Image.asset('lib/assets/main_wide.png',
            width: 250,
            height: 250,),
          const SizedBox(height: 8),
          //login button
          //Login function
          /*
          Consumer<ApplicationState>(
            builder: (context, appState, _) => AuthFunc(
                loggedIn: appState.loggedIn,
                signOut: () {
                  FirebaseAuth.instance.signOut();
                }),
          ),
          */
          const Divider(
            height: 8,
            thickness: 1,
            indent: 8,
            endIndent: 8,
            color: Colors.grey,
          ),
          const Center(
            child:Header("Welcome to Calmer Beats" ),
          ),
          const Center(
            child:Paragraph(
            "Let's take things down a notch\nSelect your duration and activity",
            ),
          ),
          DurationRadioWidget(onSelected: _radioValueChange),

          //display the activity buttons
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8.0,
            children: <String>[
              'Breath',
              //'Focus',
              'Sound',
              //'Touch',
              //"Observe",
              "Sight",
            ].map<Widget>((String activity) {
              // Explicitly specifying the type of the list items as Widget

              return ElevatedButton(

                //this was is set up to be flexible so that a single activity screen with multiple "skins" and widgets could be used
                //not implemented yet. the format would be:
                //                onPressed: (){context.go('/activity/$activity/$_selectedValue');},
                //                 child: Text(activity),
                //
                //instead currently the below format is /"activity_route_name"/"Title"/"duration"
                onPressed: (){context.go('/$activity/$activity/$_selectedValue');},
                child: Text(activity),
              );
            }).toList(),
          ),

          const Divider(
            thickness: 3,
            indent: 10,
            endIndent: 10,
          ),const SizedBox(height: 8),

          const Center(
            child: Header("BMP and HRV Data"),
          ),
          const SizedBox(height: 8),
          const Divider(
            height: 8,
            thickness: 1,
            indent: 8,
            endIndent: 8,
            color: Colors.grey,
          ),

          ////////////////// SPACE FOR DISPLAYING READINGS !!!!!!!!!!!!!!!!!!!!!!!!!!!
          const SizedBox(height: 8),
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              // 2 Columns - before and after
              Column(
                children: <Widget>[
                  Text('Before', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('BPM: '),
                  Text('HRV: '),
                ],
              ),

              Column(
                children: <Widget>[
                  Text('After', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 8),
                  Text('BPM: '),
                  Text('HRV: '),
                ],
              ),
            ],
          ),

        ],

      ),
    );
  }
}
