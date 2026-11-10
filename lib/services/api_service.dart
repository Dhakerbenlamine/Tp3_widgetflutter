
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api_config.dart';
import '../models/destination.dart';

class ApiService {

  static Uri _url(String chemin) =>
      Uri.parse('${ApiConfig.baseUrl}$chemin');

  static Future<List<Destination>> getDestinations() async {

    final reponse = await http
        .get(_url('/destinations'))
        .timeout(ApiConfig.timeout);

    // TODO 4 : vérifier le code de réponse
    if (reponse.statusCode != 200) {
      throw Exception(
        'Erreur HTTP : ${reponse.statusCode}',
      );
    }

    // Décoder le JSON en conservant les accents
    final List<dynamic> liste =
        jsonDecode(utf8.decode(reponse.bodyBytes));

    // TODO 5 : transformer chaque élément en Destination
    return liste
        .map((element) => Destination.fromJson(element))
        .toList();
  }
}
