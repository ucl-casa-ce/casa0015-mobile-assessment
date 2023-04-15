import 'dart:math';

import 'package:elderlyease/appliance_model.dart';
import 'package:elderlyease/appliance_process.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class HomePage extends StatelessWidget {
  // List<String> category = [
  //   "Medicine",
  //   "Food",
  //   "Clothes",
  //   "Shoes",
  //   "Toys",
  //   "Books",
  //   "Electronics",
  //   "Furniture",
  //   "Sports",
  //   "Others",
  //   "TV"
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        children: [
          Text(
            "CHOOSE YOUR APPLIANCE",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
          ),
          Divider(),
          Expanded(
            child: GridView.builder(
                itemCount: category.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10),
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AppianceProcess(
                                    mainTitle: category[index].title,
                                  )));
                    },
                    child: Card(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.primaries[
                                Random().nextInt(Colors.primaries.length)],
                            borderRadius: BorderRadius.circular(20)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              category[index].image!,
                              height: 70,
                              width: 70,
                              fit: BoxFit.contain,
                            ),
                            Text(
                              category[index].title!,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    ));
  }
}
