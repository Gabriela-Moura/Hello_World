import 'package:flutter/material.dart';

void main() {}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Bem-vindo ", style: TextStyle(fontSize: 24)),
              const SizedBox(height: 20, width: 10),
              Image.asset('assets/images/fundoTela.png', width: 200),
            ],
          ),
        ),
      ),
    );
  }
}
