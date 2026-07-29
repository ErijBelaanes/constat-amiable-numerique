import 'dart:convert';
import 'package:http/http.dart' as http;  //Bibliothèque Flutter pour effectuer des requêtes réseau
import '../models/constat_model.dart';

class ApiService {
  static const String baseUrl = "http://10.0.2.2:3000/api/constats";  //Adresse du serveur

  static Future<void> envoyerConstat(
      ConstatModel constat) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(
        constat.toJson(),
      ),
    );
    if(response.statusCode == 201){
      print("Constat enregistré dans MongoDB");
    } else {
      print(response.body);
      throw Exception(
          "Erreur lors de l'envoi du constat"
      );
    }
  }
}