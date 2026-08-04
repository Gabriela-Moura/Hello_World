import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: TelaCurtidas(), debugShowCheckedModeBanner: false);
  }
}

class TelaCurtidas extends StatefulWidget {
  const TelaCurtidas({super.key});

  @override
  _TelaCurtidasState createState() => _TelaCurtidasState();
}

class _TelaCurtidasState extends State<TelaCurtidas> {
  int curtidas = 0;

  void adicionarCurtida() {
    setState(() {
      curtidas++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Aplicativo de Curtidas"), centerTitle: true),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite, color: Colors.red, size: 80),

            SizedBox(height: 20),

            Text(
              "$curtidas curtidas",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: adicionarCurtida,
              child: Text("Curtir", style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
