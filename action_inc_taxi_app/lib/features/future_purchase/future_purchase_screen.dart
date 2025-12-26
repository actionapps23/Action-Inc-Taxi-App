import 'package:action_inc_taxi_app/core/widgets/navbar/navbar.dart';
import 'package:flutter/material.dart';

class FuturePurchaseScreen extends StatefulWidget {
  const FuturePurchaseScreen({super.key});

  @override
  State<FuturePurchaseScreen> createState() => _FuturePurchaseScreenState();
}

class _FuturePurchaseScreenState extends State<FuturePurchaseScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [Navbar()]);
  }
}
