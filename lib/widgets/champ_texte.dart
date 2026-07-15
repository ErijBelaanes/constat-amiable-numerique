import 'package:flutter/material.dart';
import '../theme/couleurs.dart';

class ChampTexte extends StatelessWidget {
  final String label;
  final TextEditingController controleur;
  final String? hintText;
  final ValueChanged<String>? changed;
  final bool enFrancais;

  const ChampTexte({
    super.key,
    required this.label,
    required this.controleur,
    required this.enFrancais,
    this.changed,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          textAlign: enFrancais ? TextAlign.left : TextAlign.right,
          textDirection: enFrancais ? TextDirection.ltr : TextDirection.rtl,
          style: TextStyle(
            color: CouleursApp.texteSecondaire,
            fontFamily: enFrancais ? 'PlayfairDisplay' : 'NoteNaskhArabic',
            fontWeight: FontWeight.bold,
            fontSize: 16.5,
          ),
        ),
        const SizedBox(height: 8),

        TextField(
          controller: controleur,
          onChanged: changed,
          style: TextStyle(
            color: CouleursApp.texte,
            fontFamily: enFrancais ? 'PlayfairDisplay' : 'NoteNaskhArabic',
          ),
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: TextStyle(
              color: CouleursApp.texte,
              fontFamily: enFrancais ? 'PlayfairDisplay' : 'NoteNaskhArabic',
              fontSize: 16,
            ),
            filled: true,
            fillColor: CouleursApp.champ,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: CouleursApp.bordure2,
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: CouleursApp.bordure2,
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}