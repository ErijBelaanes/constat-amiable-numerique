import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/constat_provider.dart';
import '../theme/couleurs.dart';
import '../widgets/bouton_retour.dart';

class EcranAvertissement extends StatelessWidget {
  const EcranAvertissement({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final provider = context.read<ConstatProvider>();
    final estFrancais = provider.estFrancais;

    return Directionality(
      textDirection: estFrancais ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        backgroundColor: CouleursApp.fond,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Stack(
              children: [
                Column(
                  children: [
                    Align(
                      alignment: estFrancais ? Alignment.centerLeft : Alignment
                          .centerRight,
                      child: BoutonRetour(estFrancais: estFrancais),
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
                          estFrancais ? 'Avertissement' : 'تنبيه',
                          style: TextStyle(
                            fontFamily: estFrancais
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
                      estFrancais
                          ? "Le remplissage de ce document ne constitue pas une reconnaissance de responsabilité, mais un relevé des identités et des faits, servant à l'accélération du règlement.\n\nVeuillez lire attentivement ces informations avant de commencer le constat."
                          : "إن تعبئة هذه الوثيقة لا تُعد اعترافًا بالمسؤولية، وإنما هي تسجيل لهوية الأطراف والوقائع، بهدف تسريع إجراءات التسوية.\n\nيرجى قراءة هذه المعلومات بعناية قبل البدء في تعبئة محضر الحادث.",
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontFamily: estFrancais
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

                // Bouton Commencer
                Positioned(
                  left: 24,
                  right: 24,
                  bottom: 24,
                  child: SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(context, '/accident');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: CouleursApp.alerte,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 6,
                      ),
                      child: Text(
                        estFrancais ? 'Commencer' : 'ابدأ',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          fontFamily: estFrancais
                              ? 'PlayfairDisplay'
                              : 'NotoNaskhArabic',
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}