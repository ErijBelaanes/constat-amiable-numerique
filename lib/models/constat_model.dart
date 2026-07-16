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
}

class ConstatModel {
  DateTime? dateAccident;
  String lieuAccident;
  bool degatsMat = false;
  bool blesses = false;
  bool temoins = false;
  List<Temoin> listeTemoins = [];  //La liste des témoins ajoutés
  List<bool> circonstancesA = List.filled(17, false);
  List<bool> circonstancesB = List.filled(17, false);


  ConstatModel({required this.lieuAccident}){
    dateAccident = DateTime.now();
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
  String sensSuivi;
  String venantDe;
  String allantA;

  //Point de choc
  Offset? pointChoc;
  Uint8List? imagePointChoc;

  //Degat apparents
  String degatsApparents;

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
    this.sensSuivi = '',
    this.venantDe = '',
    this.allantA = '',

    this.pointChoc,
    this.imagePointChoc,

    this.degatsApparents = '',

    this.observations = '',
  });
}

