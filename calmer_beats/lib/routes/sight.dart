import 'package:calmer_beats/widgets/activity_widget.dart';
import 'package:flutter/material.dart';
import 'package:calmer_beats/widgets/app_state.dart';
import 'package:provider/provider.dart';
import 'package:calmer_beats/widgets/video_widget.dart';


class SightScreen extends StatefulWidget {


  String activity = "";
  final String activityName;
  final int duration;

  SightScreen({super.key, required this.activityName, required this.duration} ) ;

  @override
  _SightScreenState createState() => _SightScreenState();
}

class _SightScreenState extends State<SightScreen> {



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
          Image.asset('lib/assets/view_wide2.png',
            width: 350,
            height: 285,),
          const Divider(
            height: 8,
            thickness: 1,
            indent: 8,
            endIndent: 8,
            color: Colors.grey,
          ),
          const Center(
            child:Text("For this exercise, cloud watch. Press play, clear your mind and gaze at the wonderful shapes",
              textAlign: TextAlign.center,
              style: TextStyle(
              fontSize: 24.0, // Set the font size here
              color: Colors.blueGrey,
            ), ),
          ),
          Center(

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 400, // Specify your desired width
                  height: 260,
                  //using short copressed version. full video not uploadabe to github
                  child: VideoPlayerWidget(clip: 'lib/assets/clouds_short_comp.mp4', duration: duration),
                ),
                Text(
                  'Activity: Cloud Gazing, Duration: $duration minutes',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}


