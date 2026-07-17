import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/constat_provider.dart';
import '../models/constat_model.dart';
import '../widgets/entete_etape.dart';
import '../theme/couleurs.dart';
import '../utils/dialogues.dart';
import '../widgets/bouton_principal.dart';
import '../widgets/zone_dessin.dart';

class EcranCroquis extends StatefulWidget{
  const EcranCroquis({super.key});

  State<EcranCroquis> createState() => _EcranCroquisState();
}

class _EcranCroquisState extends State<EcranCroquis>{
  final GlobalKey<ZoneDessinState> _cleZone = GlobalKey();

  Future<void> validerCroquis() async {
    final provider = context.read<ConstatProvider>();
    final imageBytes = await _cleZone.currentState?.capturerImageDessin();
    final enFrancais = provider.enFrancais;

    if (_cleZone.currentState?.aDesTraits != true) {
      afficherErreur(
        context,
        enFrancais ? 'Veuillez fournir un croquis de l\'accident'
            : 'يرجى تقديم رسم تخطيطي للحادث',
        enFrancais,
      );
      return;
    }
    if(imageBytes != null){
      provider.setCroquis(imageBytes);
    }

    provider.setTraitsCroquis(_cleZone.currentState!.traits);
    Navigator.pushNamed(context, '/signatures');
  }

  //Méthode pour réévaluer les boutons à chaque fois que le dessin change
  void dessinChange(){
    setState(() {});  //Forcer un rebuild
  }

  @override
  Widget build(BuildContext context){
    final provider = context.watch<ConstatProvider>();
    final enFrancais = provider.enFrancais;
    bool possedeTraits = false;

    return Directionality(
      textDirection: enFrancais ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        backgroundColor: CouleursApp.fond,
        body: SafeArea(
          child: Stack(
            fit: StackFit.expand,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    EnteteEtape(
                      icone: Icons.car_crash_sharp,
                      couleurIcone: CouleursApp.alerte,
                      titreFr: 'Croquis de l\'accident',
                      titreAr: 'رسم تخطيطي للحادث',
                      etapeActuelle: 5,
                      enFrancais: provider.enFrancais,
                    ),
                    const SizedBox(height: 36),

                    Text(
                      enFrancais ? "Dessinez le croquis de l'accident au doigt"
                                 : 'ارسم مخطط الحادث بإصبعك',
                      style: TextStyle(
                        color: CouleursApp.texteSecondaire,
                        fontSize: 18,
                        fontFamily: enFrancais ? 'PlayfairDisplay' : 'NoteNaskhArabic',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),

                    //Croquis
                    Expanded(
                      child: Column(
                        children: [
                          SizedBox(
                            height: 400,
                            child: ZoneDessin(
                                key: _cleZone,
                                change: dessinChange,
                            ),
                          ),
                          const SizedBox(height: 20),
                          //Boutons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              //Bouton "Annuler" (Ce bouton efface le dernier trait)
                              OutlinedButton.icon(
                                onPressed: (_cleZone.currentState?.aDesTraits ?? false)
                                    ? _cleZone.currentState?.annulerTrait
                                    : null,   //S'il n'y a aucun trait alors le bouton est désactivé
                                icon: Icon(
                                  Icons.undo_rounded,
                                  size: 15,
                                ),
                                label: Text(
                                  enFrancais ? 'Annuler' : 'تراجع',
                                ),
                                style: ButtonStyle(
                                  foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                                    if (states.contains(WidgetState.disabled)) {
                                      return Colors.grey; //Couleur du texte et de l'icône désactivés
                                    }
                                    return CouleursApp.texte;

                                  }),
                                  minimumSize: WidgetStatePropertyAll(const Size(0, 28),),
                                  textStyle: WidgetStatePropertyAll(
                                    TextStyle(
                                      fontFamily: enFrancais ? 'PlayfairDisplay' : 'NoteNaskhArabic',
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),

                              //Bouton "Recommencer" (Ce bouton efface le dessin en entier)
                              OutlinedButton.icon(
                                onPressed: (_cleZone.currentState?.aDesTraits ?? false)
                                    ? _cleZone.currentState?.effacerTrait
                                    : null,   //S'il n'y a aucun trait alors le bouton est désactivé
                                icon: Icon(
                                  Icons.delete_outline,
                                  size: 15,
                                ),
                                label: Text(
                                  enFrancais ? 'Recommencer' : 'إعادة',
                                ),
                                style: ButtonStyle(
                                  foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                                    if (states.contains(WidgetState.disabled)) {
                                      return Colors.grey; //Couleur du texte et de l'icône désactivés
                                    }
                                    return CouleursApp.texte;
                                  }),
                                  minimumSize: WidgetStatePropertyAll(const Size(0, 28),),
                                  textStyle: WidgetStatePropertyAll(
                                    TextStyle(
                                      fontFamily: enFrancais ? 'PlayfairDisplay' : 'NoteNaskhArabic',
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      )
                    ),
                  ],
                ),
              ),

              //Bouton "Suivant"
              BoutonPrincipal(
                label: enFrancais ? 'Suivant' : 'التالي',
                couleur: CouleursApp.alerte,
                click: (_cleZone.currentState?.aDesTraits ?? false)
                    ? validerCroquis
                    : null,
                enFrancais: enFrancais,
              ),
            ],
          ),
        ),
      ),
    );
  }
}