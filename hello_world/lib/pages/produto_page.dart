import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hello_world/main.dart';

// PÁGINA DE DETALHES DO PRODUTO
class ProdutoPage extends StatelessWidget {
  // Produto recebido através da navegação.
  // Quando o usuário clica em um item da HomePage, o produto correspondente é enviado para esta tela.
  final Suculenta produto; // Construtor da página.
  const ProdutoPage({super.key, required this.produto});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Scaffold cria a estrutura principal da página.
      appBar: AppBar(
        title: Text(produto.nome),
        backgroundColor: const Color(0xFF4A7C59),
        foregroundColor: Colors.white,
        leading: IconButton(
          // Botão de voltar.
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(), // Retorna para a página anterior.
        ),

        actions: [
          // Área de ações da AppBar.
          // Escuta alterações no carrinho.
          // Sempre que notifyListeners() for chamado no CarrinhoController, este widget será reconstruído automaticamente.
          ListenableBuilder(
            listenable: carrinho, // Objeto observado.
            builder: (context, _) {
              return Stack(
                // Stack permite sobrepor widgets.
                children: [
                  // BOTÃO DO CARRINHO
                  IconButton(
                    icon: const Icon(Icons.shopping_cart_outlined),
                    onPressed: () =>
                        context.push('/carrinho'), // Abre a página do carrinho.
                  ),

                  // BADGE DE QUANTIDADE
                  if (carrinho.totalItens >
                      0) // Só aparece se existir pelo menos um item.
                    Positioned(
                      right: 6,
                      top: 6,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          color: Colors.orange,
                          shape: BoxShape.circle, // Aparência do círculo.
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
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(produto.emoji, style: const TextStyle(fontSize: 100)),
            ),

            const SizedBox(height: 24),

            // NOME DO PRODUTO
            Text(
              produto.nome,
              style:
                  Theme.of(context) // Utiliza o estilo padrão do tema
                      .textTheme
                      .headlineMedium
                      ?.copyWith(
                        fontWeight: FontWeight.bold, // adicione o negrito
                      ),
            ),

            // NOME CIENTÍFICO
            Text(
              produto.nomeCientifico,
              style: const TextStyle(
                fontStyle: FontStyle.italic,
                color: Colors.grey,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 8),

            // PREÇO
            Text(
              'R\$ ${produto.preco.toStringAsFixed(2)}',
              style: const TextStyle(
                fontSize: 24,
                color: Color(0xFF4A7C59),
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            // DESCRIÇÃO
            Text(produto.descricao, style: const TextStyle(fontSize: 15)),

            const Spacer(), // Spacer ocupa todo o espaço livre disponível e empurra os botões para o final da tela.
            // ÁREA DOS BOTÕES
            Column(
              children: [
                // BOTÃO ADICIONAR AO CARRINHO
                SizedBox(
                  width: double.infinity, // Faz o botão ocupar toda a largura.
                  child: ElevatedButton.icon(
                    onPressed: () {
                      carrinho.adicionar(
                        produto,
                      ); // Adiciona o produto ao carrinho.
                      ScaffoldMessenger.of(
                            context,
                          ) // Exibe uma mensagem temporária confirmando a ação.
                          .showSnackBar(
                            SnackBar(
                              content: Text(
                                '${produto.nome} adicionado ao carrinho!',
                              ),
                              duration: const Duration(
                                seconds: 1,
                              ), // Tempo de exibição.
                            ),
                          );
                    },

                    // Configurações botão
                    icon: const Icon(Icons.add_shopping_cart),
                    label: const Text('Adicionar ao Carrinho'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4A7C59),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // BOTÃO VER CARRINHO
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () =>
                        context.push('/carrinho'), // Navega para o carrinho.
                    icon: const Icon(Icons.shopping_cart),
                    label: const Text('Ver Carrinho'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF4A7C59),
                      side: const BorderSide(color: Color(0xFF4A7C59)),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
