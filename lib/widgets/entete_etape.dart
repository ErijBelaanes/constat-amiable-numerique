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
  final bool estFrancais;
  final VoidCallback changerLangue;

  const EnteteEtape({
    super.key,
    required this.icone,
    required this.couleurIcone,
    required this.titreFr,
    required this.titreAr,
    required this.etapeActuelle,
    required this.estFrancais,
    required this.changerLangue,
  });

  @override
  Widget build (BuildContext context){
    return Column(
      children: [

        //Titre de la page
        // Text(
        //   estFrancais ? 'Constat Amiable' : 'المعاينة الودية',
        //   textAlign: estFrancais ? TextAlign.left : TextAlign.right,
        //   textDirection: estFrancais ? TextDirection.ltr : TextDirection.rtl,
        //   style: TextStyle(
        //     color: CouleursApp.titre,
        //     fontWeight: FontWeight.bold,
        //     fontSize: 32.0,
        //     fontFamily: estFrancais ? 'PlayfairDisplay' : 'NoteNaskhArabic',
        //   ),
        // ),

        Directionality(
            textDirection: TextDirection.ltr,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                BoutonRetour(estFrancais: estFrancais),

                SelecteurLangue(
                  estFrancais: estFrancais,
                  click: changerLangue,
                ),

              ],
            ),
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
              estFrancais ? titreFr : titreAr,
              textAlign: estFrancais ? TextAlign.left : TextAlign.right,
              textDirection: estFrancais ? TextDirection.ltr : TextDirection.rtl,
              style: TextStyle(
                color: couleurIcone,
                fontWeight: FontWeight.bold,
                fontSize: 24.0,
                fontFamily: estFrancais ? 'PlayfairDisplay' : 'NoteNaskhArabic',
              ),
            ),

          ],
        ),
        const SizedBox(height: 15),
        //Indicateur des étapes
        IndicateurEtapes(
          etapeAct: etapeActuelle,
          enFrancais: estFrancais,
          couleur: couleurIcone,
        ),
      ],
    );
  }
}