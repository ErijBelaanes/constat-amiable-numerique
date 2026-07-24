import 'dart:convert';
import 'package:flutter/services.dart';

class Localisation {

  static Map<String, dynamic> _fr = {};
  static Map<String, dynamic> _ar = {};

  static Future<void> charger() async {
    final fr = await rootBundle.loadString(
      'assets/translations/fr.json',
    );
    final ar = await rootBundle.loadString(
      'assets/translations/ar.json',
    );

    _fr = json.decode(fr);
    _ar = json.decode(ar);
  }

  static String get(
      String cle,
      bool enFrancais,
      ) {
    final fichier = enFrancais ? _fr : _ar;
    return fichier[cle] ?? cle;
  }
}