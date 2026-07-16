import 'package:flutter/material.dart';
import '../theme/couleurs.dart';

class CaseCirconstance extends StatelessWidget{
  final bool cochee;
  final ValueChanged<bool> click;  //Reçoit oui ou non
  final bool enFrancais;

  const CaseCirconstance({
    super.key,
    required this.cochee,
    required this.click,
    required this.enFrancais,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        //Oui en 1ere position
        GestureDetector(
          onTap: () => click(true),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: cochee
                  ? CouleursApp.bordure2  //actif
                  : CouleursApp.champ,  //inactif
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                color: CouleursApp.bordure1,
                width: 1.5,
              ),
            ),
            child: Text(
              enFrancais ? 'O' : 'نعم',
              style: TextStyle(
                color: CouleursApp.texte,
                fontWeight: FontWeight.bold,
                fontFamily: enFrancais ? 'PlayfairDisplay' : 'NoteNaskhArabic',
                fontSize: 13,
              ),
            ),
          ),
        ),

        const SizedBox(width: 5),

        //Non en 2ème position
        GestureDetector(
          onTap: () => click(false),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: !cochee
                  ? CouleursApp.bordure2  //actif
                  : CouleursApp.champ,  //inactif
              border: Border.all(
                color: CouleursApp.bordure1,
                width: 1.5,
              ),
            ),
            child: Text(
              enFrancais ? 'N' : 'لا',
              style: TextStyle(
                color: CouleursApp.texte,
                fontWeight: FontWeight.bold,
                fontFamily: enFrancais ? 'PlayfairDisplay' : 'NoteNaskhArabic',
                fontSize: 13,
              ),
            ),
          ),
        ),
      ],
    );
  }
}