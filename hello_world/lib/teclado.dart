import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: TelaTeclados());
  }
}

class TelaTeclados extends StatelessWidget {
  final nomeController = TextEditingController();
  final emailController = TextEditingController();
  final idadeController = TextEditingController();
  final telefoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tipos de teclado")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            //texto padrão
            TextField(
              controller: nomeController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: "Nome",
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 10),

            // email
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 10),

            //NUMEROS
            TextField(
              controller: idadeController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Idade",
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 10),

            //TELEFONE
            TextField(
              controller: telefoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: "Telefone",
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                print("Nome: ${nomeController.text}");
                print("Email: ${emailController.text}");
                print("Idade: ${idadeController.text}");
                print("Telefone: ${telefoneController.text}");
              },
              child: Text("Mostrar Dados"),
            ),
          ],
        ),
      ),
    );
  }
}
