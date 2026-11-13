import 'package:flutter/material.dart';

import '../services/crypto_service.dart';

class CryptoPage extends StatefulWidget {
  const CryptoPage({super.key});

  @override
  State<CryptoPage> createState() => _CryptoPageState();
}

class _CryptoPageState extends State<CryptoPage> {
  final _controller = TextEditingController();
  late Future<Map<String, double>> _future;

  @override
  void initState() {
    super.initState();
    _future = fetchPrices();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // tryParse para que no truene si el campo está vacío o dice otra cosa
    final usd = double.tryParse(_controller.text.replaceAll(',', '.')) ?? 0;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _controller,
            keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
            decoration: const InputDecoration(
              labelText: 'Monto en USD',
              prefixIcon: Icon(Icons.attach_money),
              border: OutlineInputBorder(),
            ),
            onChanged: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: FutureBuilder<Map<String, double>>(
              future: _future,
              builder: (context, snap) {
                if (snap.connectionState != ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snap.hasError) {
                  return Center(
                    child: Text(
                        'No se pudieron traer los precios.\n${snap.error}',
                        textAlign: TextAlign.center),
                  );
                }
                final prices = snap.data!;
                return ListView(
                  children: coins.entries.map((e) {
                    final price = prices[e.key] ?? 0;
                    final amount = price > 0 ? usd / price : 0;
                    return Card(
                      child: ListTile(
                        title: Text(e.value),
                        subtitle: Text('Precio: \$${price.toStringAsFixed(2)}'),
                        trailing: Text(
                          amount.toStringAsFixed(6),
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
          OutlinedButton.icon(
            onPressed: () => setState(() => _future = fetchPrices()),
            icon: const Icon(Icons.refresh),
            label: const Text('Actualizar precios'),
          ),
        ],
      ),
    );
  }
}
