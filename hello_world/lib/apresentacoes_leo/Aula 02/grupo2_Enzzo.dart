import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home: TelaValidacao()));
}

// ==================== FUNÇÃO COM VALIDAÇÃO E THROW EXCEPTION ====================

double calcularDesconto(double valorOriginal, double porcentagem) {
  // Validação usando operador lógico OR (||)
  // Verifica se porcentagem < 0 OU porcentagem > 100
  if (porcentagem < 0 || porcentagem > 100) {
    throw Exception(
      'Porcentagem deve estar entre 0 e 100. '
      'Valor recebido: $porcentagem',
    );
  }

  // Validação do valor original
  if (valorOriginal < 0) {
    throw Exception(
      'Valor original não pode ser negativo. '
      'Valor recebido: $valorOriginal',
    );
  }

  // Cálculo do desconto
  double desconto = valorOriginal * (porcentagem / 100);
  double valorFinal = valorOriginal - desconto;

  return valorFinal;
}

// ==================== WIDGET PARA DEMONSTRAÇÃO ====================

class TelaValidacao extends StatefulWidget {
  const TelaValidacao({super.key});

  @override
  State<TelaValidacao> createState() => _TelaValidacaoState();
}

class _TelaValidacaoState extends State<TelaValidacao> {
  String resultado = 'Digite os valores e clique em Calcular';
  final controladorValor = TextEditingController();
  final controladorPorcentagem = TextEditingController();

  // ==================== EXEMPLO DE TRY-CATCH ====================

  void executarCalculo() {
    try {
      double valor = double.parse(controladorValor.text);
      double porcentagem = double.parse(controladorPorcentagem.text);

      double resultado = calcularDesconto(valor, porcentagem);

      setState(() {
        this.resultado =
            "Valor com desconto: R\$ ${resultado.toStringAsFixed(2)}";
      });
    } on Exception catch (e) {
      setState(() {
        resultado = e.toString();
      });
    }
  }

  // ==================== ESTRUTURA DA INTERFACE ====================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Validação de Dados e Exceções')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Campo de entrada: Valor Original
            TextField(
              controller: controladorValor,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Valor Original (R\$)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                hintText: 'Ex: 100.00',
              ),
            ),
            const SizedBox(height: 20),

            // Campo de entrada: Porcentagem
            TextField(
              controller: controladorPorcentagem,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Porcentagem de Desconto (%)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                hintText: 'Ex: 10 (válido: 0-100)',
              ),
            ),
            const SizedBox(height: 30),

            // Botão para executar cálculo (dispara try-catch)
            ElevatedButton(
              onPressed: executarCalculo,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 40,
                  vertical: 15,
                ),
              ),
              child: const Text(
                'Calcular Desconto',
                style: TextStyle(fontSize: 16),
              ),
            ),
            const SizedBox(height: 40),

            // Exibição do resultado
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                resultado,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    controladorValor.dispose();
    controladorPorcentagem.dispose();
    super.dispose();
  }
}
