import 'package:flutter/material.dart';
import '../theme/couleurs.dart';

class BoutonRetour extends StatelessWidget {

  const BoutonRetour({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: CouleursApp.champ,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          Icons.arrow_back,
          color: CouleursApp.texte,
          size: 20,
        ),
      ),
    );
  }
}