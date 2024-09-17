import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calmer Beats',
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _activityDuration = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calmer Beats'),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Text('Let\'s spend time calming your system',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue)),
            Text('Select today\'s duration and activity',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue)),
            ListTile(
              leading: Radio(
                value: 2,
                groupValue: _activityDuration,
                onChanged: (value) {
                  setState(() {
                    _activityDuration = value!;
                  });
                },
              ),
              title: Text('2 mins'),
            ),
            ListTile(
              leading: Radio(
                value: 5,
                groupValue: _activityDuration,
                onChanged: (value) {
                  setState(() {
                    _activityDuration = value!;
                  });
                },
              ),
              title: Text('5 mins'),
            ),
            ListTile(
              leading: Radio(
                value: 10,
                groupValue: _activityDuration,
                onChanged: (value) {
                  setState(() {
                    _activityDuration = value!;
                  });
                },
              ),
              title: Text('10 mins'),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text('Pick your activity',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue)),
            ),
            /*ListTile(
              leading: ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ActivityScreen("Breathing", _activityDuration)),
                ),
                child: Text("Breathing"),
              ),
            ),
            ListTile(
              leading: ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          ActivityScreen("Focus", _activityDuration)),
                ),
                child: Text("Focus"),
              ),
            ),
            */
            Wrap(
              spacing: 8.0,
              children: <String>[
                'Breathing',
                'Focus',
                'Sound',
                'Touch',
                "activity x",
                "activity y",
              ].map<Widget>((String activity) {
                // Explicitly specifying the type of the list items as Widget
                return ElevatedButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ActivityScreen(activity, _activityDuration)),
                  ),
                  child: Text(activity),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            Text('Your current heart rate and HRV: ',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber)),
            SizedBox(height: 10),
            Text('62 : 41',
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber)),
            SizedBox(height: 10),
            Text('Since using Calmer Beats today, the changes are:',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber)),
            SizedBox(height: 10),
            Text('-15 : -24',
                style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber)),
          ],
        ),
      ),
    );
  }
}

class ActivityScreen extends StatelessWidget {
  final String activity;
  final int duration;

  ActivityScreen(this.activity, this.duration);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(activity),
      ),
      body: Center(
        child: Text('Duration for this activity is $duration minutes'),
      ),
    );
  }
}
