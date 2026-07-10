class VehiculeInfo{
  //Societe d'assurances
  String assureur;
  String numContrat;
  String agence;
  DateTime dateDebutAttestation;
  DateTime dateFinAttestation;

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

  //Degat apparents
  String degatsApparents;

  //Observations
  String observations;

  VehiculeInfo({
    required this.assureur,
    required this.numContrat,
    required this.agence,
    required this.dateDebutAttestation,
    required this.dateFinAttestation,

    required this.nomConducteur,
    required this.prenomConducteur,
    required this.adresseConducteur,
    required this.numPermis,
    required this.datePermis,

    required this.nomAssure,
    required this.prenomAssure,
    required this.adresseAssure,
    required this.numTel,

    required this.marque,
    required this.type,
    required this.sensSuivi,
    required this.venantDe,
    required this.allantA,

    required this.degatsApparents,

    required this.observations,
  });
}

class ConstatModel {
  DateTime? dateAccident;
  String lieuAccident;
  bool degatsMat = false;
  bool blesses = false;
  bool temoins = false;

  ConstatModel({required this.lieuAccident}){
    dateAccident = DateTime.now();
  }
}