import 'package:flutter/material.dart';

void main() {
  runApp(ScrollApp());
}

class ScrollApp extends StatelessWidget {
  const ScrollApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Scroll Example',
      home: Scaffold(
        appBar: AppBar(title: const Text("SingleChildScrollView")),
        body: SingleChildScrollView(
          child: Column(
            children: List.generate(
              20,
              (index) => Container(
                margin: const EdgeInsets.all(10),
                height: 80,
                color: Colors.purple,
                child: Center(
                  child: Text(
                    "Item ${index + 1}",
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
