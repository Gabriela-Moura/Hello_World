import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hello_world/main.dart';

// PÁGINA DO CARRINHO
class CarrinhoPage extends StatelessWidget {
  // Tela responsável por exibir todos os produtos adicionados ao carrinho.
  const CarrinhoPage({super.key}); // Construtor da página.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Scaffold cria a estrutura principal da tela.

      // APP BAR
      appBar: AppBar(
        title: const Text('Meu Carrinho'),
        backgroundColor: const Color(0xFF4A7C59),
        foregroundColor: Colors.white,
        leading: IconButton(
          // Botão exibido à esquerda.
          icon: const Icon(Icons.arrow_back), // Ícone da seta de voltar.
          onPressed: () => context.pop(), // Retorna para a tela anterior.
        ),
      ),

      body: ListenableBuilder(
        // Objeto observado.
        // Sempre que notifyListeners() for chamado dentro do CarrinhoController, esta parte da interface será reconstruída.
        listenable: carrinho,
        builder: (context, _) {
          // CARRINHO VAZIO
          if (carrinho.itens.isEmpty) {
            // Verifica se não existem itens.
            return Center(
              child: Column(
                // Centraliza os elementos.
                mainAxisAlignment:
                    MainAxisAlignment.center, // Centraliza verticalmente.
                children: [
                  const Text('🛒', style: TextStyle(fontSize: 64)),
                  const SizedBox(height: 16),
                  const Text(
                    'Seu carrinho está vazio',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),

                  const SizedBox(height: 24),

                  // BOTÃO VOLTAR À LOJA
                  ElevatedButton.icon(
                    onPressed: () =>
                        context.go('/'), // Ao clicar,retorna para a HomePage
                    icon: const Icon(Icons.storefront),
                    label: const Text('Voltar à Loja'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4A7C59),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          // CARRINHO COM PRODUTOS
          // Se houver itens no carrinho, este bloco será executado.
          return Column(
            children: [
              Expanded(
                // Expanded faz a lista ocupar todo o espaço disponível.
                child: ListView.builder(
                  // Lista de produtos do carrinho.
                  padding: const EdgeInsets.all(16),
                  itemCount: carrinho.itens.length, // Quantidade de itens.
                  itemBuilder: (context, index) {
                    // Constrói cada produto.
                    final item = carrinho.itens[index]; // Obtém o item atual.
                    final subtotal = item.produto.preco * item.quantidade;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          // Linha principal do item.
                          children: [
                            Text(
                              item.produto.emoji,
                              style: const TextStyle(fontSize: 40),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // NOME DO PRODUTO
                                  Text(
                                    item.produto.nome,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),

                                  // NOME CIENTÍFICO
                                  Text(
                                    item.produto.nomeCientifico,
                                    style: const TextStyle(
                                      fontStyle: FontStyle.italic,
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  ),

                                  // Espaçamento vertical.
                                  const SizedBox(height: 4),

                                  // SUBTOTAL
                                  Text(
                                    'R\$ ${item.produto.preco.toStringAsFixed(2)} × ${item.quantidade} = R\$ ${subtotal.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      color: Color(0xFF4A7C59),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // CONTROLE DE QUANTIDADE
                            Column(
                              children: [
                                // BOTÃO ADICIONAR
                                IconButton(
                                  icon: const Icon(
                                    Icons.add,
                                    color: Color(0xFF4A7C59),
                                  ),
                                  onPressed: () => carrinho.adicionar(
                                    item.produto,
                                  ), // Adiciona mais uma unidade do produto ao carrinho.
                                ),

                                // QUANTIDADE
                                Text(
                                  '${item.quantidade}',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                // BOTÃO REMOVER
                                IconButton(
                                  icon: const Icon(
                                    Icons.remove,
                                    color: Color(0xFF4A7C59),
                                  ),
                                  onPressed: () =>
                                      carrinho.remover(item.produto),
                                ), // Remove uma unidade.
                                // BOTÃO EXCLUIR
                                IconButton(
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.red,
                                  ),
                                  onPressed: () => carrinho.removerItemCompleto(
                                    item.produto,
                                  ), // Remove completamente o produto do carrinho.
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // RODAPÉ DO CARRINHO
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 8, // Intensidade do desfoque.
                      offset: const Offset(0, -2), // Deslocamento da sombra.
                    ),
                  ],
                ),

                child: Column(
                  children: [
                    // LINHA DE INFORMAÇÕES
                    Row(
                      mainAxisAlignment: MainAxisAlignment
                          .spaceBetween, // Distribui os elementos um em cada extremidade.
                      children: [
                        Text(
                          '${carrinho.totalItens} ${carrinho.totalItens == 1 ? 'item' : 'itens'}', // Quantidade total de itens.
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),

                        Text(
                          'Total: R\$ ${carrinho.total.toStringAsFixed(2)}', // Valor total da compra.
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF4A7C59),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    // LINHA DOS BOTÕES
                    Row(
                      children: [
                        // BOTÃO LIMPAR
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () {
                              carrinho.limpar(); // Remove todos os itens.
                              ScaffoldMessenger.of(
                                    context,
                                  ) // Exibe mensagem temporária.
                                  .showSnackBar(
                                    const SnackBar(
                                      content: Text('Carrinho limpo!'),
                                      backgroundColor: Colors.orange,
                                      duration: Duration(seconds: 1),
                                    ),
                                  );
                            },

                            icon: const Icon(Icons.delete_sweep),
                            label: const Text('Limpar'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              side: const BorderSide(color: Colors.red),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        // BOTÃO INÍCIO
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => context.go('/'),
                            icon: const Icon(Icons.home),
                            label: const Text('Início'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFF4A7C59),
                              side: const BorderSide(color: Color(0xFF4A7C59)),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        // BOTÃO FINALIZAR
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              carrinho.limpar();
                              context.go('/');
                              ScaffoldMessenger.of(
                                    context,
                                  ) // Exibe confirmação.
                                  .showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        '✅ Pedido finalizado! Obrigado pela compra!',
                                      ),
                                      backgroundColor: Color(0xFF4A7C59),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                            },

                            icon: const Icon(Icons.check_circle_outline),
                            label: const Text('Finalizar'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4A7C59),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
