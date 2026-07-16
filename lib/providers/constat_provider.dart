import 'package:flutter/foundation.dart';
import '../models/constat_model.dart';

class ConstatProvider extends ChangeNotifier {
  final ConstatModel constat = ConstatModel(lieuAccident: '');
  VehiculeInfo vehiculeA = VehiculeInfo();
  VehiculeInfo vehiculeB = VehiculeInfo();
  bool enFrancais = true;

  void changerLangue(){
    enFrancais = !enFrancais;
    notifyListeners();
  }

  void setDateAccident(DateTime date) {
    constat.dateAccident = date;
    notifyListeners();
  }

  void setLieuAccident(String lieu){
    constat.lieuAccident = lieu;
    notifyListeners();
  }

  void setDegatsMat(bool degats){
    constat.degatsMat = degats;
    notifyListeners();
  }

  void setBlesses(bool value) {
    constat.blesses = value;
    notifyListeners();
  }

  void setTemoins(bool temoins){
    constat.temoins = temoins;
    notifyListeners();
  }

  void ajouterTemoin(){
    constat.listeTemoins.add(
        Temoin(
          nom: '',
          prenom: '',
          adresse: '',
          numTel: '',
        ));
    notifyListeners();
  }

  void supprimerTemoin(int index){
    constat.listeTemoins.removeAt(index);

    //S'il n'y a plus de témoins, on décoche automatiquement la question.
    if(constat.listeTemoins.isEmpty) {
      constat.temoins = false;
    }

    notifyListeners();
  }

  void setNomTemoin(int index, String nom){
    constat.listeTemoins[index].nom = nom;
    notifyListeners();
  }

  void setPrenomTemoin(int index, String prenom){
    constat.listeTemoins[index].prenom = prenom;
    notifyListeners();
  }

  void setAdresseTemoin(int index, String adresse){
    constat.listeTemoins[index].adresse = adresse;
    notifyListeners();
  }

  void setNumTelTemoin(int index, String numTel){
    constat.listeTemoins[index].numTel = numTel;
    notifyListeners();
  }

  void setVehiculeA(VehiculeInfo vehicule){
    vehiculeA = vehicule;
    notifyListeners();
  }

  void setVehiculeB(VehiculeInfo vehicule){
    vehiculeB = vehicule;
    notifyListeners();
  }
}