import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// ---------------------------------------------------------------------------
// CONFIGURAÇÃO
// Emulador Android  -> http://10.0.2.2/pdm_api
// Celular físico    -> http://IP_DO_SEU_PC/pdm_api  (mesma rede Wi-Fi)
// ---------------------------------------------------------------------------
const String baseUrl = 'http://10.140.170.33/PDM_API/tarefas.php';

void main() => runApp(const MyApp());

// ------------------------------- MODELO ------------------------------------
enum Prioridade { baixa, media, alta }

enum Status { pendente, concluida }

class Tarefa {
  final int? id;
  final String titulo;
  final String descricao;
  final Prioridade prioridade;
  final Status status;
  final DateTime criadoEm;

  Tarefa({
    this.id,
    required this.titulo,
    required this.descricao,
    required this.prioridade,
    required this.status,
    required this.criadoEm,
  });

  factory Tarefa.fromJson(Map<String, dynamic> j) {
    final id = int.tryParse(j['id']?.toString() ?? '');
    final titulo = j['titulo']?.toString();
    final descricao = j['descricao']?.toString();
    final prioridadeTexto = j['prioridade']?.toString().trim().toLowerCase();
    final statusTexto = j['status']?.toString().trim().toLowerCase();
    final criadoEmTexto = j['criado_em']?.toString();

    if (id == null ||
        titulo == null ||
        descricao == null ||
        prioridadeTexto == null ||
        statusTexto == null ||
        criadoEmTexto == null) {
      throw const FormatException('A tarefa recebida possui campos inválidos.');
    }

    final prioridadeNormalizada = prioridadeTexto.replaceAll('é', 'e');
    final statusNormalizado = statusTexto.replaceAll('í', 'i');
    final prioridade = Prioridade.values
        .where((value) => value.name == prioridadeNormalizada)
        .firstOrNull;
    final status = Status.values
        .where((value) => value.name == statusNormalizado)
        .firstOrNull;
    final criadoEm = DateTime.tryParse(criadoEmTexto);

    if (prioridade == null || status == null || criadoEm == null) {
      throw const FormatException(
        'A tarefa recebida possui prioridade, status ou data inválida.',
      );
    }

    return Tarefa(
      id: id,
      titulo: titulo,
      descricao: descricao,
      prioridade: prioridade,
      status: status,
      criadoEm: criadoEm,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'titulo': titulo,
    'descricao': descricao,
    'prioridade': prioridade.name,
    'status': status.name,
    'criado_em': criadoEm.toIso8601String(),
  };
}

// -------------------------------- API --------------------------------------
class ApiException implements Exception {
  const ApiException(this.message);

  final String message;

  @override
  String toString() => message;
}

class Api {
  static final ValueNotifier<String> log = ValueNotifier<String>(
    'Nenhuma requisição ainda',
  );

  static const _headers = {
    'Accept': 'application/json',
    'Content-Type': 'application/json; charset=UTF-8',
  };
  static const _timeout = Duration(seconds: 10);

  static Uri _uri({int? id}) {
    final uri = Uri.parse(baseUrl);
    return id == null
        ? uri
        : uri.replace(queryParameters: {'id': id.toString()});
  }

  static void _registrar(String metodo, Uri uri, http.Response response) {
    log.value = '$metodo $uri → ${response.statusCode}';
  }

  static void _verificarSucesso(http.Response response) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw ApiException(_mensagemErro(response));
    }
  }

  static String _mensagemErro(http.Response response) {
    final corpo = response.body.trim();
    if (corpo.isNotEmpty) {
      try {
        final decoded = jsonDecode(corpo);
        if (decoded is Map) {
          final mensagem = decoded['erro'] ?? decoded['message'];
          if (mensagem != null && mensagem.toString().trim().isNotEmpty) {
            return mensagem.toString();
          }
        }
      } on FormatException {
        // Algumas APIs retornam texto em vez de JSON nos erros.
      }
      return 'Erro HTTP ${response.statusCode}: $corpo';
    }
    return 'Erro HTTP ${response.statusCode}.';
  }

  static Future<List<Tarefa>> listar() async {
    final uri = _uri();
    final response = await http.get(uri, headers: _headers).timeout(_timeout);
    _registrar('GET', uri, response);
    _verificarSucesso(response);

    final decoded = jsonDecode(response.body);
    final tarefasJson = decoded is List
        ? decoded
        : decoded is Map<String, dynamic>
        ? decoded['dados']
        : null;
    if (tarefasJson is! List) {
      throw const ApiException(
        'A resposta da API não contém uma lista de tarefas em "dados".',
      );
    }
    return tarefasJson.map((item) {
      if (item is! Map<String, dynamic>) {
        throw const FormatException('A API retornou uma tarefa inválida.');
      }
      return Tarefa.fromJson(item);
    }).toList();
  }

  static Future<void> criar(Tarefa tarefa) async {
    final uri = _uri();
    final response = await http
        .post(uri, headers: _headers, body: jsonEncode(tarefa.toJson()))
        .timeout(_timeout);
    _registrar('POST', uri, response);
    _verificarSucesso(response);
  }

  static Future<void> atualizar(Tarefa tarefa) async {
    final id = tarefa.id;
    if (id == null) {
      throw const ApiException('Não é possível atualizar tarefa sem ID.');
    }

    final uri = _uri(id: id);
    final response = await http
        .put(uri, headers: _headers, body: jsonEncode(tarefa.toJson()))
        .timeout(_timeout);
    _registrar('PUT', uri, response);
    _verificarSucesso(response);
  }

  static Future<void> excluir(int id) async {
    final uri = _uri(id: id);
    final response = await http
        .delete(uri, headers: _headers)
        .timeout(_timeout);
    _registrar('DELETE', uri, response);
    _verificarSucesso(response);
  }
}

// ------------------------------- APP --------------------------------------
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Minhas tarefas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: const TarefasPage(),
    );
  }
}

class TarefasPage extends StatefulWidget {
  const TarefasPage({super.key});

  @override
  State<TarefasPage> createState() => _TarefasPageState();
}

class _TarefasPageState extends State<TarefasPage> {
  List<Tarefa> _tarefas = [];
  bool _carregando = true;
  String? _erro;

  @override
  void initState() {
    super.initState();
    _carregar();
  }

  Future<void> _carregar() async {
    setState(() {
      _carregando = true;
      _erro = null;
    });
    try {
      final tarefas = await Api.listar();
      if (!mounted) return;
      setState(() => _tarefas = tarefas);
    } catch (e) {
      if (!mounted) return;
      setState(() => _erro = e.toString());
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  void _mensagem(String texto) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(texto)));
  }

  String _data(DateTime data) {
    final local = data.toLocal();
    String dois(int valor) => valor.toString().padLeft(2, '0');
    return '${dois(local.day)}/${dois(local.month)}/${local.year} '
        '${dois(local.hour)}:${dois(local.minute)}';
  }

  Future<void> _abrirFormulario({Tarefa? tarefa}) async {
    final tituloController = TextEditingController(text: tarefa?.titulo ?? '');
    final descricaoController = TextEditingController(
      text: tarefa?.descricao ?? '',
    );
    var prioridadeSelecionada = tarefa?.prioridade ?? Prioridade.media;
    var statusSelecionado = tarefa?.status ?? Status.pendente;
    String? erroFormulario;

    Tarefa? resultado;
    try {
      resultado = await showDialog<Tarefa>(
        context: context,
        builder: (dialogContext) => StatefulBuilder(
          builder: (context, atualizarDialogo) => AlertDialog(
            title: Text(tarefa == null ? 'Nova tarefa' : 'Editar tarefa'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: tituloController,
                    textCapitalization: TextCapitalization.sentences,
                    decoration: const InputDecoration(labelText: 'Título'),
                  ),
                  TextField(
                    controller: descricaoController,
                    textCapitalization: TextCapitalization.sentences,
                    maxLines: 3,
                    decoration: const InputDecoration(labelText: 'Descrição'),
                  ),
                  DropdownButtonFormField<Prioridade>(
                    initialValue: prioridadeSelecionada,
                    decoration: const InputDecoration(labelText: 'Prioridade'),
                    items: Prioridade.values
                        .map(
                          (valor) => DropdownMenuItem(
                            value: valor,
                            child: Text(valor.name),
                          ),
                        )
                        .toList(),
                    onChanged: (valor) {
                      if (valor != null) {
                        atualizarDialogo(() => prioridadeSelecionada = valor);
                      }
                    },
                  ),
                  DropdownButtonFormField<Status>(
                    initialValue: statusSelecionado,
                    decoration: const InputDecoration(labelText: 'Status'),
                    items: Status.values
                        .map(
                          (valor) => DropdownMenuItem(
                            value: valor,
                            child: Text(
                              valor == Status.concluida
                                  ? 'Concluída'
                                  : 'Pendente',
                            ),
                          ),
                        )
                        .toList(),
                    onChanged: (valor) {
                      if (valor != null) {
                        atualizarDialogo(() => statusSelecionado = valor);
                      }
                    },
                  ),
                  if (erroFormulario != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        erroFormulario!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext),
                child: const Text('Cancelar'),
              ),
              FilledButton(
                onPressed: () {
                  final titulo = tituloController.text.trim();
                  final descricao = descricaoController.text.trim();
                  if (titulo.isEmpty || descricao.isEmpty) {
                    atualizarDialogo(
                      () => erroFormulario = 'Preencha título e descrição.',
                    );
                    return;
                  }

                  Navigator.pop(
                    dialogContext,
                    Tarefa(
                      id: tarefa?.id,
                      titulo: titulo,
                      descricao: descricao,
                      prioridade: prioridadeSelecionada,
                      status: statusSelecionado,
                      criadoEm: tarefa?.criadoEm ?? DateTime.now(),
                    ),
                  );
                },
                child: const Text('Salvar'),
              ),
            ],
          ),
        ),
      );
    } finally {
      tituloController.dispose();
      descricaoController.dispose();
    }

    if (resultado == null) return;

    try {
      if (tarefa == null) {
        await Api.criar(resultado);
      } else {
        await Api.atualizar(resultado);
      }
      _mensagem(tarefa == null ? 'Tarefa criada.' : 'Tarefa atualizada.');
      await _carregar();
    } catch (e) {
      _mensagem(e.toString());
    }
  }

  Future<void> _excluir(Tarefa tarefa) async {
    final id = tarefa.id;
    if (id == null) {
      _mensagem('Não é possível excluir uma tarefa sem ID.');
      return;
    }

    try {
      await Api.excluir(id);
      if (!mounted) return;
      setState(() => _tarefas.removeWhere((item) => item.id == id));
      _mensagem('Tarefa excluída.');
    } catch (e) {
      _mensagem(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas tarefas'),
        actions: [
          IconButton(
            tooltip: 'Atualizar lista',
            icon: const Icon(Icons.refresh),
            onPressed: _carregar,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _abrirFormulario(),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          ValueListenableBuilder<String>(
            valueListenable: Api.log,
            builder: (context, texto, child) => Container(
              width: double.infinity,
              color: Colors.black87,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Text(
                texto,
                style: const TextStyle(
                  color: Colors.greenAccent,
                  fontFamily: 'monospace',
                  fontSize: 13,
                ),
              ),
            ),
          ),
          Expanded(child: _corpo()),
        ],
      ),
    );
  }

  Widget _corpo() {
    if (_carregando) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_erro != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_erro!, textAlign: TextAlign.center),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _carregar,
                child: const Text('Tentar novamente'),
              ),
            ],
          ),
        ),
      );
    }
    return RefreshIndicator(
      onRefresh: _carregar,
      child: _tarefas.isEmpty
          ? ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: const [
                SizedBox(height: 120),
                Center(child: Text('Nenhuma tarefa cadastrada.')),
              ],
            )
          : ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              itemCount: _tarefas.length,
              itemBuilder: (context, index) {
                final tarefa = _tarefas[index];
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(tarefa.id?.toString() ?? '-'),
                  ),
                  title: Text(
                    tarefa.titulo,
                    style: TextStyle(
                      decoration: tarefa.status == Status.concluida
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                  subtitle: Text(
                    '${tarefa.descricao}\n'
                    'Prioridade: ${tarefa.prioridade.name} · '
                    'Status: ${tarefa.status == Status.concluida ? 'Concluída' : 'Pendente'}\n'
                    'Criada em: ${_data(tarefa.criadoEm)}',
                  ),
                  isThreeLine: true,
                  trailing: PopupMenuButton<String>(
                    onSelected: (acao) {
                      if (acao == 'editar') {
                        _abrirFormulario(tarefa: tarefa);
                      } else if (acao == 'excluir') {
                        _excluir(tarefa);
                      }
                    },
                    itemBuilder: (context) => const [
                      PopupMenuItem(value: 'editar', child: Text('Editar')),
                      PopupMenuItem(value: 'excluir', child: Text('Excluir')),
                    ],
                  ),
                  onTap: () => _abrirFormulario(tarefa: tarefa),
                );
              },
            ),
    );
  }
}