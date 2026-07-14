import 'package:flutter/material.dart';
import '../theme/couleurs.dart';

class QuestionOuiNon extends StatelessWidget{
  final String label;
  final bool valeur;
  final ValueChanged<bool> change;
  final bool estFrancais;

  const QuestionOuiNon({
    super.key,
    required this.label,
    required this.valeur,
    required this.change,
    required this.estFrancais,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: Text(
              label,
              textAlign: estFrancais ? TextAlign.left : TextAlign.right,
              textDirection: estFrancais ? TextDirection.ltr : TextDirection.rtl,
              style: TextStyle(
                color: Colors.black,
                fontFamily: estFrancais ? 'PlayfairDisplay' : 'NoteNaskhArabic',
                fontSize: 15,
              ),
            ),
        ),
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
                      ? CouleursApp.bordure  //actif
                      : CouleursApp.champ,  //inactif
                  border: Border.all(
                    // color: const Color.fromRGBO(127, 62, 40, 1.0),
                    width: 1.5,
                  ),
              ),
              child: Text(
                estFrancais ? 'Oui' : 'نعم',
                style: TextStyle(
                  color: CouleursApp.texte,
                  fontWeight: FontWeight.bold,
                  fontFamily: estFrancais ? 'PlayfairDisplay' : 'NoteNaskhArabic',
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
                  color: !valeur
                      ? CouleursApp.bordure  //actif
                      : CouleursApp.champ,  //inactif
                  border: Border.all(
                    // color: const Color.fromRGBO(127, 62, 40, 1.0),
                    width: 1.5,
                  ),
                ),
                child: Text(
                  estFrancais ? 'Non' : 'لا',
                  style: TextStyle(
                    color: CouleursApp.texte,
                    fontWeight: FontWeight.bold,
                    fontFamily: estFrancais ? 'PlayfairDisplay' : 'NoteNaskhArabic',
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