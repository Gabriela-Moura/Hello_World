import 'package:flutter/material.dart';

void main() {
  runApp(FlexibleExample());
}

class FlexibleExample extends StatelessWidget {
  const FlexibleExample({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Exemplo Flexible',
      home: Scaffold(
        appBar: AppBar(title: const Text("Flexible")),
        body: Row(
          children: [
            Flexible(
              flex: 1,
              child: Container(
                height: 120,
                color: Colors.purple,
                child: const Center(child: Text("1 parte")),
              ),
            ),
            Flexible(
              flex: 2,
              child: Container(
                height: 120,
                color: Colors.green,
                child: const Center(
                  child: Text(
                    "2 partes",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
