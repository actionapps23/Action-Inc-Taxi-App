import 'package:flutter/material.dart';

class CloseProcedureScreen extends StatelessWidget {
  const CloseProcedureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Close Procedure'),
      ),
      body: Center(
        child: Text('Close Procedure Screen Content'),
      ),
    );
  }
}