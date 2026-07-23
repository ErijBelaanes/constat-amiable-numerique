import 'package:flutter/material.dart';
import 'package:projet_constat/widgets/titre_souligne.dart';
import 'package:provider/provider.dart';
import '../providers/constat_provider.dart';
import '../widgets/entete_etape.dart';
import '../theme/couleurs.dart';
import '../widgets/bouton_principal.dart';
import '../widgets/case_circonstance.dart';

class EcranCirconstances extends StatelessWidget{
  const EcranCirconstances({super.key});

  Widget _ligneTableau({
    required Widget colonneTexte,
    required Widget colonneA,
    required Widget colonneB,
    double hauteurSeparateur = 55,
  }){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          flex: 5,
          child: colonneTexte,
        ),
        const SizedBox(width: 8),

        Container(
            width: 1,
            height: hauteurSeparateur,
            color: CouleursApp.texteSecondaire,
        ),
        const SizedBox(width: 8),

        Expanded(
            flex: 2,
            child: Center(child: colonneA),
        ),
        const SizedBox(width: 8),

        Container(
            width: 1,
            height: hauteurSeparateur,
            color: CouleursApp.texteSecondaire,
        ),
        const SizedBox(width: 8),

        Expanded(
            flex: 2,
            child: Center(child: colonneB),
        ),
      ],
    );
  }
  //Les 17 circonstances
  static const List<Map<String, String>> circonstances = [
    {'fr': 'En stationnement:', 'ar': 'كانت واقفة:'},
    {'fr': 'Quittait un stationnement:', 'ar': 'كانت تغادر موقف سيارات:'},
    {'fr': 'Prenait un stationnement:', 'ar': 'كانت بصدد الوقوف:'},
    {'fr': "Sortait d'un parking, d'un lieu privé, d'un chemin de terre:", 'ar': 'كانت خارجة من موقف أو مكان خاص أو طريق ترابي:'},
    {'fr': "S'engageait dans un parking, un lieu privé, un chemin de terre:", 'ar': 'كانت داخلة إلى موقف أو مكان خاص أو طريق ترابي:'},
    {'fr': "Arrêt de circulation:", 'ar': 'كانت متوقفة بسبب الحركة المرورية:'},
    {'fr': 'Frottement sans changement de file', 'ar': 'احتكاك دون تغيير المسار:'},
    {'fr': "Heurtait à l'arrière, en roulant dans le même sens et sur la même file:", 'ar': 'اصطدمت من الخلف في نفس الاتجاه والمسار:'},
    {'fr': 'Roulait dans le même sens et sur une file différente:', 'ar': 'كانت تسير في نفس الاتجاه على مسار مختلف:'},
    {'fr': 'Changeait de file:', 'ar': 'كانت تغير المسار:'},
    {'fr': 'Doublait:', 'ar': 'كانت بصدد تجاوز:'},
    {'fr': 'Virait à droite:', 'ar': 'كانت تنعطف يمينًا:'},
    {'fr': 'Virait à gauche:', 'ar': 'كانت تنعطف يسارًا:'},
    {'fr': 'Reculait', 'ar': 'كانت تتراجع:'},
    {'fr': "Empiétait sur la partie de chaussée réservée à la circulation en sens inverse:", 'ar': 'تجاوزت إلى الجزء المخصص للاتجاه المعاكس:'},
    {'fr': 'Venait de droite (dans un carrefour):', 'ar': 'قادمة من اليمين (في تقاطع):'},
    {'fr': "N'avait pas observé le signal de priorité:", 'ar': 'لم تحترم إشارة الأولوية:'},
  ];

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ConstatProvider>();
    final enFrancais = provider.enFrancais;
    final constat = provider.constat;

    final int caseVraiVehA = constat.circonstancesA.where((c) => c).length;
    final int caseFauxVehA = 17 - caseVraiVehA;
    final int caseVraiVehB = constat.circonstancesB.where((c) => c).length;
    final int caseFauxVehB = 17 - caseVraiVehB;

    return Directionality(
      textDirection: enFrancais ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        backgroundColor: CouleursApp.fond,
        body: SafeArea(
          child: Stack(
            fit: StackFit.expand,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 20, 20, 20),
                child: Scrollbar(
                  thumbVisibility: true,
                  thickness: 8,
                  radius: const Radius.circular(4),
                  child: SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 90),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          EnteteEtape(
                            icone: Icons.check_box_outlined,
                            couleurIcone: CouleursApp.alerte,
                            titreFr: 'Circonstances',
                            titreAr: 'الظروف',
                            etapeActuelle: 4,
                            enFrancais: provider.enFrancais,
                          ),
                          const SizedBox(height: 36),

                          Text(
                            enFrancais ? 'Cochez les cases utiles pour préciser le croquis:'
                                       : 'ضع علامة في الخانات المفيدة لتوضيح الرسم:',
                            style: TextStyle(
                              color: CouleursApp.texte,
                              fontFamily: enFrancais ? 'PlayfairDisplay' : 'NoteNaskhArabic',
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 20),
                          //Ligne d'entête
                          _ligneTableau(
                              hauteurSeparateur: 30,
                              colonneTexte: Text(
                                enFrancais ? 'Circonstance' : 'ظرف',
                                style: TextStyle(
                                  color: CouleursApp.alerte,
                                  fontFamily: enFrancais ? 'PlayfairDisplay' : 'NoteNaskhArabic',
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              colonneA: Text(
                                enFrancais ? 'A' : 'أ',
                                style: TextStyle(
                                  color: CouleursApp.alerte,
                                  fontFamily: enFrancais ? 'PlayfairDisplay' : 'NoteNaskhArabic',
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              colonneB: Text(
                                enFrancais ? 'B' : 'ب',
                                style: TextStyle(
                                  color: CouleursApp.alerte,
                                  fontFamily: enFrancais ? 'PlayfairDisplay' : 'NoteNaskhArabic',
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                          ),
                          Divider(
                            color: CouleursApp.texteSecondaire,
                            thickness: 1,
                          ),
                          //Les circonstances
                          Column(
                            children: [
                              for(int i = 0; i < circonstances.length; i++) ...[
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 3),
                                  child: _ligneTableau(
                                    hauteurSeparateur: 55,
                                    colonneTexte: Text(
                                      enFrancais ? circonstances[i]['fr']! :circonstances[i]['ar']!,
                                      style: TextStyle(
                                        color: CouleursApp.texte,
                                        fontFamily: enFrancais ? 'PlayfairDisplay' : 'NoteNaskhArabic',
                                        fontSize: 16.5,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    colonneA: CaseCirconstance(
                                       cochee: constat.circonstancesA[i],
                                       click: (value) => provider.toggleCirconstanceA(i, value),
                                       enFrancais: enFrancais,
                                    ),
                                    colonneB: CaseCirconstance(
                                       cochee: constat.circonstancesB[i],
                                       click: (value) => provider.toggleCirconstanceB(i, value),
                                       enFrancais: enFrancais
                                    ),
                                  ),
                                ),
                                if(i < circonstances.length-1)
                                  const Divider(
                                    color: CouleursApp.texteSecondaire,
                                    thickness: 1,
                                  ),
                              ],
                            ],
                          ),

                          const SizedBox(height: 20),
                          //Compteur des case (Oui/Non) pour les 2 véhicules
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: CouleursApp.alerte.withValues(alpha: 0.6),
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: CouleursApp.alerte,
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              children: [
                                // Véhicule A
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Center(
                                        child: TitreSouligne(
                                          texte: enFrancais ? 'Véhicule A' : 'السيارة "أ"',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: enFrancais ? 'PlayfairDisplay' : 'NoteNaskhArabic',
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          couleurLigne: Colors.white,
                                          espacement: 3,
                                          styleLigne: StyleLigne.wavy,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        enFrancais ? '- $caseVraiVehA case(s) "Oui"' : '- $caseVraiVehA خانة "نعم"',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: enFrancais ? 'PlayfairDisplay' : 'NoteNaskhArabic',
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        enFrancais ? '- $caseFauxVehA case(s) "Non"' : '- $caseFauxVehA خانة "لا"',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: enFrancais ? 'PlayfairDisplay' : 'NoteNaskhArabic',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                Container(
                                  width: 2,
                                  height: 90,
                                  color: Colors.white54,
                                ),

                                const SizedBox(width: 12),

                                // Véhicule B
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Center(
                                        child: TitreSouligne(
                                          texte: enFrancais ? 'Véhicule B' : 'السيارة "ب"',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontFamily: enFrancais ? 'PlayfairDisplay' : 'NoteNaskhArabic',
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          couleurLigne: Colors.white,
                                          espacement: 3,
                                          styleLigne: StyleLigne.wavy,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        enFrancais ? '- $caseVraiVehB case(s) "Oui"' : '- $caseVraiVehB خانة "نعم"',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: enFrancais ? 'PlayfairDisplay' : 'NoteNaskhArabic',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      Text(
                                        enFrancais ? '- $caseFauxVehB case(s) "Non"' : '- $caseFauxVehB خانة "لا"',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontFamily: enFrancais ? 'PlayfairDisplay' : 'NoteNaskhArabic',
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              //Bouton "Suivant"
              BoutonPrincipal(
                label: enFrancais ? 'Suivant' : 'التالي',
                couleur: CouleursApp.alerte,
                click: () => Navigator.pushNamed(context, '/croquis'),
                enFrancais: enFrancais,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
