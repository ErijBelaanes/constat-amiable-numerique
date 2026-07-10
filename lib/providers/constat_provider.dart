import 'package:flutter/foundation.dart';
import '../models/constat_model.dart';
class ConstatProvider extends ChangeNotifier {
  final ConstatModel constat = ConstatModel(lieuAccident: '');

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
    constat.temoins=temoins;
    notifyListeners();
  }
}