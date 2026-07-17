import 'package:flutter/material.dart';
import '../theme/couleurs.dart';

//Méthode pour afficher un message d'erreur temporaire sous forme de boîte de dialogue
void afficherErreur(BuildContext context, String message, bool enFrancais){
  showDialog(  //Popup
    context: context,
    barrierDismissible: true,
    barrierColor: Colors.black.withValues(alpha: 0.7),
    builder: (context) {
      Future.delayed(const Duration(seconds: 3), (){  //Fermeture automatique après 3 secondes
        if (Navigator.canPop(context)){
          Navigator.pop(context);
        }
      });
      return Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
          decoration: BoxDecoration(
              color: CouleursApp.alerte.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: CouleursApp.alerte,
                width: 1.5,
              )
          ),

          child: Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontFamily: enFrancais ? 'PlayfairDisplay' : 'NoteNaskhArabic',
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
    },
  );
}