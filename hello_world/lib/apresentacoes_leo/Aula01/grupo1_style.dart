import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isLoadingProducts = false;
  int _selectedIndex = 0;

  Future<void> _loadProducts() async {
    setState(() => _isLoadingProducts = true);

    await Future.delayed(Duration(seconds: 2));

    setState(() => _isLoadingProducts = false);
  }

  void mostrarSnackBar(
    ScaffoldMessengerState scaffoldMessenger,
    String mensagem,
  ) {
    scaffoldMessenger.showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),

            SizedBox(width: 10),

            Text(
              mensagem,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        backgroundColor: Colors.green,

        behavior: SnackBarBehavior.floating,

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),

        margin: EdgeInsets.all(16),

        duration: Duration(seconds: 3),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 86, 221, 255),
          title: Text(
            "Minha Loja",
            style: TextStyle(
              color: const Color.fromARGB(255, 255, 255, 255),
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        body: _isLoadingProducts
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircularProgressIndicator(),

                    SizedBox(height: 16),

                    Text('Carregando produtos...'),
                  ],
                ),
              )
            : Center(
                child: ElevatedButton(
                  onPressed: _loadProducts,
                  child: Text('Carregar produtos'),
                ),
              ),

        drawer: Drawer(
          child: ListView(
            children: [
              //Cabeçário do Header
              DrawerHeader(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 58, 216, 255),
                ),
                child: Text(
                  'Minha Loja',
                  style: TextStyle(
                    fontSize: 24,
                    color: const Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
              ),

              // Tópicos da lista
              ListTile(
                leading: Icon(Icons.home, size: 40),
                title: Text('Início', style: TextStyle(fontSize: 24)),
                onTap: () {
                  print('Início');
                },
              ),

              SizedBox(height: 10),

              // LIST TILE COM POPUP MENU
              ListTile(
                leading: Icon(Icons.shopping_bag, size: 40),
                title: Text('Produtos', style: TextStyle(fontSize: 24)),

                trailing: Builder(
                  builder: (localContext) {
                    // SALVA O SCAFFOLD MESSENGER
                    final scaffoldMessenger = ScaffoldMessenger.of(
                      localContext,
                    );

                    return PopupMenuButton<String>(
                      icon: Icon(Icons.more_vert, size: 30),

                      onSelected: (value) {
                        Navigator.pop(localContext); // Fecha o menu

                        switch (value) {
                          case 'adicionar':
                            mostrarSnackBar(
                              scaffoldMessenger,
                              'Produto adicionado.',
                            );
                            print('Produto adicionado');
                            break;

                          case 'editar':
                            mostrarSnackBar(
                              scaffoldMessenger,
                              'Produto editado.',
                            );
                            print('Produto editado');
                            break;

                          case 'remover':

                            // Caixa de confirmação para Remoção
                            showDialog(
                              context: localContext,
                              builder: (BuildContext dialogContext) {
                                return AlertDialog(
                                  title: Text(
                                    'Confirmar Remoção',
                                    style: TextStyle(fontSize: 25),
                                  ),

                                  content: Text(
                                    'Tem certeza que deseja remover este produto?',
                                    style: TextStyle(fontSize: 20),
                                  ),

                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(dialogContext).pop();
                                        print('Remoção cancelada');
                                      },

                                      child: Text(
                                        'Cancelar',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),

                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(dialogContext).pop();
                                        mostrarSnackBar(
                                          scaffoldMessenger,
                                          'Produto removido',
                                        );

                                        print('Produto removido');
                                      },

                                      style: TextButton.styleFrom(
                                        foregroundColor: Colors.red,
                                      ),

                                      child: Text(
                                        'Remover',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );

                            break;
                        }
                      },

                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'adicionar',

                          child: Row(
                            children: [
                              Icon(Icons.add, size: 30),

                              SizedBox(width: 10),

                              Text('Adicionar', style: TextStyle(fontSize: 20)),
                            ],
                          ),
                        ),

                        PopupMenuItem(
                          value: 'editar',

                          child: Row(
                            children: [
                              Icon(Icons.edit, size: 30),

                              SizedBox(width: 10),

                              Text('Editar', style: TextStyle(fontSize: 20)),
                            ],
                          ),
                        ),

                        PopupMenuItem(
                          value: 'remover',

                          child: Row(
                            children: [
                              Icon(Icons.delete, color: Colors.red, size: 30),

                              SizedBox(width: 10),

                              Text(
                                'Remover',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 20,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  },
                ),

                onTap: () {
                  print('Abrir Produtos');
                },
              ),

              SizedBox(height: 10),

              ListTile(
                leading: Icon(Icons.list_alt_outlined, size: 40),
                title: Text('Pedidos', style: TextStyle(fontSize: 24)),
                onTap: () {
                  print('Pedidos');
                },
              ),

              SizedBox(height: 10),

              ListTile(
                leading: Icon(Icons.star, size: 40),
                title: Text('Favoritos', style: TextStyle(fontSize: 24)),
                onTap: () {
                  print('Favoritos');
                },
              ),

              SizedBox(height: 10),

              ListTile(
                leading: Icon(Icons.settings, size: 40),
                title: Text('Configurações', style: TextStyle(fontSize: 24)),
                onTap: () {
                  print('Configurações');
                },
              ),
            ],
          ),
        ),

        // BOTTOM NAVIGATION BAR
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          backgroundColor: const Color.fromARGB(255, 86, 221, 255),

          onTap: (i) {
            setState(() {
              _selectedIndex = i;
            });
          },

          selectedItemColor: const Color.fromARGB(255, 0, 5, 144),
          unselectedItemColor: const Color.fromARGB(255, 95, 95, 95),

          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),

            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag),
              label: 'Produtos',
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.list_alt_outlined),
              label: 'Pedidos',
            ),
          ],
        ),
      ),
    );
  }
}
