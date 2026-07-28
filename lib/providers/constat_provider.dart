import 'dart:ui';

import 'package:flutter/foundation.dart';
import '../models/constat_model.dart';

class ConstatProvider extends ChangeNotifier {
  ConstatModel constat = ConstatModel(lieuAccident: '');
  bool enFrancais = true;

  void changerLangue(){
    enFrancais = !enFrancais;
    notifyListeners();
  }

  void reinitialiserConstat() {
    constat = ConstatModel(lieuAccident: '');
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
        Temoin(nom: '', prenom: '', adresse: '', numTel: '',),
    );
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
    constat.vehiculeA = vehicule;
    notifyListeners();
  }

  void setVehiculeB(VehiculeInfo vehicule){
    constat.vehiculeB = vehicule;
    notifyListeners();
  }

  void toggleCirconstanceA(int index, bool value){
    constat.circonstancesA[index] = value;
    notifyListeners();
  }

  void toggleCirconstanceB(int index, bool value){
    constat.circonstancesB[index] = value;
    notifyListeners();
  }

  void setCroquis(Uint8List imageCroquis){
    constat.croquis = imageCroquis;
    notifyListeners();
  }

  void setTraitsCroquis(List<List<Offset>> traits){
    constat.traitsCroquis = traits;
    notifyListeners();
  }

  void setSignatureA(Uint8List imageA){
    constat.signatureA = imageA;
    notifyListeners();
  }

  void setSignatureB(Uint8List imageB){
    constat.signatureB = imageB;
    notifyListeners();
  }

  void setPhotosScene(List<Uint8List> photos){
    constat.photosScene = photos;
    notifyListeners();
  }

  void setPhotosDegatsVehiculeA(List<Uint8List> photos) {
    constat.vehiculeA.photosDegatsApparents = photos;
    notifyListeners();
  }

  void setPhotosDegatsVehiculeB(List<Uint8List> photos) {
    constat.vehiculeB.photosDegatsApparents = photos;
    notifyListeners();
  }

}