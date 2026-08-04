import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: ContadorTela()); //MaterialApp
  }
}

class ContadorTela extends StatefulWidget {
  const ContadorTela({super.key});

  @override
  _ContadorTelaState createState() => _ContadorTelaState();
}

class _ContadorTelaState extends State<ContadorTela> {
  int contador = 0;

  void incrementar() {
    setState(() {
      contador++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Exemplo State")),
      body: Center(
        child: Text(
          "Contador: $contador",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: incrementar,
        child: Icon(Icons.add),
      ),
    );
  }
}
