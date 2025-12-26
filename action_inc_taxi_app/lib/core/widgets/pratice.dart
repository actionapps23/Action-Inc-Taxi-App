import 'package:flutter/material.dart';

class PracticeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.red,
        child: Column(
          children: [Container(color: Colors.blue, height: 100, width: 100)],
        ),
      ),
    );
  }
}
