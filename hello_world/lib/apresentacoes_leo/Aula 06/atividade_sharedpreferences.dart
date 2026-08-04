import 'package:flutter/material.dart';
// Importa o SharedPreferences
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  // Inicia o aplicativo
  runApp(const IdiomaApp());
}

// - - - - - - - Classe principal do aplicativo - - - - - - -
class IdiomaApp extends StatefulWidget {
  const IdiomaApp({super.key});

  @override
  State<IdiomaApp> createState() => _IdiomaAppState();
}

// - - - - - - - Classe responsável pela lógica - - - - - - -
class _IdiomaAppState extends State<IdiomaApp> {

  // Variável responsável por controlar o idioma
  // "pt" -> Português
  // "en" -> Inglês
  // O aplicativo começa em Português
  String idioma = "pt";

  @override
  void initState() {
    super.initState();

    // Quando o aplicativo inicia,
    // ele chama a função carregarIdioma()
    carregarIdioma();
  }

  // - - - - - - - Função para salvar idioma - - - - - - -

  Future<void> salvarIdioma(String valor) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('idioma', valor);
  }

  // - - - - - - - Função para carregar idioma - - - - - - -

  Future<void> carregarIdioma() async {
    final prefs = await SharedPreferences.getInstance();

    String? idiomaSalvo = prefs.getString('idioma');

    setState(() {
      idioma = idiomaSalvo ?? "pt";
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // - - - - - - - Tela Principal - - - - - - -
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Escolha de Idioma"),
        ),

        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [

              // Texto mostrando a mensagem no idioma escolhido
              Text(
                idioma == "pt"
                    ? "Olá Usuário"
                    : "Hello User",

                style: const TextStyle(fontSize: 28),
              ),

              const SizedBox(height: 30),

              // - - - - - - - Botão Português - - - - - - -
              ElevatedButton(
                onPressed: () {

                  // Atualiza a tela
                  setState(() {
                    idioma = "pt";
                  });

                  // Salva o idioma Português
                  salvarIdioma("pt");
                },

                child: const Text("Português"),
              ),

              const SizedBox(height: 15),

              // - - - - - - - Botão Inglês - - - - - - -
              ElevatedButton(
                onPressed: () {

                  // Atualiza a tela
                  setState(() {
                    idioma = "en";
                  });

                  // Salva o idioma Inglês
                  salvarIdioma("en");
                },

                child: const Text("English"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}