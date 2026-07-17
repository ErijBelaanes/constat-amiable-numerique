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

class EcranSignatures extends StatefulWidget{
  const EcranSignatures({super.key});

  State<EcranSignatures> createState() => _EcranSignaturesState();
}

class _EcranSignaturesState extends State<EcranSignatures>{
  int conducteurAct = 0;  //0 => A || 1 => B
  final GlobalKey<ZoneDessinState> _cleSignatureA = GlobalKey();
  final GlobalKey<ZoneDessinState> _cleSignatureB = GlobalKey();
  GlobalKey<ZoneDessinState> get _cleActuelle =>
     conducteurAct == 0 ? _cleSignatureA : _cleSignatureB;

  //Méthode pour réévaluer les boutons à chaque fois que le dessin change
  void changerSignature(){
    setState(() {});  //Forcer un rebuild
  }

  void suivant(){
    final provider = context.read<ConstatProvider>();
    final enFrancais = provider.enFrancais;

    if((_cleActuelle.currentState?.aDesTraits) != true){
      afficherErreur(
          context,
          enFrancais ? 'Veuillez signer avant de continuer' : 'يرجى التوقيع قبل المتابعة',
          enFrancais
      );
      return;
    }

    if(conducteurAct == 0){
      setState(() {
        conducteurAct = 1;
      });
    }else{
      validerSignatures();
    }
  }

  void precedent(){
    setState(() {
      conducteurAct = 0;
    });
  }

  Future <void> validerSignatures() async{
    final provider = context.read<ConstatProvider>();
    final enFrancais = provider.enFrancais;

    final imageA = await _cleSignatureA.currentState?.capturerImageDessin();
    final imageB = await _cleSignatureB.currentState?.capturerImageDessin();

    Navigator.pushNamed(context, '/recapitulatif');
  }

  @override
  Widget build(BuildContext context){
    final provider = context.watch<ConstatProvider>();
    final enFrancais = provider.enFrancais;
    final estA = (conducteurAct == 0);

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
                      icone: Icons.gesture_rounded,
                      couleurIcone: CouleursApp.alerte,
                      titreFr: 'Signatures',
                      titreAr: 'التوقيعات',
                      etapeActuelle: 6,
                      enFrancais: provider.enFrancais,
                    ),
                    const SizedBox(height: 36),
                    Container(
                      padding: const EdgeInsets.fromLTRB(20,8,20,20),
                      decoration: BoxDecoration(
                        color: CouleursApp.bordure1,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                            color: CouleursApp.bordure1,
                            width: 1.5,
                        ),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              //Bouton "Précédent" (Revenir au conducteur A, ou quitter l'écran)
                              OutlinedButton.icon(
                                onPressed: (conducteurAct > 0) ? precedent : null,
                                icon: const Icon(
                                  Icons.arrow_back,
                                  size: 16,
                                ),
                                label: Text(enFrancais ? 'Précédent' : 'السابق'),
                                style: ButtonStyle(
                                  foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                                    if (states.contains(WidgetState.disabled)) {
                                      return Colors
                                          .grey; //Couleur du texte et de l'icône désactivés
                                    }
                                    return CouleursApp.texteVehiculeB;
                                  }),
                                  minimumSize: WidgetStatePropertyAll(const Size(0, 28),),
                                  textStyle: WidgetStatePropertyAll(
                                    TextStyle(
                                      fontFamily: enFrancais ? 'PlayfairDisplay' : 'NoteNaskhArabic',
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: CouleursApp.texteVehiculeB,
                                    ),

                                  ),
                                ),
                              ),
                              //Bouton "Suivant"
                              OutlinedButton.icon(
                                onPressed: (conducteurAct < 1 )? suivant : null,
                                icon: const Icon(
                                  Icons.arrow_forward,
                                  size: 16,
                                ),
                                label: Text(enFrancais ? 'Suivant' : 'التالي'),
                                style: ButtonStyle(
                                  foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                                    if (states.contains(WidgetState.disabled)) {
                                      return Colors
                                          .grey; //Couleur du texte et de l'icône désactivés
                                    }
                                    return CouleursApp.texteVehiculeB;
                                  }),
                                  minimumSize: WidgetStatePropertyAll(const Size(0, 28),),
                                  textStyle: WidgetStatePropertyAll(
                                    TextStyle(
                                      fontFamily: enFrancais ? 'PlayfairDisplay' : 'NoteNaskhArabic',
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: CouleursApp.texteVehiculeB,
                                    ),

                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          Text(
                            estA ? (enFrancais ? 'Signature du conducteur A' : 'توقيع السائق أ')
                                : (enFrancais ? 'Signature du conducteur B' : 'توقيع السائق ب'),
                            style: TextStyle(
                              color: CouleursApp.alerte,
                              fontSize: 18,
                              fontFamily: enFrancais ? 'PlayfairDisplay' : 'NoteNaskhArabic',
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline,
                              decorationColor: CouleursApp.alerte,
                              decorationThickness: 5,
                              decorationStyle: TextDecorationStyle.wavy,
                            ),
                          ),
                          const SizedBox(height: 20),
                          //Texte de rappel
                          Text(
                            enFrancais ? 'Signer ne signifie pas reconnaître sa responsabilité'
                                : 'التوقيع لا يعني الاعتراف بالمسؤولية',
                            style: TextStyle(
                              color: CouleursApp.texteSecondaire,
                              fontSize: 14,
                              fontFamily: enFrancais ? 'PlayfairDisplay' : 'NoteNaskhArabic',
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 20),

                          //Canva de signature
                          SizedBox(
                            height: 250,
                            child: Stack(
                              children: [
                                //Signature du conducteur A
                                Offstage(
                                  offstage: conducteurAct != 0,
                                  child: ZoneDessin(
                                    key: _cleSignatureA,
                                    change: changerSignature,
                                  ),
                                ),

                                //Signature du conducteur B
                                Offstage(
                                  offstage: conducteurAct != 1,
                                  child: ZoneDessin(
                                    key: _cleSignatureB,
                                    change: changerSignature,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 20),
                          //Boutons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              //Bouton "Annuler" (Ce bouton efface le dernier trait)
                              OutlinedButton.icon(
                                onPressed: (_cleActuelle.currentState?.aDesTraits ?? false)
                                    ? _cleActuelle.currentState?.annulerTrait
                                    : null,
                                //S'il n'y a aucun trait alors le bouton est désactivé
                                icon: const Icon(
                                  Icons.undo_rounded,
                                  size: 15,
                                ),
                                label: Text(
                                  enFrancais ? 'Annuler' : 'تراجع',
                                ),
                                style: ButtonStyle(
                                  foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                                    if (states.contains(
                                        WidgetState.disabled)) {
                                      return Colors.grey; //Couleur du texte et de l'icône désactivés
                                    }
                                    return CouleursApp.texte;
                                  }),
                                  minimumSize: WidgetStatePropertyAll(
                                    const Size(0, 28),
                                  ),
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
                                onPressed: (_cleActuelle.currentState?.aDesTraits ?? false)
                                    ? _cleActuelle.currentState?.effacerTrait
                                    : null,
                                //S'il n'y a aucun trait alors le bouton est désactivé
                                icon: const Icon(
                                  Icons.delete_outline,
                                  size: 15,
                                ),
                                label: Text(
                                  enFrancais ? 'Effacer' : 'مسح',
                                ),
                                style: ButtonStyle(
                                  foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                                    if (states.contains(WidgetState.disabled)) {
                                      return Colors.grey; //Couleur du texte et de l'icône désactivés
                                    }
                                    return CouleursApp.texte;
                                  }),
                                  minimumSize: WidgetStatePropertyAll(
                                    const Size(0, 28),
                                  ),
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
                      ),
                    )
                  ],
                ),
              ),
              // Bouton "Suivant"
              BoutonPrincipal(
                label: enFrancais ? 'Suivant' : 'التالي',
                couleur: CouleursApp.alerte,
                click: (conducteurAct == 0) ? null : validerSignatures,
                enFrancais: enFrancais,
              ),
            ],
          ),
        ),
      ),
    );
  }
}