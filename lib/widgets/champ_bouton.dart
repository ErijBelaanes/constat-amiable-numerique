import 'package:flutter/material.dart';
import 'package:projet_constat/theme/couleurs.dart';

class ChampBouton extends StatelessWidget{
  final String label;
  final String valeur;
  final VoidCallback click;
  final bool estFrancais;

  const ChampBouton({
    super.key,
    required this.label,
    required this.valeur,
    required this.click,
    required this.estFrancais,
  });

  @override
  Widget build(BuildContext context){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          textAlign: estFrancais ? TextAlign.left : TextAlign.right,
          textDirection: estFrancais ? TextDirection.ltr : TextDirection.rtl,
          style: TextStyle(
            color: CouleursApp.texteSecondaire,
            fontFamily: estFrancais ? 'PlayfairDisplay' : 'NoteNaskhArabic',
            fontSize: 16.5,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: click,
          child: Container(
            width: double.infinity, //Occupe toute la largeur donnée par Expanded
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            decoration: BoxDecoration(
              color: CouleursApp.champ,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: CouleursApp.bordure2,
                width: 1.5,
              ),

            ),
            child: Text(
                valeur,
                style: TextStyle(
                    color: CouleursApp.texteSecondaire,
                    fontStyle: FontStyle.italic,
                    fontFamily: estFrancais ? 'PlayfairDisplay' : 'NoteNaskhArabic',
                    fontSize: 16,
                ),
            )
          ),
        ),
      ],
    );
  }
}