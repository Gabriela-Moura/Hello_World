import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override //Configura o MaterialApp. Definimos o título, removemos a etiqueta de debug
  Widget build(BuildContext context) {
    //E aplicamos um tema baseado na cor verde (0xFF4CAF50), ativando o Material 3.
    return MaterialApp(
      //O Material 3 é a próxima geração do design system do Google
      title:
          'Minhas Tarefas', //Trazendo uma aparência mais moderna e personalizável para os aplicativos Flutter
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4CAF50)),
        useMaterial3: true,
      ),
      home: const TarefasPage(),
    );
  }
}

class TarefasPage extends StatefulWidget {
  //O StatefulWiget permite que o dados modificados apareção atualizados na tela
  const TarefasPage({super.key});

  @override
  State<TarefasPage> createState() => _TarefasPageState(); //Cria o objeto de estado associado a este widget.
}

class _TarefasPageState extends State<TarefasPage> {
  //logica do estado da pagina
  final List<Map<String, dynamic>> _tarefas = [
    //Lista de tarefas, onde cada tarefa é representada por um mapa contendo o título e o status de conclusão
    {'titulo': 'Fazer a apresentação', 'concluida': true},
    {'titulo': 'Terminar as páginas', 'concluida': false},
    {'titulo': 'Terminar a ficha da Carol', 'concluida': false},
  ];

  final TextEditingController _controller =
      TextEditingController(); //Controller que permite ler o texto digitado pelo usuario

  void _adicionarTarefa() {
    //função para adicionar algo na lista
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("nova tarefa"),
          content: TextField(
            autofocus: true,
            decoration: const InputDecoration(
              hintText: "digite o nome da tarefa",
            ),
            onSubmitted: (_) => _salvarTarefa(),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _controller.clear();
                Navigator.pop(context);
              },
              child: const Text("cancelar"),
            ),
            ElevatedButton(
              onPressed: _salvarTarefa,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4CAF50),
                foregroundColor: Colors.white,
              ),
              child: const Text('Adicionar'),
            ),
          ],
        );
      },
    );
  }

  void _salvarTarefa() {
    //Função para salvar a tarefa na lista
    final texto = _controller.text
        .trim(); //Obtém o texto digitado pelo usuário e remove espaços em branco extras
    if (texto.isNotEmpty) {
      //Verifica se o texto não está vazio
      setState(() {
        //Chama setState para atualizar a interface do usuário com a nova tarefa
        _tarefas.add({
          'titulo': texto,
          'concluida': false,
        }); //adiciona um novo mapa a lista
      });
      _controller.clear(); //Limpa o campo de texto para a próxima entrada
      Navigator.pop(
        context,
      ); //Fecha a janela de diálogo após adicionar a tarefa
    }
  }

  void _excluirTarefa(int index) {
    //Função para excluir uma tarefa da lista, recebe o índice da tarefa a ser removida
    setState(() {
      _tarefas.removeAt(
        index,
      ); //Remove a tarefa da lista usando o método removeAt, que remove o elemento no índice especificado
    });
  }

  void _alternarConclusao(int index) {
    //Função para alternar o status de conclusão de uma tarefa, recebe o índice da tarefa a ser atualizada
    setState(() {
      _tarefas[index]['concluida'] =
          !_tarefas[index]['concluida']; //Inverte o valor booleano do campo 'concluida' da tarefa, marcando-a como concluída ou não concluída
    });
  }

  @override
  void dispose() {
    //Chamado quando o widget é removido permanentemente da árvore.
    _controller
        .dispose(); //Libera os recursos usados pelo TextEditingController para evitar vazamentos de memória
    super
        .dispose(); //Chama o método dispose da classe pai para garantir que qualquer limpeza adicional seja realizada
  }

  @override //Construção da interface principal
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Minhas Tarefas',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: const Color(0xFF4CAF50),
      ),
      body: _tarefas.isEmpty
          ? const Center(
              child: Text(
                'Nenhuma tarefa ainda.\nToque em + para adicionar!',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              //Constrói uma lista de tarefas usando ListView.builder, que é eficiente para listas longas, pois constrói apenas os itens visíveis na tela
              padding: const EdgeInsets.symmetric(vertical: 8),
              itemCount: _tarefas
                  .length, //Especifica o número de itens na lista, que é igual ao número de tarefas
              itemBuilder: (context, index) {
                //Função que constrói cada item da lista, recebe o contexto e o índice do item a ser construído
                final tarefa = _tarefas[index];
                return ListTile(
                  //Cada tarefa é representada por um ListTile, que inclui um Checkbox para marcar a conclusão, o título da tarefa e um botão de exclusão
                  leading: Checkbox(
                    value: tarefa['concluida'],
                    activeColor: const Color(0xFF4CAF50),
                    onChanged: (_) => _alternarConclusao(index),
                  ),
                  title: Text(
                    tarefa['titulo'],
                    style: TextStyle(
                      fontSize: 16,
                      decoration: tarefa['concluida']
                          ? TextDecoration.lineThrough
                          : null,
                      color: tarefa['concluida'] ? Colors.grey : Colors.black87,
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(
                      Icons.delete_outline,
                      color: Colors.redAccent,
                    ),
                    onPressed: () => _excluirTarefa(index),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        //Botão flutuante para adicionar novas tarefas, que chama a função _adicionarTarefa quando pressionado
        onPressed: _adicionarTarefa,
        backgroundColor: const Color(0xFF4CAF50),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}
