import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// CONFIGURAÇÃO
// Emulador Android: http://10.0.2.2/PDM_API
// Celular físico:   http://IP_DO_SEU_PC/PDM_API
// O computador e o celular devem estar na mesma rede Wi-Fi.
const String baseUrl = 'http://10.140.170.33/PDM_API';

void main() {
  runApp(const MyApp());
}

// MODELO
enum Prioridade { baixa, media, alta }

enum Status { pendente, concluida }

class Tarefa {
  final int? id;
  final String titulo;
  final String descricao;
  final Prioridade prioridade;
  final Status status;
  final DateTime criadoEm;

  const Tarefa({
    this.id,
    required this.titulo,
    required this.descricao,
    required this.prioridade,
    required this.status,
    required this.criadoEm,
  });

  factory Tarefa.fromJson(Map<String, dynamic> json) {
    final prioridadeTexto =
        (json['prioridade'] ?? 'media').toString().toLowerCase();
    final statusTexto =
        (json['status'] ?? 'pendente').toString().toLowerCase();

    return Tarefa(
      id: json['id'] == null ? null : int.tryParse(json['id'].toString()),
      titulo: (json['titulo'] ?? '').toString(),
      descricao: (json['descricao'] ?? '').toString(),
      prioridade: Prioridade.values.firstWhere(
        (item) => item.name == prioridadeTexto,
        orElse: () => Prioridade.media,
      ),
      status: Status.values.firstWhere(
        (item) => item.name == statusTexto,
        orElse: () => Status.pendente,
      ),
      criadoEm: DateTime.tryParse((json['criado_em'] ?? '').toString()) ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toJson({bool incluirId = false}) {
    return {
      if (incluirId && id != null) 'id': id,
      'titulo': titulo,
      'descricao': descricao,
      'prioridade': prioridade.name,
      'status': status.name,
      'criado_em': criadoEm.toIso8601String(),
    };
  }
}

// API
class Api {
  static final ValueNotifier<String> log =
      ValueNotifier<String>('Nenhuma requisição ainda');

  static const Map<String, String> _headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  static const Duration _timeout = Duration(seconds: 10);

  static Uri _tarefasUri({int? id}) {
    return Uri.parse('$baseUrl/tarefas.php').replace(
      queryParameters: id == null ? null : {'id': id.toString()},
    );
  }

  static void _registrar(String metodo, String caminho, http.Response resposta) {
    log.value = '$metodo $caminho → ${resposta.statusCode}';
  }

  static Future<List<Tarefa>> listar() async {
    final uri = _tarefasUri();
    final resposta = await http.get(uri, headers: _headers).timeout(_timeout);
    _registrar('GET', '/tarefas', resposta);

    if (resposta.statusCode != 200) {
      throw Exception(_mensagemErro(resposta));
    }

    final dados = jsonDecode(resposta.body);
    if (dados is! List) {
      throw Exception('A API não retornou uma lista de tarefas.');
    }

    return dados
        .map((item) => Tarefa.fromJson(Map<String, dynamic>.from(item as Map)))
        .toList();
  }

  static Future<void> criar(Tarefa tarefa) async {
    final uri = _tarefasUri();
    final resposta = await http
        .post(
          uri,
          headers: _headers,
          body: jsonEncode(tarefa.toJson()),
        )
        .timeout(_timeout);

    _registrar('POST', '/tarefas', resposta);
    if (resposta.statusCode != 200 && resposta.statusCode != 201) {
      throw Exception(_mensagemErro(resposta));
    }
  }

  static Future<void> atualizar(Tarefa tarefa) async {
    if (tarefa.id == null) {
      throw Exception('Não foi possível editar: a tarefa não possui ID.');
    }

    final uri = _tarefasUri(id: tarefa.id);
    final resposta = await http
        .put(
          uri,
          headers: _headers,
          body: jsonEncode(tarefa.toJson(incluirId: true)),
        )
        .timeout(_timeout);

    _registrar('PUT', '/tarefas/${tarefa.id}', resposta);
    if (resposta.statusCode != 200) {
      throw Exception(_mensagemErro(resposta));
    }
  }

  static Future<void> excluir(int id) async {
    final uri = _tarefasUri(id: id);
    final resposta = await http.delete(uri, headers: _headers).timeout(_timeout);

    _registrar('DELETE', '/tarefas/$id', resposta);
    if (resposta.statusCode != 200) {
      throw Exception(_mensagemErro(resposta));
    }
  }

  static String _mensagemErro(http.Response resposta) {
    try {
      final dados = jsonDecode(resposta.body);
      if (dados is Map && dados['erro'] != null) {
        return dados['erro'].toString();
      }
      if (dados is Map && dados['mensagem'] != null) {
        return dados['mensagem'].toString();
      }
    } catch (_) {
      // A resposta não veio em JSON.
    }
    return 'Erro HTTP ${resposta.statusCode}: ${resposta.body}';
  }
}

// APLICATIVO
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gerenciador de tarefas',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: const Color(0xFFE6F603),
        useMaterial3: true,
      ),
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
    } catch (erro) {
      if (!mounted) return;
      setState(() {
        _erro = 'Não foi possível conectar à API.\n'
            'Confira se o Apache está ligado e se a baseUrl está correta.\n\n'
            '$erro';
      });
    } finally {
      if (mounted) {
        setState(() => _carregando = false);
      }
    }
  }

  void _mensagem(String texto) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(texto)),
    );
  }

  String _dataFormatada(DateTime data) {
    final local = data.toLocal();
    final dia = local.day.toString().padLeft(2, '0');
    final mes = local.month.toString().padLeft(2, '0');
    final hora = local.hour.toString().padLeft(2, '0');
    final minuto = local.minute.toString().padLeft(2, '0');
    return '$dia/$mes/${local.year} às $hora:$minuto';
  }

  String _nomePrioridade(Prioridade prioridade) {
    switch (prioridade) {
      case Prioridade.baixa:
        return 'Baixa';
      case Prioridade.media:
        return 'Média';
      case Prioridade.alta:
        return 'Alta';
    }
  }

  String _nomeStatus(Status status) {
    return status == Status.pendente ? 'Pendente' : 'Concluída';
  }

  Future<void> _abrirFormulario({Tarefa? tarefa}) async {
    final tituloController =
        TextEditingController(text: tarefa?.titulo ?? '');
    final descricaoController =
        TextEditingController(text: tarefa?.descricao ?? '');
    Prioridade prioridadeSelecionada = tarefa?.prioridade ?? Prioridade.media;
    Status statusSelecionado = tarefa?.status ?? Status.pendente;

    final resultado = await showDialog<Tarefa>(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (contextDialog, atualizarDialog) {
            return AlertDialog(
              title: Text(tarefa == null ? 'Nova tarefa' : 'Editar tarefa'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: tituloController,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                        labelText: 'Título',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: descricaoController,
                      textCapitalization: TextCapitalization.sentences,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Descrição',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<Prioridade>(
                      value: prioridadeSelecionada,
                      decoration: const InputDecoration(
                        labelText: 'Prioridade',
                        border: OutlineInputBorder(),
                      ),
                      items: Prioridade.values.map((prioridade) {
                        return DropdownMenuItem(
                          value: prioridade,
                          child: Text(_nomePrioridade(prioridade)),
                        );
                      }).toList(),
                      onChanged: (valor) {
                        if (valor != null) {
                          atualizarDialog(
                            () => prioridadeSelecionada = valor,
                          );
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<Status>(
                      value: statusSelecionado,
                      decoration: const InputDecoration(
                        labelText: 'Status',
                        border: OutlineInputBorder(),
                      ),
                      items: Status.values.map((status) {
                        return DropdownMenuItem(
                          value: status,
                          child: Text(_nomeStatus(status)),
                        );
                      }).toList(),
                      onChanged: (valor) {
                        if (valor != null) {
                          atualizarDialog(() => statusSelecionado = valor);
                        }
                      },
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
                      ScaffoldMessenger.of(dialogContext).showSnackBar(
                        const SnackBar(
                          content: Text('Preencha o título e a descrição.'),
                        ),
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
                        // Na edição, preserva a data original.
                        // No cadastro, usa a data e hora atuais.
                        criadoEm: tarefa?.criadoEm ?? DateTime.now(),
                      ),
                    );
                  },
                  child: const Text('Salvar'),
                ),
              ],
            );
          },
        );
      },
    );

    tituloController.dispose();
    descricaoController.dispose();

    if (resultado == null) return;

    try {
      if (tarefa == null) {
        await Api.criar(resultado);
        if (!mounted) return;
        _mensagem('Tarefa cadastrada com sucesso.');
      } else {
        await Api.atualizar(resultado);
        if (!mounted) return;
        _mensagem('Tarefa atualizada com sucesso.');
      }
      await _carregar();
    } catch (erro) {
      if (!mounted) return;
      _mensagem(erro.toString().replaceFirst('Exception: ', ''));
    }
  }

  Future<void> _excluir(Tarefa tarefa) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Excluir tarefa?'),
        content: Text('Deseja excluir "${tarefa.titulo}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmar != true || tarefa.id == null) return;

    try {
      await Api.excluir(tarefa.id!);
      if (!mounted) return;
      _mensagem('Tarefa excluída com sucesso.');
      await _carregar();
    } catch (erro) {
      if (!mounted) return;
      _mensagem(erro.toString().replaceFirst('Exception: ', ''));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tarefas'),
        actions: [
          IconButton(
            tooltip: 'Recarregar',
            onPressed: _carregar,
            icon: const Icon(Icons.refresh),
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
            builder: (context, texto, child) {
              return Container(
                width: double.infinity,
                color: Colors.black87,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Text(
                  texto,
                  style: const TextStyle(
                    color: Colors.greenAccent,
                    fontFamily: 'monospace',
                    fontSize: 13,
                  ),
                ),
              );
            },
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

    if (_tarefas.isEmpty) {
      return RefreshIndicator(
        onRefresh: _carregar,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(height: 120),
            Center(child: Text('Nenhuma tarefa cadastrada.')),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _carregar,
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: _tarefas.length,
        itemBuilder: (context, indice) {
          final tarefa = _tarefas[indice];

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              leading: CircleAvatar(
                child: Text(tarefa.id?.toString() ?? '-'),
              ),
              title: Text(tarefa.titulo),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(tarefa.descricao),
                    const SizedBox(height: 5),
                    Text(
                      'Prioridade: ${_nomePrioridade(tarefa.prioridade)}'
                      ' • Status: ${_nomeStatus(tarefa.status)}',
                    ),
                    const SizedBox(height: 3),
                    Text(
                      'Criada em: ${_dataFormatada(tarefa.criadoEm)}',
                    ),
                  ],
                ),
              ),
              isThreeLine: true,
              trailing: PopupMenuButton<String>(
                onSelected: (opcao) {
                  if (opcao == 'editar') {
                    _abrirFormulario(tarefa: tarefa);
                  } else if (opcao == 'excluir') {
                    _excluir(tarefa);
                  }
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(
                    value: 'editar',
                    child: Text('Editar'),
                  ),
                  PopupMenuItem(
                    value: 'excluir',
                    child: Text('Excluir'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}