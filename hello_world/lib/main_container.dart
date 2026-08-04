import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Exemplo Container")),

        body: Container(
          width: 350,
          height: 250,
          color: Colors.pink,
          child: Center(
            child: Text("Olá Flutter", style: TextStyle(color: Colors.white, fontSize: 20)),
          ),
        ),
      ),
    );
  }
}
