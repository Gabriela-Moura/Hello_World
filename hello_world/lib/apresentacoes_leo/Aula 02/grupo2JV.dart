import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: TipoTeclados());
  }
}

class TipoTeclados extends StatefulWidget {
  TipoTeclados({super.key});

  @override
  State<TipoTeclados> createState() => _TipoTecladosState();
}

// CRIANDO CAMPOS PARA COLOCAR ALTURA E PESO //
class _TipoTecladosState extends State<TipoTeclados> {
  final alturaController = TextEditingController();
  final pesoController = TextEditingController();
  String resultado = "";

  void calcularIMC() {
    String altura = alturaController.text;
    String peso = pesoController.text;

    if (altura.isEmpty || peso.isEmpty) {
      setState(() {
        resultado = "preencha todos os campos";
      });
      return;
    }

    double h = double.parse(altura);
    double p = double.parse(peso);
    double imc = p / (h * h);

    String classificacao = "";
    if (imc < 18.5) {
      classificacao = "abaixo do peso";
    } else if (imc < 25) {
      classificacao = "peso normal";
    } else if (imc < 30) {
      classificacao = "sobrepeso";
    } else {
      classificacao = "obeso";
    }

    setState(() {
      resultado = "IMC: ${imc.toStringAsFixed(2)}\n$classificacao";
    });
  }
  //--------------------------------------------//

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Calculadora IMC")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // ALTURA
            TextField(
              controller: alturaController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Altura (metros)",
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 15),

            // PESO
            TextField(
              controller: pesoController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Peso (kg)",
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 20),

            // BOTÃO CALCULAR
            ElevatedButton(onPressed: calcularIMC, child: Text("Calcular IMC")),

            SizedBox(height: 20),

            // CAIXA DE RESULTADO //
            if (resultado.isNotEmpty)
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: resultado == "Preencha todos os campos!"
                      ? Colors.red.shade50
                      : Colors.blue.shade50,
                  border: Border.all(
                    color: resultado == "Preencha todos os campos!"
                        ? const Color.fromARGB(255, 157, 0, 0)
                        : Colors.blue,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  resultado,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
