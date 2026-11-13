import 'package:flutter/material.dart';

import 'cats_page.dart';
import 'crypto_page.dart';
import 'movies_page.dart';
import 'weather_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _index = 0;

  final _pages = const [
    MoviesPage(),
    CatsPage(),
    WeatherPage(),
    CryptoPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack mantiene el estado de cada pestaña al cambiar
      body: SafeArea(child: IndexedStack(index: _index, children: _pages)),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.movie), label: 'Películas'),
          NavigationDestination(icon: Icon(Icons.pets), label: 'Gatos'),
          NavigationDestination(icon: Icon(Icons.wb_sunny), label: 'Clima'),
          NavigationDestination(
              icon: Icon(Icons.currency_bitcoin), label: 'Crypto'),
        ],
      ),
    );
  }
}
