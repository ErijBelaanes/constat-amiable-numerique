import 'package:flutter/material.dart';
import '../theme/couleurs.dart';

class QuestionOuiNon extends StatelessWidget{
  final String label;
  final bool valeur;
  final ValueChanged<bool> change;   //Reçoit oui ou non
  final bool enFrancais;

  const QuestionOuiNon({
    super.key,
    required this.label,
    required this.valeur,
    required this.change,
    required this.enFrancais,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: Text(
              label,
              textAlign: enFrancais ? TextAlign.left : TextAlign.right,
              textDirection: enFrancais ? TextDirection.ltr : TextDirection.rtl,
              style: TextStyle(
                color: CouleursApp.texte,
                fontFamily: enFrancais ? 'PlayfairDisplay' : 'NoteNaskhArabic',
                fontSize: 16.5,
                fontWeight: FontWeight.bold,
              ),
            ),
        ),
        const SizedBox(width: 5),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [

            //Oui en 1ere position
            GestureDetector(
              onTap: () => change(true),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: valeur
                      ? CouleursApp.bordure2  //actif
                      : CouleursApp.champ,  //inactif
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(
                    color: CouleursApp.bordure1,
                    width: 1.5,
                  ),
              ),
              child: Text(
                enFrancais ? 'Oui' : 'نعم',
                style: TextStyle(
                  color: CouleursApp.texte,
                  fontWeight: FontWeight.bold,
                  fontFamily: enFrancais ? 'PlayfairDisplay' : 'NoteNaskhArabic',
                  fontSize: 15,
                ),
              ),
              ),
            ),

            const SizedBox(width: 8),

            //Non en 2ème position
            GestureDetector(
              onTap: () => change(false),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: !valeur
                      ? CouleursApp.bordure2  //actif
                      : CouleursApp.champ,  //inactif
                  border: Border.all(
                    color: CouleursApp.bordure1,
                    width: 1.5,
                  ),
                ),
                child: Text(
                  enFrancais ? 'Non' : 'لا',
                  style: TextStyle(
                    color: CouleursApp.texte,
                    fontWeight: FontWeight.bold,
                    fontFamily: enFrancais ? 'PlayfairDisplay' : 'NoteNaskhArabic',
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}