import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: TelaComparacao());
  }
}

class TelaComparacao extends StatefulWidget {
  const TelaComparacao({super.key});

  @override
  _TelaComparacaoState createState() => _TelaComparacaoState();
}

class _TelaComparacaoState extends State<TelaComparacao> {
  final controllerSimples = TextEditingController();
  final controllerForm = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("TextField VS TextFormField")),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // - - - - - - - - - - - - - -
            //  TextField (s/ validação)
            // - - - - - - - - - - - - - -
            Text("TextField (simples)", style: TextStyle(fontSize: 20)),

            SizedBox(height: 20),

            TextField(
              controller: controllerSimples,
              decoration: InputDecoration(
                labelText: "Digite algo",
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                print("TextField: ${controllerSimples.text}");
              },
              child: Text("Mostrar TextField", style: TextStyle(fontSize: 16)),
            ),

            SizedBox(height: 30),

            // - - - - - - - - - - - - - - - - -
            //   TEXTFORMFIELD COM VALIDAÇÃO
            // - - - - - - - - - - - - - - - - -
            Text(
              "TextFormField (com validação)",
              style: TextStyle(fontSize: 20),
            ),

            SizedBox(height: 20),

            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: controllerForm,
                    decoration: InputDecoration(
                      labelText: "Digite seu nome",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Campo obrigatório";
                      }
                      return null;
                    },
                  ),

                  SizedBox(height: 10),

                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        print("TextFormField: ${controllerForm.text}");
                      }
                    },
                    child: Text(
                      "Validar Formulário",
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
