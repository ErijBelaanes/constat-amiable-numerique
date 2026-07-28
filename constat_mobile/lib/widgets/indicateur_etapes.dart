import 'package:flutter/material.dart';
import '../theme/couleurs.dart';

class IndicateurEtapes extends StatelessWidget{
  final int etapeAct;
  final bool enFrancais;
  final Color couleur;

  const IndicateurEtapes({
    super.key,
    required this.etapeAct,
    required this.enFrancais,
    required this.couleur,
  });

  static const int totalEtapes = 7;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: enFrancais ? TextDirection.ltr : TextDirection.rtl,
      child: Column(
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(totalEtapes, (index) {
            final estActive = index==etapeAct-1;  //Pour allumer/activer le point de l'étape correspondante
            return AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsetsDirectional.only(end: 6),  //On insére un petit espace de 6 pixels après chaque point
              width: estActive ? 24 : 8,  //Les points inactifs restent petits, de 8px, et les points actifs seront allongé
              height: 8,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: estActive ? couleur : CouleursApp.texteSecondaire,
              ),
            );
         }),
        ),
        const SizedBox(height: 10),
        Text(
          enFrancais
              ? 'Étape $etapeAct sur $totalEtapes'
              : 'الخطوة $etapeAct من $totalEtapes',
          style: TextStyle(
            color: CouleursApp.texteSecondaire,
            fontSize: 15,
            fontFamily: enFrancais ? 'PlayfairDisplay' : 'NoteNaskhArabic',
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
     ),
    );
  }
}