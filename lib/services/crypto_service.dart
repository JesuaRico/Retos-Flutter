import 'dart:convert';

import 'package:http/http.dart' as http;

const coins = {
  'bitcoin': 'Bitcoin (BTC)',
  'ethereum': 'Ethereum (ETH)',
  'solana': 'Solana (SOL)',
};

Future<Map<String, double>> fetchPrices() async {
  final res = await http.get(Uri.parse(
      'https://api.coingecko.com/api/v3/simple/price'
      '?ids=${coins.keys.join(',')}&vs_currencies=usd'));
  if (res.statusCode != 200) throw Exception('Error ${res.statusCode}');
  final data = jsonDecode(res.body) as Map<String, dynamic>;
  return data.map((id, v) => MapEntry(id, (v['usd'] as num).toDouble()));
}
