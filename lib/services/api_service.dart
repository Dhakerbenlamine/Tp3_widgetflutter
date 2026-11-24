import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';
import '../models/destination.dart';
import '../models/reservation.dart';

class ApiService {
  static const String _cleCache = 'destinations_cache';
  static bool depuisCache = false;

  static List<Destination> _decoder(String corps) {
    final decoded = jsonDecode(corps) as List<dynamic>;
    return decoded
        .map((e) => Destination.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  static Uri _url(String chemin) =>
      Uri.parse('${ApiConfig.baseUrl}$chemin');

  // Récupérer les destinations depuis le serveur (GET)
  static Future<List<Destination>> getDestinations() async {
    final prefs = await SharedPreferences.getInstance();
    try {
      final reponse =
          await http.get(_url('/destinations')).timeout(ApiConfig.timeout);
      if (reponse.statusCode != 200) {
        throw Exception('Erreur ${reponse.statusCode}');
      }
      final corps = utf8.decode(reponse.bodyBytes);
      await prefs.setString(_cleCache, corps);
      depuisCache = false;
      return _decoder(corps);
    } catch (e) {
      final cache = prefs.getString(_cleCache);
      if (cache == null) rethrow;
      depuisCache = true;
      return _decoder(cache);
    }
  }

  // Envoyer une réservation au serveur (POST)
  static Future<String> creerReservation(Reservation reservation) async {
    final reponse = await http
        .post(
          _url('/reservations'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(reservation.toJson()),
        )
        .timeout(ApiConfig.timeout);

    if (reponse.statusCode != 201) {
      throw Exception('Erreur HTTP : ${reponse.statusCode}');
    }

    final Map<String, dynamic> creee =
        jsonDecode(utf8.decode(reponse.bodyBytes));

    return creee['id'].toString();
  }
}