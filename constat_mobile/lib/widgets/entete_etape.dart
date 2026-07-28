import 'package:flutter/material.dart';
import 'selecteur_langue.dart';
import 'indicateur_etapes.dart';
import '../theme/couleurs.dart';
import '../widgets/bouton_retour.dart';

class EnteteEtape extends StatelessWidget{
  final IconData icone;
  final Color couleurIcone;
  final String titreFr;
  final String titreAr;
  final int etapeActuelle;
  final bool enFrancais;

  const EnteteEtape({
    super.key,
    required this.icone,
    required this.couleurIcone,
    required this.titreFr,
    required this.titreAr,
    required this.etapeActuelle,
    required this.enFrancais,
  });

  @override
  Widget build (BuildContext context){
    return Column(
      children: [
        Align(
          alignment: enFrancais ? Alignment.centerLeft : Alignment.centerRight,
          child: BoutonRetour(),
        ),

        const SizedBox(height: 20),

        // //Le titre de l'étape de l'icone correspondante
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //Icone
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                 color: couleurIcone.withValues(alpha: 0.15),
                 borderRadius: BorderRadius.circular(15),
               ),
              child: Icon(icone, color: couleurIcone),
            ),
            const SizedBox(width: 10),

            //Titre de l'étape
            Text(
              enFrancais ? titreFr : titreAr,
              textAlign: enFrancais ? TextAlign.left : TextAlign.right,
              textDirection: enFrancais ? TextDirection.ltr : TextDirection.rtl,
              style: TextStyle(
                color: couleurIcone,
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
                fontFamily: enFrancais ? 'PlayfairDisplay' : 'NoteNaskhArabic',
              ),
            ),

          ],
        ),
        const SizedBox(height: 15),
        //Indicateur des étapes
        IndicateurEtapes(
          etapeAct: etapeActuelle,
          enFrancais: enFrancais,
          couleur: couleurIcone,
        ),
      ],
    );
  }
}