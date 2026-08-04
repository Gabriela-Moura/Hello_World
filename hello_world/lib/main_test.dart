import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: TelaTeste());
  }
}

class TelaTeste extends StatefulWidget {
  @override
  _TelaTesteState createState() => _TelaTesteState();
}

class _TelaTesteState extends State<TelaTeste> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Teste Controller")),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(controller: controller),
          ElevatedButton(
            onPressed: () {
              controller.text = "Olá!";
            },
            child: Text("Preencher"),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
