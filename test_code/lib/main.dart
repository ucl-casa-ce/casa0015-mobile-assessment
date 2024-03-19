import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Simple Animated Bar'),
        ),
        body: Center(
          child: AnimatedBar(),
        ),
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
  late AnimationController _controller; // Marked as late
  late Animation<double> _animation; // Marked as late

  @override
  void initState() {
    super.initState();
    // Initialize your animation controller
    _controller = AnimationController(
      duration: const Duration(seconds: 2), // Animation duration
      vsync: this,
    );

    // Define the animation's beginning and ending values, along with the controller
    _animation = Tween<double>(begin: 0, end: 200).animate(_controller)
      ..addListener(() {
        // Call setState every time the animation value changes
        setState(() {});
      });

    // Start the animation
    _controller.forward();
  }

  @override
  void dispose() {
    // Don't forget to dispose of the animation controller!
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50, // Fixed width for the bar
      height: _animation.value, // Animated height
      color: Colors.blue, // Color of the bar
    );
  }
}
