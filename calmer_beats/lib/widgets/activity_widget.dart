import 'package:flutter/material.dart';
import 'package:calmer_beats/widgets/app_state.dart';
import 'package:provider/provider.dart';

class ActivityWidget extends StatefulWidget {


  String activity = "";
  final String activityName;
  final int duration;

  ActivityWidget({super.key, required this.activityName, required this.duration} ) ;

  @override
  _ActivityWidgetState createState() => _ActivityWidgetState();
}

class _ActivityWidgetState extends State<ActivityWidget> {
  @override
  Widget build(BuildContext context) {
    final activityName = widget.activityName;
    final duration = widget.duration;

    //print("_ActivityScreenState.activityName: $activityName");
    //print("_ActivityScreenState.duration: $duration");

    return Scaffold(
      body: Center(
        child: Container(
          height: MediaQuery.of(context).size.height, // or some other fixed height
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text('Activity: $activityName, Duration: $duration'),
            ],
          ),
        ),
      ),
    );

  }
}