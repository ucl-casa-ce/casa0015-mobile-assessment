import 'package:calmer_beats/widgets/activity_widget.dart';
import 'package:flutter/material.dart';
import 'package:calmer_beats/widgets/app_state.dart';
import 'package:provider/provider.dart';
import 'package:calmer_beats/widgets/audio_widget.dart';
import 'package:calmer_beats/widgets/breath_widget.dart';


class BreathScreen extends StatefulWidget {


  String activity = "";
  final String activityName;
  final int duration;

  BreathScreen({super.key, required this.activityName, required this.duration} ) ;

  @override
  _BreathScreenState createState() => _BreathScreenState();
}

class _BreathScreenState extends State<BreathScreen> {

  @override
  Widget build(BuildContext context) {
    final activityName = widget.activityName;
    final duration = widget.duration;

    return Scaffold(
      appBar: AppBar( backgroundColor: Colors.teal, foregroundColor: Colors.white,
        title: const Text('Calmer Beats'),),
      body:
      ListView(
      children: <Widget>[
        Image.asset('lib/assets/breath_wide2.png',
          width: 350,
          height: 285,),
      const Divider(
        height: 8,
        thickness: 1,
        indent: 8,
        endIndent: 8,
        color: Colors.grey,
        ),
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Breathe in on the short vibration and out on the long',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                )
            ),
            Container(
              width: 400, // Specify your desired width
              height: 600,
              child: BreathBall(duration: duration),
            ),

            ],
          ),
        ),
      ],
      ),
    );
  }
}


