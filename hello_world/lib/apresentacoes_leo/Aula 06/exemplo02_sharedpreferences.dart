import 'package:flutter/material.dart';
//Importa o SharedPreferences
import 'package:shared_preferences/shared_preferences.dart';


void main() {
  // Inicia o aplicativo
  runApp(TemaApp());
}


// - - - - - - - Classe principal do aplicativo - - - - - - -
class TemaApp extends StatefulWidget {
  const TemaApp({super.key});


  @override
  State<TemaApp> createState() => _MyAppState();
}


// - - - - - - - Classe responsável pela lógica - - - - - - -
class _MyAppState extends State<TemaApp> {
  // Variável responsável por controlar o tema
  // true  -> tema escuro
  // false -> tema claro
  // O aplicativo começa no tema claro
  bool isDarkTheme = false;


  @override
  void initState() {
    super.initState();

    // Quando o aplicativo inicia, ele chama a função carregarTema(). Essa função verifica se existe um tema salvo no SharedPreferences
    carregarTema();
  }


  // - - - - - - - Função para salvar o tema - - - - - - -

  Future<void> salvarTema(bool valor) async {
  final prefs = await SharedPreferences.getInstance();

  await prefs.setBool('temaEscuro', valor);
}


  // - - - - - - - Função para carregar tema - - - - - - -

  Future<void> carregarTema() async {
    final prefs = await SharedPreferences.getInstance();
    bool? temaSalvo = prefs.getBool('temaEscuro');

    setState(() {
      isDarkTheme = temaSalvo ?? false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // Tema claro padrão
      theme: ThemeData.light(),

      // Tema escuro
      darkTheme: ThemeData.dark(),

      themeMode: isDarkTheme ? ThemeMode.dark : ThemeMode.light,

// - - - - - - - Tela Principal - - - - - - - 
      home: Scaffold(
        appBar: AppBar(title: const Text("Tema Claro e Escuro")),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,


            children: [
              // Texto mostrando o tema atual
              Text(
                isDarkTheme ? "Tema Escuro" : "Tema Claro",


                style: const TextStyle(fontSize: 24),
              ),


              const SizedBox(height: 20),


              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // - - - - - - - Botão Sol - - - - - - -
                  IconButton(
                    icon: const Icon(Icons.wb_sunny, size: 40),


                    onPressed: () {
                      // Atualiza a tela
                      setState(() {
                        // false = tema claro
                        isDarkTheme = false;
                      });


                      // Salva o tema claro
                      salvarTema(false);
                    },
                  ),


                  const SizedBox(width: 10),


                  // SWITCH
                  Switch(
                    value: isDarkTheme,


                    onChanged: (valor) {
                      // Atualiza a tela
                      setState(() {
                        isDarkTheme = valor;
                      });


                      // Salva no SharedPreferences
                      salvarTema(valor);
                    },
                  ),


                  const SizedBox(width: 10),


                  // - - - - - - - Botão Lua - - - - - - -
                  IconButton(
                    icon: const Icon(Icons.nightlight_round, size: 40),


                    onPressed: () {
                      // Atualiza a tela
                      setState(() {
                        // true = tema escuro
                        isDarkTheme = true;
                      });


                      // Salva o tema escuro
                      salvarTema(true);
                    },
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