import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/selecteur_langue.dart';
import '../theme/couleurs.dart';
import '../providers/constat_provider.dart';

class EcranAccueil extends StatelessWidget{
  const EcranAccueil ({super.key});

  @override
  Widget build(BuildContext context){
    final provider = context.watch<ConstatProvider>();
    final enFrancais = provider.estFrancais;
    final titre = enFrancais ? 'Bienvenue dans Constat' : 'مرحبًا بكم في تطبيق "Constat"';

    final description = enFrancais ?
        "En cas d'accident, restez calme. Cette application vous guide étape par "
        "étape pour compléter votre constat amiable en toute simplicité.\n\n"
        "Suivez les différentes étapes, renseignez les informations demandées, "
        "puis signez votre constat. Une fois terminé, vous pourrez le "
        "télécharger au format PDF et le partager avec votre assurance."
        : "في حالة وقوع حادث، يُرجى الحفاظ على الهدوء. سيرافقكم هذا التطبيق خطوة "
        "بخطوة لإتمام تعبئة المعاينة الودية بكل سهولة.\n\n"
        "اتبعوا المراحل المختلفة، وأدخلوا المعلومات المطلوبة، ثم وقّعوا على "
        "المعاينة الودية. بعد الانتهاء، سيكون بإمكانكم تنزيلها بصيغة PDF "
        "ومشاركتها مع شركة التأمين.";

    return Scaffold(
      backgroundColor: CouleursApp.fond,
      body: SafeArea(
          child: Stack(
            children: [Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [

                      //Titre
                      Text(
                          titre,
                          textAlign: enFrancais ? TextAlign.left : TextAlign.right,
                          textDirection: enFrancais ? TextDirection.ltr : TextDirection.rtl,
                          style: TextStyle(
                            color: CouleursApp.titre,
                            fontWeight: FontWeight.bold,
                            fontSize: 32.0,
                            fontFamily: enFrancais ? 'PlayfairDisplay' : 'NoteNaskhArabic',
                          )
                      ),
                      const SizedBox(height: 20),

                      //Description
                      Text(
                          description,
                          textAlign: enFrancais ? TextAlign.left : TextAlign.right,
                          textDirection: enFrancais ? TextDirection.ltr : TextDirection.rtl,
                          style: TextStyle(
                            color: CouleursApp.texte,
                            fontSize: 20.0,
                            fontFamily: enFrancais ? 'PlayfairDisplay' : 'NoteNaskhArabic',
                          )
                      ),
                    ]
                  )
                ),
              ),

              // Positionnement du selecteur du langue (fr/ar)
              Positioned(
                top: 20,
                left: enFrancais ? 8 : null,
                right: enFrancais ? null : 8,
                child: SelecteurLangue(
                    estFrancais : enFrancais,
                    click : provider.changerLangue,
                ),
              ),

              //Bouton "Commencer"
              Positioned(
                left: 24,
                right: 24,
                bottom: 24,
                child: SizedBox(
                  height: 56,  //Bouton d'hauteur fixe
                  child: ElevatedButton(
                    onPressed: (){
                      Navigator.pushNamed(context, '/accident');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CouleursApp.titre,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 6, //Effet flottant
                    ),
                    child: Text(
                      enFrancais ? 'Commencer' : 'ابدأ',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                        fontFamily: enFrancais ? 'PlayfairDisplay' : 'NoteNaskhArabic',
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
      ),
    );
  }
}

