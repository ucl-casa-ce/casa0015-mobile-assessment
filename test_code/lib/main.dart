import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Structured Breathing'),
          centerTitle: true,
        ),
        body: BreathBall(),
      ),
    );
  }
}

class BreathBall extends StatefulWidget {
  @override
  _BreathBallState createState() => _BreathBallState();
}

class _BreathBallState extends State<BreathBall>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  String _text = '...'; // Initial text

  @override
  void initState() {
    super.initState();

    //config for timings and sizes
    int totalTime = 13; //total time in secs
    Map<String, double> phases = {
      'sMax': 200, //sizes
      'sMin': 20,
      'wGrow': 2, //weight - proportion of total time
      'wGrowSlow': 1,
      'wShrink': 5,
      'wShrinkSlow': 1,
      'wPause': 2,
      'minPerc': 0.2,
      'maxPerc': 0.9,
    };

    _controller = AnimationController(
      duration: Duration(seconds: totalTime), // Total duration for all phases
      vsync: this,
    );

    //create an expanding circle that is used to connect with the user
    //illustrating when they should breathe in and out
    _animation = TweenSequence<double>([
      //expand
      TweenSequenceItem(
        //increase size
        tween: Tween<double>(
            begin: phases['sMin'],
            end: phases['sMax']! *
                phases['maxPerc']!), // increase to n% of full size
        weight: 3, // Duration weight for growth phase
      ),
      //slowing increase
      TweenSequenceItem(
        tween: Tween<double>(
            begin: phases['sMax']! * phases['maxPerc']!,
            end: phases['sMax']), // Slow increase at n% to full size
        weight: 1, // Duration weight for growth phase
      ),
      //pause
      TweenSequenceItem(
        tween: Tween<double>(
            begin: phases['sMax'], end: phases['sMax']), //hold at full size
        weight: 2, // Duration weight for reduction phase
      ),
      //reduce size
      TweenSequenceItem(
        tween: Tween<double>(
            begin: phases['sMax'],
            end: phases['sMin']! +
                ((phases['sMax']! - phases['sMin']!) *
                    phases['minPerc']!)), //slow for last n%
        weight: 7, // Duration weight for reduction phase
      ),
      //slow final reduction
      TweenSequenceItem(
        tween: Tween<double>(
            begin: phases['sMin']! +
                ((phases['sMax']! - phases['sMin']!) *
                    phases['minPerc']!), //slow for n%
            end: phases['sMin']), // Adjust begin for full height
        weight: 2, // Duration weight for reduction phase
      ),
      //pause
      TweenSequenceItem(
        tween: Tween<double>(
            begin: phases['sMin'], end: phases['sMin']), //hold at min size
        weight: 1, // Duration weight for reduction phase
      ),
    ]).animate(_controller)
      ..addListener(() {
        setState(() {
          // Example logic to update text based on animation value
          if (_animation.value <= phases['sMin']! * 1.1) {
            _text = 'Pause';
          } else if (_animation.value >= phases['sMax']! * 0.9) {
            _text = 'Hold In';
          } else if (_text == 'Hold In' &&
              _animation.value < phases['sMax']! * 0.9) {
            _text = 'Breathe Out';
          } else if (_text == 'Pause' &&
              _animation.value > phases['sMin']! * 1.1) {
            _text = 'Breathe In';
          }
        });
      });
  }

  void startAnimation() {
    if (_controller.isAnimating) {
      _controller.stop();
    } else {
      _controller.repeat();
    }

    //use the value passed from the previous route
    // stop the animation after n seconds
    Future.delayed(Duration(seconds: 75), () {
      if (_controller.isAnimating) {
        _controller.stop();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: MediaQuery.of(context).size.height *
              0.05, // Button at n% of screen height
          left: 0,
          right: 0,
          child: ElevatedButton(
            onPressed: startAnimation,
            child: const Text('Start',
                style: TextStyle(
                  fontSize: 24,
                )),
          ),
        ),
        Align(
          alignment: Alignment(0, -0.5),
          child: Text(
            _text,
            style: TextStyle(
              fontSize: 24,
            ),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.40 -
              (_animation.value / 2),
          left: MediaQuery.of(context).size.width / 2 - (_animation.value / 2),
          child: Container(
            width: _animation
                .value, // Use animation value for width to simulate sphere growth
            height: _animation
                .value, // Use animation value for height to simulate sphere growth
            decoration: BoxDecoration(
              shape: BoxShape.circle, // Keep the circular shape
              gradient: RadialGradient(
                colors: [
                  Colors.orange
                      .shade200, // Lighter color on one side to simulate light
                  Colors.orange
                      .shade900, // Darker color on the opposite side to simulate shadow
                ],
                stops: [
                  0.3,
                  1.0
                ], // Adjust these stops to control the gradient effect
                focal: Alignment(-0.2,
                    -0.2), // Shift the focal point to enhance the 3D effect
                focalRadius: 0.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/*
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('BREATHE'),
        ),
        body: AnimatedBar(),
      ),
    );
  }
}

class AnimatedBar extends StatefulWidget {
  @override
  _AnimatedBarState createState() => _AnimatedBarState();
}

class _AnimatedBarState extends State<AnimatedBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 11), // Total duration for both phases
      vsync: this,
    );

    _animation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0, end: 200), // GROWING RANGE
        weight: 4, // Duration weight for growth phase
      ),
      TweenSequenceItem(
        tween:
            Tween<double>(begin: 200, end: 0), // SHRINKING RANGE
        weight: 7, // Duration weight for reduction phase
      ),
    ]).animate(_controller)
      ..addListener(() {
        setState(() {});
      });
  }

  void startAnimation() {
    if (_controller.isAnimating) {
      _controller.stop();
    } else {
      _controller.repeat();
    }

    // stop the animation after 75 seconds
    Future.delayed(Duration(seconds: 75), () {
      if (_controller.isAnimating) {
        _controller.stop();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          top: MediaQuery.of(context).size.height *
              0.1, // Button at n% of screen height
          left: 0,
          right: 0,
          child: ElevatedButton(
            onPressed: startAnimation,
            child: Text('Start'),
          ),
        ),
        Positioned(
          top: MediaQuery.of(context).size.height * 0.60 -
              100, // Bar's starting point at n% of screen height
          left: MediaQuery.of(context).size.width / 2 -
              25, // Centering the bar horizontally
          child: Transform.translate(
            offset: Offset(
                0,
                -_animation.value /
                    2), // Adjusting the bar to grow from the middle
            child: Container(
              width: 50,
              height: _animation.value,
              color: Color.fromARGB(255, 243, 177, 33),
            ),
          ),
        ),
      ],
    );
  }
}

*/
