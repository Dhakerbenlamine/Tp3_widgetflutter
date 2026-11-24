import 'package:flutter/foundation.dart';
import '../models/destination.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
/// Favoris partagés par tous les écrans.
class FavorisModel extends ChangeNotifier {
  static const _cle = 'favoris';
  // favoris rangés par id : Map<String, Destination>
   final Map<String, Destination> _favoris = {};
    // TODO estFavori(Destination d) -> bool
    bool estFavori(Destination d) => _favoris.containsKey(d.id);
  // TODO getter liste : les destinations favorites
  List<Destination> get liste => _favoris.values.toList();
  // TODO getter nombre
  int get nombre => _favoris.length;
  // TODO basculer(Destination d) : ajoute ou retire,
  
  
  Future<void> charger() async {
  final prefs = await SharedPreferences.getInstance();

  // TODO 1 : liste de textes, vide si rien n'est stocké
  final textes = prefs.getStringList(_cle) ?? [];

  // TODO 2 : jsonDecode puis Destination.fromJson, rangé avec son id
  _favoris.clear();
  for (final texte in textes) {
    final d = Destination.fromJson(jsonDecode(texte));
    _favoris[d.id] = d;
  }
  notifyListeners();
}

  Future<void> _sauvegarder() async {
  final prefs = await SharedPreferences.getInstance();

  // TODO 3 : toJson puis jsonEncode, écrit avec setStringList
  final textes = _favoris.values
      .map((d) => jsonEncode(d.toJson()))
      .toList();
  await prefs.setStringList(_cle, textes);
}
  
  
  
  
  
  
  
  bool basculer(Destination d) {
  final ajoute = _favoris.remove(d.id) == null;
  if (ajoute) _favoris[d.id] = d;
    _sauvegarder(); // TP7 : recopie sur le disque
    notifyListeners();
  return ajoute;
}
  //      prévient les écouteurs, renvoie true si ajouté
}