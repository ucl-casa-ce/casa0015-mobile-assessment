import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
        backgroundColor: Colors.grey[300], // Light gray
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: <Widget>[
                    CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage('https://example.com/user_avatar.png'),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text('Username', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87)),
                          Text('Days of Use: 365', style: TextStyle(fontSize: 16, color: Colors.black54)),
                          Text('Total Travel Distance: 1234 km', style: TextStyle(fontSize: 16, color: Colors.black54)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Divider(),
              ButtonBar(
                alignment: MainAxisAlignment.spaceEvenly,
                buttonPadding: EdgeInsets.symmetric(horizontal: 20),
                children: <Widget>[
                  ElevatedButton.icon(
                    icon: Icon(Icons.file_download),
                    label: Text('Export Data'),
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(primary: Colors.blueGrey[200]), // Use light blue-gray
                  ),
                  ElevatedButton.icon(
                    icon: Icon(Icons.delete),
                    label: Text('Delete Data'),
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(primary: Colors.blueGrey[200]), // Same light blue-gray
                  ),
                ],
              ),
              ListTile(
                leading: Icon(Icons.map, color: Colors.blueGrey[400]),
                title: Text('Map Theme', style: TextStyle(color: Colors.black87)),
                onTap: () {},
              ),
              ListTile(
                leading: Icon(Icons.info_outline, color: Colors.blueGrey[400]),
                title: Text('About', style: TextStyle(color: Colors.black87)),
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
