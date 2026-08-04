import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double largura = MediaQuery.of(context).size.width;
    double altura = MediaQuery.of(context).size.height;
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    margin: EdgeInsets.all(20),
                    child: Image.asset(
                      'assets/images/cadeado.png',
                      width: largura * 0.2,
                      height: altura * 0.1,
                    ),
                  ),

                  Text(
                    "Login",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: altura * 0.03),

                  SizedBox(
                    width: largura * 0.9,
                    height: altura * 0.09,
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Email",
                      ),
                    ),
                  ),

                  SizedBox(height: altura * 0.02),

                  SizedBox(
                    width: largura * 0.9,
                    height: altura * 0.09,
                    child: TextField(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: "Senha",
                      ),
                    ),
                  ),

                  SizedBox(height: altura * 0.02),

                  SizedBox(
                    width: largura * 0.9,
                    height: altura * 0.07,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(
                          255,
                          245,
                          245,
                          245,
                        ),
                        elevation: 2,
                        shadowColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: Text(
                        "Entrar",
                        style: TextStyle(fontSize: 20, color: Colors.purple),
                      ),
                    ),
                  ),

                  SizedBox(height: altura * 0.01),

                  Text(
                    "Criar conta",
                    style: TextStyle(color: Colors.purple, fontSize: 20),
                  ),

                  SizedBox(height: altura * 0.3),

                  Text(
                    "Tem mais para baixo",
                    style: TextStyle(color: Colors.purple, fontSize: 20),
                  ),

                  SizedBox(height: altura * 0.5),

                  Text(
                    "SingleChildScrollView",
                    style: TextStyle(color: Colors.purple, fontSize: 20),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
