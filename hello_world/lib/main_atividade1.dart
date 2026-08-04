import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: Text("Atividade 1")),

        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 200,
                height: 100,
                color: Colors.blue,
                child: Center(
                  child: Text(
                    "Caixa 1",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
              ),

              SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    color: Colors.red,
                    child: Center(
                      child: Text(
                        "Caixa 2",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  Container(
                    width: 80,
                    height: 80,
                    color: Colors.green,
                    child: Center(
                      child: Text(
                        "Caixa 3",
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
