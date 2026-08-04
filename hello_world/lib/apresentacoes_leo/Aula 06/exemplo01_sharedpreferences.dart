import 'package:flutter/material.dart';
//Importa o SharedPrefences
import 'package:shared_preferences/shared_preferences.dart';


void main() {
  runApp(const MyApp());
}

//- - - - - - - Classe principal do aplicativo - - - - - - -
class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      // Remove a faixa DEBUG
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}

// - - - - - - - Tela de login - - - - - - - 
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});


  @override
  State<LoginPage> createState() => _LoginPageState();
}

// - - - - - - - Classe responsável pela lógica - - - - - - -
class _LoginPageState extends State<LoginPage> {
// Controller do campo email
  final TextEditingController _emailController = TextEditingController();
// Controller do campo senha
  final TextEditingController _senhaController = TextEditingController();

 // Variáveis para armazenar os dados salvos
  String emailSalvo = '';
  String senhaSalva = '';


  @override
  void initState() {
    super.initState();


    _carregarDados();
  }


// - - - - - - - Função para carregar dados - - - - - - -
  Future<void> _carregarDados() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      emailSalvo = prefs.getString('email') ?? '';
      senhaSalva = prefs.getString('senha') ?? '';


      _emailController.text = emailSalvo;
      _senhaController.text = senhaSalva;
    });
  }

// - - - - - - - Função para salvar dados - - - - - - -
  Future<void> _salvarDados() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('email', _emailController.text);
    await prefs.setString('senha', _senhaController.text);

    setState(() {
      emailSalvo = _emailController.text;
      senhaSalva = _senhaController.text;
    });


    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Login salvo com sucesso!')));
  }


  @override
  void dispose() {
    _emailController.dispose(); //remove email
    _senhaController.dispose(); //remove senha
    super.dispose();
  }
// o dispose remove os controllers da memória quando a tela é fechada, evitando desperdício de memória e possíveis problemas de desempenho no aplicativo. 


  @override
  Widget build(BuildContext context) {
    double largura = MediaQuery.of(context).size.width;


    return Scaffold(
      appBar: AppBar(title: const Text("Shared Preference")),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const Icon(Icons.lock, size: 100, color: Color(0xFFB31B1B)),
                const SizedBox(height: 15),
                const Text(
                  "Login",
                  style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),


                SizedBox(
                  width: largura * 0.9,
                  child: TextField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Email',
                    ),
                  ),
                ),


                const SizedBox(height: 20),


                SizedBox(
                  width: largura * 0.9,
                  child: TextField(
                    controller: _senhaController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Senha',
                    ),
                  ),
                ),


                const SizedBox(height: 10),


                SizedBox(
                  width: largura * 0.9,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF5E2C8),
                      shadowColor: Colors.transparent,
                      textStyle: const TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),


                    // chamar função para salvar os dados
                    onPressed: _salvarDados,


                    child: const Text("Entrar"),
                  ),
                ),


                const SizedBox(height: 10),


                SizedBox(
                  width: largura * 0.9,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                    ),
                    onPressed: () {},
                    child: const Text("Criar conta"),
                  ),
                ),


                const SizedBox(height: 20),


                Text(
                  'Email salvo: $emailSalvo',
                  style: const TextStyle(fontSize: 16),
                ),


                const SizedBox(height: 10),


                Text(
                  'Senha salva: $senhaSalva',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
