import 'package:flutter/material.dart';

class OpenProcedureScreen extends StatelessWidget {
  const OpenProcedureScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Open Procedure'),
      ),
      body: const Center(
        child: Text('Open Procedure Screen'),
      ),
    );
  }
}