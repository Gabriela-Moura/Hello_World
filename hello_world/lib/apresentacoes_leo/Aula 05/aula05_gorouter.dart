import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../pages/produto_page.dart';
import '../pages/carrinho_page.dart';

// MODELO DO PRODUTO
class Suculenta {
  // Classe que representa uma suculenta da loja. Funciona como um "molde" para criar produtos.
  final int id;
  final String nome;
  final String nomeCientifico;
  final String emoji;
  final double preco;
  final String descricao;

  const Suculenta({
    // Construtor da classe. O "required" obriga que todos os campos sejam preenchidos ao criar uma suculenta.
    required this.id,
    required this.nome,
    required this.nomeCientifico,
    required this.emoji,
    required this.preco,
    required this.descricao,
  });
}

// CATÁLOGO DE PRODUTOS
// Lista constante contendo todos os produtos da loja. O tipo da lista é List<Suculenta>, ou seja, uma lista composta apenas por objetos Suculenta.
const List<Suculenta> produtos = [
  Suculenta(
    id: 1,
    nome: 'Roseta-de-Pedra',
    nomeCientifico: 'Echeveria elegans',
    emoji: '🌸',
    preco: 18.90,
    descricao: 'Suculenta compacta com folhas em roseta verde-azuladas.',
  ),

  Suculenta(
    id: 2,
    nome: 'Muda feijão',
    nomeCientifico: 'Haworthiopsis attenuata',
    emoji: '🌱',
    preco: 5.00,
    descricao: 'O principal grão das refeições brasileiras.',
  ),

  Suculenta(
    id: 3,
    nome: 'Babosa',
    nomeCientifico: 'Aloe vera',
    emoji: '🌿',
    preco: 32.00,
    descricao: 'Gel das folhas hidrata a pele e alivia queimaduras.',
  ),

  Suculenta(
    id: 4,
    nome: 'Cacto-Ouriço',
    nomeCientifico: 'Echinocactus grusonii',
    emoji: '🌵',
    preco: 15.00,
    descricao: 'praticamente não precisa de água.',
  ),
];

// ITEM DO CARRINHO

// Classe utilizada para representar um item armazenado dentro do carrinho.
class ItemCarrinho {
  final Suculenta produto;
  int quantidade;
  // Construtor.
  ItemCarrinho(this.produto, this.quantidade);
}

// CONTROLE DO CARRINHO

// ChangeNotifier permite avisar a interface sempre que alguma informação for alterada.
// Quando notifyListeners() é chamado, todos os widgets que estiverem ouvindo esse objeto serão atualizados automaticamente.
class CarrinhoController extends ChangeNotifier {
  // Lista que armazena todos os itens atualmente presentes no carrinho.
  List<ItemCarrinho> itens = [];

  // ADICIONAR PRODUTO
  void adicionar(Suculenta produto) {
    for (var item in itens) {
      // Percorre todos os itens do carrinho.
      if (item.produto.id == produto.id) {
        // Verifica se o produto já existe no carrinho.
        item.quantidade++; // Se existir, aumenta a quantidade em 1.
        notifyListeners(); // Atualiza todos os widgets que estão no carrinho.
        return;
      }
    }

    // Caso o produto não exista no carrinho, cria um novo item com quantidade inicial igual a 1.
    itens.add(ItemCarrinho(produto, 1));
    notifyListeners(); // Atualiza a interface.
  }

  // REMOVER PRODUTO
  void remover(Suculenta produto) {
    // Remove uma unidade do produto.
    for (int i = 0; i < itens.length; i++) {
      // Percorre todos os itens da lista.
      if (itens[i].produto.id == produto.id) {
        // Verifica se encontrou o produto.
        if (itens[i].quantidade > 1) {
          // Se houver mais de uma unidade.
          itens[i].quantidade--; // Diminui apenas uma unidade.
        } else {
          // Se houver apenas uma unidade, remove completamente o item.
          itens.removeAt(i);
        }

        notifyListeners();
        return;
      }
    }
  }

  // REMOVER ITEM COMPLETAMENTE
  void removerItemCompleto(Suculenta produto) {
    // Remove todas as unidades de um produto de uma única vez.
    itens.removeWhere(
      // removeWhere percorre a lista e remove todos os elementos que atendam à condição.
      (item) =>
          item.produto.id ==
          produto
              .id, // Verifica se o ID do item é igual ao ID do produto recebido como parâmetro.
    );

    notifyListeners();
  }

  // VALOR TOTAL DA COMPRA
  double get total {
    // Getter utilizado para calcular o valor total de todos os produtos do carrinho.
    double soma = 0;
    for (var item in itens) {
      // Percorre todos os itens do carrinho.
      soma +=
          item.produto.preco *
          item.quantidade; // Multiplica o preço do produto pela quantidade e adiciona ao total acumulado.
    }
    return soma;
  }

  // QUANTIDADE TOTAL DE ITENS
  int get totalItens {
    // Getter que calcula quantos itens existem no carrinho.
    int soma = 0;
    for (var item in itens) {
      soma += item.quantidade; // Soma a quantidade de cada produto.
    }
    return soma;
  }

  // LIMPAR CARRINHO
  void limpar() {
    // Remove todos os produtos do carrinho.
    itens.clear(); // Esvazia completamente a lista.
    notifyListeners();
  }
}

// INSTÂNCIA GLOBAL DO CARRINHO
final carrinho =
    CarrinhoController(); // Cria um único carrinho compartilhado por todo o aplicativo.

// ------------- CONFIGURAÇÃO DAS ROTAS ---------------------------
final GoRouter router = GoRouter(
  // Define qual página será aberta quando o aplicativo iniciar.
  initialLocation: '/',
  // Lista de rotas disponíveis.
  routes: [
    GoRoute(
      path: '/', // Caminho da página inicial.
      builder: (context, state) => const HomePage(), // Widget que será exibido.
    ),

    GoRoute(
      path: '/produto/:id', // :id = parâmetro dinâmico
      builder: (context, state) {
        // Obtém o parâmetro enviado pela URL.
        final id = int.parse(
          state.pathParameters['id']!,
        ); // Procura dentro da lista de produtos aquele cujo ID seja igual ao recebido.
        final produto = produtos.firstWhere(
          (p) => p.id == id,
        ); // Abre a página de detalhes do produto.
        return ProdutoPage(produto: produto);
      },
    ),

    // INSERIR O CODIGO AQUI
    GoRoute(
      path: '/carrinho',
      builder: (context, state) => const CarrinhoPage(),
    ),
  ],
);

//FUNÇÃO PRINCIPAL
void main() => runApp(const MeuApp());

class MeuApp extends StatelessWidget {
  const MeuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Suculenta & Cia',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF4A7C59)),
        useMaterial3: true,
      ),

      routerConfig: router,
    );
  }
}

// HOME PAGE
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // cria a estrutura básica da tela
      appBar: AppBar(
        title: const Text('🌵 Suculentas & Cia'),
        backgroundColor: const Color(0xFF4A7C59),
        foregroundColor: Colors.white,
        actions: [
          // Área de ações da AppBar.

          // Escuta alterações do carrinho.
          // Sempre que notifyListeners() for executado dentro do carrinho, este widget será reconstruído.
          ListenableBuilder(
            listenable: carrinho, // Objeto observado.
            builder: (context, _) {
              return Stack(
                // Stack permite empilhar widgets.
                children: [
                  // BOTÃO DO CARRINHO
                  IconButton(
                    icon: const Icon(Icons.shopping_cart_outlined),
                    onPressed: () => context.push('/carrinho'),
                  ),

                  // BADGE DE QUANTIDADE
                  if (carrinho.totalItens >
                      0) // Só aparece se existir pelo menos um item no carrinho.
                    Positioned(
                      right: 6,
                      top: 6,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          color: Colors.orange,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '${carrinho.totalItens}', // Quantidade total de itens.
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),

      // CORPO DA PÁGINA
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: produtos.length, // Quantidade de produtos.
        itemBuilder: (context, index) {
          // Responsável por construir cada item.
          final produto = produtos[index]; // Obtém o produto atual.
          return Card(
            // Card utilizado para destacar visualmente cada produto da lista.
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              // ListTile organiza automaticamente

              // EMOJI DO PRODUTO
              leading: Text(
                produto.emoji,
                style: const TextStyle(fontSize: 36),
              ),

              // NOME DO PRODUTO
              title: Text(produto.nome),

              // SUBTÍTULO
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    produto.nomeCientifico,
                    style: const TextStyle(
                      fontStyle: FontStyle.italic,
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),

                  Text(
                    'R\$ ${produto.preco.toStringAsFixed(2)}',
                  ), // Preço do produto.
                ],
              ),

              isThreeLine:
                  true, // Informa que o subtítulo possui mais de uma linha.
              // SETA LATERAL
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),

              // ABRIR PRODUTO
              onTap: () => context.go('/produto/${produto.id}'),
            ),
          );
        },
      ),
    );
  }
}
