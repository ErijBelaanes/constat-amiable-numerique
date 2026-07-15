import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/constat_provider.dart';
import '../theme/couleurs.dart';
import '../widgets/bouton_retour.dart';
import '../widgets/bouton_principal.dart';

class EcranAvertissement extends StatelessWidget {
  const EcranAvertissement({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.read<ConstatProvider>();
    final enFrancais = provider.enFrancais;

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
                    children: [
                      Align(
                        alignment: enFrancais ? Alignment.centerLeft : Alignment
                            .centerRight,
                        child: BoutonRetour(),
                      ),
                      const SizedBox(height: 100),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          //Icone d'alerte
                          Icon(
                            Icons.warning_amber_rounded,
                            size: 75,
                            color: CouleursApp.alerte,
                          ),
                          const SizedBox(width: 10),
                          //Titre
                          Text(
                            enFrancais ? 'Avertissement' : 'تنبيه',
                            style: TextStyle(
                              fontFamily: enFrancais
                                  ? 'PlayfairDisplay'
                                  : 'NotoNaskhArabic',
                              color: CouleursApp.alerte,
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 25),
                      const Divider(
                        color: CouleursApp.alerte,
                        thickness: 2,
                      ),
                      const SizedBox(height: 35),
                      //Texte d'avertissement
                      Text(
                        enFrancais
                            ? "Le remplissage de ce document ne constitue pas une reconnaissance de responsabilité, mais un relevé des identités et des faits, servant à l'accélération du règlement.\n\nVeuillez lire attentivement ces informations avant de commencer le constat."
                            : "إن تعبئة هذه الوثيقة لا تُعد اعترافًا بالمسؤولية، وإنما هي تسجيل لهوية الأطراف والوقائع، بهدف تسريع إجراءات التسوية.\n\nيرجى قراءة هذه المعلومات بعناية قبل البدء في تعبئة محضر الحادث.",
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontFamily: enFrancais
                              ? 'PlayfairDisplay'
                              : 'NotoNaskhArabic',
                          color: CouleursApp.texte,
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),
                // Bouton Commencer
                BoutonPrincipal(
                  label: enFrancais ? 'Commencer' : 'ابدأ',
                  couleur: CouleursApp.titre,
                  click: () {
                    Navigator.pushNamed(context, '/accident');
                  },
                  enFrancais: enFrancais,
                ),
              ],
            ),
          ),
        ),
    );
  }
}