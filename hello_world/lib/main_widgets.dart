import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Minha Tela")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.favorite, size: 60, color: Colors.red),

              SizedBox(height: 40),

              Text(
                "D.S. é o melhor curso do SESI?",
                style: TextStyle(
                  fontSize: 22,
                  color: Colors.purple,
                  fontWeight: FontWeight.bold,
                ),
              ),

              SizedBox(height: 40),

              ElevatedButton(
                onPressed: () {
                  print("Usuario clicou!");
                },
                child: Text(
                  "Curtir",
                  style: TextStyle(color: Colors.red, fontSize: 17),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
