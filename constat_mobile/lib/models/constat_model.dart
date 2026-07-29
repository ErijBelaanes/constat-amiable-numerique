import 'dart:typed_data';
import 'package:flutter/material.dart';

class Temoin{
  String nom;
  String prenom;
  String adresse;
  String numTel;

  Temoin({
    required this.nom,
    required this.prenom,
    required this.adresse,
    required this.numTel,
  });

  Map<String, dynamic> toJson(){
    return {
      'nom': nom,
      'prenom': prenom,
      'adresse': adresse,
      'numTel': numTel,
    };
  }

  factory Temoin.fromJson(Map<String, dynamic> json){
    return Temoin(
      nom: json['nom'] ?? '',
      prenom: json['prenom'] ?? '',
      adresse: json['adresse'] ?? '',
      numTel: json['numTel'] ?? '',
    );
  }
}

class ConstatModel {
  DateTime? dateAccident;
  String lieuAccident;
  bool degatsMat = false;
  bool blesses = false;
  bool temoins = false;
  List<Temoin> listeTemoins = [];  //La liste des témoins ajoutés
  VehiculeInfo vehiculeA = VehiculeInfo();
  VehiculeInfo vehiculeB = VehiculeInfo();
  List<bool> circonstancesA = List.filled(17, false);
  List<bool> circonstancesB = List.filled(17, false);
  Uint8List? croquis;  //L'image finale du croquis
  List<List<Offset>> traitsCroquis = [];  //Les traits du croquis
  Uint8List? signatureA;
  Uint8List? signatureB;

  List<Uint8List> photosScene = [];
  List<Uint8List> photosDegatsApparents = [];

  ConstatModel({required this.lieuAccident}){
    dateAccident = DateTime.now();
  }

  Map<String, dynamic> toJson(){
    return {
      'dateAccident': dateAccident?.toIso8601String(),
      'lieuAccident': lieuAccident,
      'degatsMateriels': degatsMat,
      'blesses': blesses,
      'temoins': temoins,
      'listeTemoins': listeTemoins.map((t) => t.toJson()).toList(),
      'vehiculeA': vehiculeA.toJson(),
      'vehiculeB': vehiculeB.toJson(),
      'circonstancesA': circonstancesA,
      'circonstancesB': circonstancesB,
    };
  }

  /// Reconstruit un ConstatModel à partir des données reçues (ex: après scan QR).
  factory ConstatModel.fromJson(Map<String, dynamic> json){
    final constat = ConstatModel(lieuAccident: json['lieuAccident'] ?? '');

    constat.dateAccident = json['dateAccident'] != null
        ? DateTime.parse(json['dateAccident'])
        : null;
    constat.degatsMat = json['degatsMat'] ?? false;
    constat.blesses = json['blesses'] ?? false;
    constat.temoins = json['temoins'] ?? false;
    constat.listeTemoins = (json['listeTemoins'] as List<dynamic>? ?? [])
        .map((t) => Temoin.fromJson(t as Map<String, dynamic>))
        .toList();
    constat.vehiculeA = VehiculeInfo.fromJson(json['vehiculeA'] ?? {});
    constat.vehiculeB = VehiculeInfo.fromJson(json['vehiculeB'] ?? {});
    constat.circonstancesA = (json['circonstancesA'] as List<dynamic>? ?? List.filled(17, false))
        .map((v) => v as bool)
        .toList();
    constat.circonstancesB = (json['circonstancesB'] as List<dynamic>? ?? List.filled(17, false))
        .map((v) => v as bool)
        .toList();

    return constat;
  }
}

class VehiculeInfo{
  //Societe d'assurances
  String assurance;
  String numContrat;
  String agence;
  DateTime? dateDebutAttestation;
  DateTime? dateFinAttestation;

  //Identite du conducteur
  String nomConducteur;
  String prenomConducteur;
  String adresseConducteur;
  String numPermis;
  DateTime? datePermis;

  //Assure
  String nomAssure;
  String prenomAssure;
  String adresseAssure;
  String numTel;

  //Identite du vehicule
  String marque;
  String type;
  String numImmatriculation;
  String sensSuivi;
  String venantDe;
  String allantA;

  //Point de choc
  Offset? pointChoc;
  Uint8List? imagePointChoc;

  //Degat apparents
  String degatsApparents;
  List<Uint8List> photosDegatsApparents;
  //Observations
  String observations;

  VehiculeInfo({
    this.assurance = '',
    this.numContrat = '',
    this.agence = '',
    this.dateDebutAttestation,
    this.dateFinAttestation,

    this.nomConducteur = '',
    this.prenomConducteur = '',
    this.adresseConducteur = '',
    this.numPermis = '',
    this.datePermis,

    this.nomAssure = '',
    this.prenomAssure = '',
    this.adresseAssure = '',
    this.numTel = '',

    this.marque = '',
    this.type = '',
    this.numImmatriculation = '',
    this.sensSuivi = '',
    this.venantDe = '',
    this.allantA = '',

    this.pointChoc,
    this.imagePointChoc,

    this.degatsApparents = '',
    List<Uint8List>? photosDegatsApparents,
    this.observations = '',  //Paramètre optionnel
  }): photosDegatsApparents = photosDegatsApparents ?? [];  //Initialisation par défaut

  Map<String, dynamic> toJson(){
    return {
      'assurance': assurance,
      'numContrat': numContrat,
      'agence': agence,
      'dateDebutAttestation': dateDebutAttestation?.toIso8601String(),
      'dateFinAttestation': dateFinAttestation?.toIso8601String(),

      'nomConducteur': nomConducteur,
      'prenomConducteur': prenomConducteur,
      'adresseConducteur': adresseConducteur,
      'numPermis': numPermis,
      'datePermis': datePermis?.toIso8601String(),

      'nomAssure': nomAssure,
      'prenomAssure': prenomAssure,
      'adresseAssure': adresseAssure,
      'numTel': numTel,

      'marque': marque,
      'type': type,
      'numImmatriculation': numImmatriculation,
      'sensSuivi': sensSuivi,
      'venantDe': venantDe,
      'allantA': allantA,

      'degatsApparents': degatsApparents,
      'observations': observations,
    };
  }

  factory VehiculeInfo.fromJson(Map<String, dynamic> json){
    return VehiculeInfo(
      assurance: json['assurance'] ?? '',
      numContrat: json['numContrat'] ?? '',
      agence: json['agence'] ?? '',
      dateDebutAttestation: json['dateDebutAttestation'] != null
          ? DateTime.parse(json['dateDebutAttestation'])
          : null,
      dateFinAttestation: json['dateFinAttestation'] != null
          ? DateTime.parse(json['dateFinAttestation'])
          : null,

      nomConducteur: json['nomConducteur'] ?? '',
      prenomConducteur: json['prenomConducteur'] ?? '',
      adresseConducteur: json['adresseConducteur'] ?? '',
      numPermis: json['numPermis'] ?? '',
      datePermis: json['datePermis'] != null
          ? DateTime.parse(json['datePermis'])
          : null,

      nomAssure: json['nomAssure'] ?? '',
      prenomAssure: json['prenomAssure'] ?? '',
      adresseAssure: json['adresseAssure'] ?? '',
      numTel: json['numTel'] ?? '',

      marque: json['marque'] ?? '',
      type: json['type'] ?? '',
      numImmatriculation: json['numImmatriculation'] ?? '',
      sensSuivi: json['sensSuivi'] ?? '',
      venantDe: json['venantDe'] ?? '',
      allantA: json['allantA'] ?? '',

      degatsApparents: json['degatsApparents'] ?? '',
      observations: json['observations'] ?? '',
    );
  }
}

