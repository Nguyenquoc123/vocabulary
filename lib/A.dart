import 'package:flutter/material.dart';

class PracticePage extends StatelessWidget {
  final String mode;

  const PracticePage({super.key, required this.mode});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(mode)),
      body: Center(
        child: Text(
          'You selected: $mode',
          style: const TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
