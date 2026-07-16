import 'package:flutter/material.dart';

class BoutonPrincipal extends StatelessWidget{
  final String label;
  final Color couleur;
  final VoidCallback? click;
  final bool enFrancais;

  const BoutonPrincipal({
    super.key,
    required this.label,
    required this.couleur,
    required this.click,
    required this.enFrancais,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 24,
      right: 24,
      bottom: 24,
      child: SizedBox(
        height: 56,  //Bouton d'hauteur fixe
        child: ElevatedButton(
          onPressed: click,  //null == bouton désactivé
          style: ElevatedButton.styleFrom(
            backgroundColor: couleur,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            elevation: 6, //Effet flottant
          ),
          child: Text(
            label,
            style: TextStyle(
              color: Colors.white,
              fontSize: 25.0,
              fontWeight: FontWeight.bold,
              fontFamily: enFrancais ? 'PlayfairDisplay' : 'NoteNaskhArabic',
            ),
          ),
        ),
      ),
    );
  }
}