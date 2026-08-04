import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(home: TelaPrincipal()));

class TelaPrincipal extends StatefulWidget {
  @override
  State<TelaPrincipal> createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  final nomeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tela principal")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: nomeController,
              decoration: InputDecoration(labelText: "Digite seu nome"),
            ),

            SizedBox(height: 16),

            ElevatedButton(
              child: Text("Ir para a segunda tela"),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        SegundaTela(nome: nomeController.text),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class SegundaTela extends StatelessWidget {
  final String nome;
  const SegundaTela({required this.nome});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Olá, $nome")),
      body: Center(child: Text("Bem vindo, $nome")),
    );
  }
}
