import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class AppianceProcess extends StatelessWidget {
  String? mainTitle;
  AppianceProcess({super.key, this.mainTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(mainTitle!),
      ),
      body: Center(child: Text("$mainTitle")),
    );
  }
}
