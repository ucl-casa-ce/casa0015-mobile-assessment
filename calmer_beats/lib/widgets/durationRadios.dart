import 'package:flutter/material.dart';

class DurationRadioWidget extends StatefulWidget {
  final Function(String?) onSelected; // Callback to pass the selected value

  DurationRadioWidget({Key? key, required this.onSelected}) : super(key: key);

  @override
  _DurationRadioWidgetState createState() => _DurationRadioWidgetState();
}

class _DurationRadioWidgetState extends State<DurationRadioWidget> {
  String? _selectedValue = '2';

  void _radioValueChange(String? value) {
    //print("Radio value changed: $value");
    setState(() {
      _selectedValue = value;
    });
    widget.onSelected(value);// Call the callback with the new value

  }


  @override
  Widget build(BuildContext context) {

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text('Duration (mins): '),
        Radio<String>(
          value: '2',
          groupValue: _selectedValue,
          onChanged: _radioValueChange,
        ),
        Text('2'),
        Radio<String>(
          value: '5',
          groupValue: _selectedValue,
          onChanged: _radioValueChange,
        ),
        Text('5'),
        Radio<String>(
          value: '10',
          groupValue: _selectedValue,
          onChanged: _radioValueChange,
        ),
        Text('10'),
      ],
    );
  }
}