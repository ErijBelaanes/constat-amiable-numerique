import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;  //Bibliothèque Flutter pour effectuer des requêtes réseau
import 'package:http_parser/http_parser.dart';
import '../models/constat_model.dart';
import '../utils/generateurPDF.dart';

class ApiService {
  static const String baseUrl = "https://constat-backend.onrender.com/api";  //Adresse du serveur

  static Future<String> envoyerConstat(ConstatModel constat) async {
    final response = await http.post(
      Uri.parse('$baseUrl/constats'),
      headers: {"Content-Type": "application/json",},
      body: jsonEncode(constat.toJson()),
    );
    if(response.statusCode == 201){
      final data = jsonDecode(response.body);
      print("Constat enregistré dans MongoDB avec id: ${data['_id']}");
      return data['_id'];
    } else {
      print(response.body);
      throw Exception("Erreur lors de l'envoi du constat");
    }
  }

  static Future<void> envoyerPdf(String constatId, Uint8List pdfBytes) async{
    print("Taille du PDF à envoyer: ${(pdfBytes.length / 1024 / 1024).toStringAsFixed(2)} Mo");
    final uri = Uri.parse('$baseUrl/constats/$constatId/pdf');
    final request = http.MultipartRequest("POST", uri);

    request.files.add(
      http.MultipartFile.fromBytes(
        "pdf",
        pdfBytes,
        filename: "constat-${constatId}.pdf",
        contentType: MediaType("application", "pdf"),
      ),
    );
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    print("Statut upload PDF: ${response.statusCode}");
    print("Réponse: ${response.body}");
    if (response.statusCode == 201) {
      print("PDF envoyé avec succès");
    } else {
      print(response.body);
      throw Exception("Erreur lors de l'envoi du PDF");
    }
  }

  static Future<Uint8List> finaliserConstat(
      ConstatModel constat, {
        required bool enFrancais,
      }) async {
        // 1. Sauvegarder le constat en base, récupérer l'id
        final constatId = await envoyerConstat(constat);
        // 2. Générer le PDF avec ton générateur existant
        final Uint8List pdfBytes = await GenerateurPDF.genererConstatSurModele(
          constat,
          constat.vehiculeA,
          constat.vehiculeB,
          enFrancais,
        );
        // 3. Uploader le PDF généré
        await envoyerPdf(constatId, pdfBytes);
        return pdfBytes;
  }
}