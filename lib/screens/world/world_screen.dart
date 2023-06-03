import 'package:flutter/material.dart';

class WorldScreen extends StatefulWidget {
  const WorldScreen({super.key});

  @override
  State<WorldScreen> createState() => _WorldScreenState();
}

class _WorldScreenState extends State<WorldScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
      child: Text('Food By Country'),
    ));
  }
}
