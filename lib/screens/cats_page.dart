import 'package:flutter/material.dart';

class CatsPage extends StatefulWidget {
  const CatsPage({super.key});

  @override
  State<CatsPage> createState() => _CatsPageState();
}

class _CatsPageState extends State<CatsPage> {
  final _controller = TextEditingController();
  int _refresh = DateTime.now().millisecondsSinceEpoch;

  // Construye la URL dinámica según el texto del TextField
  String get _catUrl {
    final text = _controller.text.trim();
    // El timestamp (t) evita que Flutter reutilice la imagen en caché
    // y así cada vez sale un gato nuevo.
    final base = text.isEmpty
        ? 'https://cataas.com/cat'
        : 'https://cataas.com/cat/says/${Uri.encodeComponent(text)}';
    final sep = text.isEmpty ? '?' : '?fontSize=40&fontColor=white&';
    return '$base${sep}t=$_refresh';
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          TextField(
            controller: _controller,
            decoration: const InputDecoration(
              labelText: 'Escribe tu frase',
              border: OutlineInputBorder(),
              prefixIcon: Icon(Icons.edit),
            ),
            onSubmitted: (_) => setState(() {}),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: () => setState(() {}),
                  icon: const Icon(Icons.check),
                  label: const Text('Poner texto'),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => setState(() =>
                      _refresh = DateTime.now().millisecondsSinceEpoch),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Otro gato'),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                _catUrl,
                key: ValueKey(_catUrl),
                fit: BoxFit.contain,
                width: double.infinity,
                loadingBuilder: (context, child, progress) {
                  if (progress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
                errorBuilder: (_, __, ___) =>
                    const Center(child: Text('No se pudo cargar el gato 😿')),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
