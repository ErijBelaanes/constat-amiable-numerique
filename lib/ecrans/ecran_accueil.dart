import 'package:flutter/material.dart';

class EcranAccueil extends StatefulWidget{
  const EcranAccueil ({super.key});

  @override
  State <EcranAccueil> createState() => _EcranAccueilEtat();
}
class _EcranAccueilEtat extends State <EcranAccueil>{
  bool enFrancais=true;  //La langue par défaut est le français

  void changerLangue(){
    setState(() {
      enFrancais =! enFrancais;
    });
  }

  @override
  Widget build(BuildContext context){
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
      backgroundColor: const Color.fromRGBO(240, 244, 195, 1),
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
                            color: Color.fromRGBO(198, 97, 63, 1),
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
                            color: const Color.fromRGBO(74, 80, 104,1),
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
                top: 8,
                left: 8,
                child: SelecteurLangue(
                    estFrancais : enFrancais,
                    click : changerLangue,
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
                      backgroundColor: const Color.fromRGBO(198, 97, 63, 1),
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

class SelecteurLangue extends StatelessWidget{
  final bool estFrancais;
  final VoidCallback click;

  const SelecteurLangue({
    super.key,
    required this.estFrancais,
    required this.click,
  });

  @override
  Widget build (BuildContext context){
    return GestureDetector(
      onTap: click,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 6),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(230, 238, 156, 1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color.fromRGBO(198, 97, 63, 1),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [

            //FR en 1ere position
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: estFrancais
                    ? const Color.fromRGBO(198, 97, 63, 1)  //actif
                    : const Color.fromRGBO(230, 238, 156, 1),  //inactif
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'FR',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),

            //AR en 2ème position
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: !estFrancais
                  ? const Color.fromRGBO(198, 97, 63, 1)  //actif
                  : const Color.fromRGBO(230, 238, 156, 1),  //inactif
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'AR',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}