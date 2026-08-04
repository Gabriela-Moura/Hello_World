import 'package:flutter/material.dart';

void main() {}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/fundoTela.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: const Center(
            child: Text(
              "SENAI",
              style: TextStyle(
                fontSize: 30,
                color: Color.fromRGBO(180, 0, 93, 1),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
