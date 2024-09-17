import 'package:calmer_beats/widgets/activity_widget.dart';
import 'package:flutter/material.dart';
import 'package:calmer_beats/widgets/app_state.dart';
import 'package:provider/provider.dart';
import 'package:calmer_beats/widgets/audio_widget.dart';


class SoundScreen extends StatefulWidget {


  String activity = "";
  final String activityName;
  final int duration;

  SoundScreen({super.key, required this.activityName, required this.duration} ) ;

  @override
  _SoundScreenState createState() => _SoundScreenState();
}

class _SoundScreenState extends State<SoundScreen> {



  @override
  Widget build(BuildContext context) {
    final activityName = widget.activityName;
    final duration = widget.duration;

    return Scaffold(
      /*appBar: AppBar(
        title: Text('Activity Screen'),
        backgroundColor: Colors.blueAccent,
      ),*/
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 400, // Specify your desired width
              height: 260,
              child: AudioPlayerScreen(),
            ),
            Text(
              'Activity: $activityName, Durationqqq: $duration',
            ),
          ],
        ),
      ),

    );
  }

}


