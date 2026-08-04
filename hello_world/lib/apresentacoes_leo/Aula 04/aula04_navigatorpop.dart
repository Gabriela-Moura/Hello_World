import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(home: TelaInicial()));

class TelaInicial extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tela Inicial")),
      body: Center(
        child: ElevatedButton(
          child: Text('Ir para Detalhes'),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => TelaDetalhes()),
            );
          },
        ),
      ),
    );
  }
}

class TelaDetalhes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Tela Detalhes")),
      body: Center(
        child: ElevatedButton(
          child: Text('Voltar para a tela principal'),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
    );
  }
}
