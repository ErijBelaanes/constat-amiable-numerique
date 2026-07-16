import 'package:flutter/material.dart';
import '../theme/couleurs.dart';

class BoutonRetour extends StatelessWidget {
  final VoidCallback? click;  //Si null => Navigator.pop(context)

  const BoutonRetour({
    super.key,
    this.click,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: click ?? () {      //Si on ne fournit pas click alors le comportement reste inchangé sinon il prend le dessus
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