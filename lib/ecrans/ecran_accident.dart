import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/constat_provider.dart';
import '../widgets/entete_etape.dart';
import '../widgets/champ_bouton.dart';
import '../widgets/question_oui_non.dart';
import '../theme/couleurs.dart';

class EcranAccident extends StatefulWidget {
  const EcranAccident({super.key});

  @override
  State <EcranAccident> createState() => _EcranAccidentState();
}

class _EcranAccidentState extends State<EcranAccident>{
  final lieuController = TextEditingController();

  DateTime? dateChoisie;
  TimeOfDay? heureChoisie;

  @override
  void initState(){
    super.initState();
    final constat = context.read<ConstatProvider>().constat;
    lieuController.text = constat.lieuAccident;

    if(constat.dateAccident != null){
      dateChoisie = constat.dateAccident;
      heureChoisie = TimeOfDay.fromDateTime(constat.dateAccident!);
    }
  }

  //Libérer le champ de lieu
  @override
  void dispose() {
    lieuController.dispose();
    super.dispose();
  }

  //Fonction pour sélectionner une date de l'accident
  Future <void> choisirDate() async{
    final resultat = await showDatePicker(
       context: context,
       initialDate: dateChoisie ?? DateTime.now(),
       firstDate: DateTime(2000),
       lastDate: DateTime.now(),
    );

    if(resultat != null){  //Si l'utilisateur clique sur "OK" au lieu de "Annuler"
      setState(() {
        dateChoisie = resultat;
      });
    }
  }

  //Fonction pour sélectionner l'heure de l'accident
  Future <void> choisirHeure() async {
    final resultat = await showTimePicker(
      context: context,
      initialTime: heureChoisie ?? TimeOfDay.now(),
    );

    if(resultat != null){  //Si l'utilisateur clique sur "OK" au lieu de "Annuler"
      setState(() {
        heureChoisie = resultat;
      });
    }
  }

  void validerEtSauvegarder(){
    final provider = context.read<ConstatProvider>();

    if(dateChoisie != null && heureChoisie != null){
      final dateComplet = DateTime(
        dateChoisie!.year,
        dateChoisie!.month,
        dateChoisie!.day,
        heureChoisie!.hour,
        heureChoisie!.minute,
      );
      provider.setDateAccident(dateComplet);
    }
    if(lieuController.text.isNotEmpty){
      provider.setLieuAccident(lieuController.text);
    }
    //degats, blesses, temoins
    Navigator.pushNamed(context, '/vehiculeA');
  }
  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ConstatProvider>();

    final estFrancais = provider.estFrancais;
    final constat = provider.constat;

    return Directionality(
      textDirection: estFrancais ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        //Bouton "Suivant"
        bottomNavigationBar: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
            child: SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: validerEtSauvegarder,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.redAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 6,
                ),
                child: Text(
                  estFrancais ? 'Suivant' : 'التالي',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    fontFamily:
                    estFrancais ? 'PlayfairDisplay' : 'NoteNaskhArabic',
                  ),
                ),
              ),
            ),
          ),
        ),
        backgroundColor: CouleursApp.fond,
        body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    EnteteEtape(
                        icone: Icons.warning_amber_rounded,
                        couleurIcone: CouleursApp.alerte,
                        titreFr: 'Informations communes',
                        titreAr: 'معلومات عامة',
                        etapeActuelle: 1,
                        estFrancais: provider.estFrancais,
                        changerLangue: provider.changerLangue
                    ),
                    const SizedBox(height: 36),

                    //Formulaire
                    //Date et heure
                    Row(
                      children: [
                        //Date
                        Expanded(
                            child: ChampBouton(
                              label: estFrancais ? 'Date' : 'التاريخ',
                              valeur: dateChoisie == null
                                  ? (estFrancais ? 'Choisir' : 'اختر')
                                  : '${dateChoisie!.day}/${dateChoisie!.month}/${dateChoisie!.year}',
                              click: choisirDate,
                              estFrancais: estFrancais,
                          )  ,
                        ),
                        const SizedBox(width: 25),
                        //Heure
                        Expanded(
                          child: ChampBouton(
                            label: estFrancais ? 'Heure' : 'الساعة',
                            valeur: heureChoisie == null
                                ? (estFrancais ? 'Choisir' : 'اختر')
                                : heureChoisie!.format(context),
                            click: choisirHeure,
                            estFrancais: estFrancais,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 25),
                    //Lieu
                    Text(
                      estFrancais ? 'Lieu de l\'accident' : 'مكان الحادث',
                      textAlign: estFrancais ? TextAlign.left : TextAlign.right,
                      textDirection: estFrancais ? TextDirection.ltr : TextDirection.rtl,
                      style: TextStyle(
                        color: CouleursApp.texteSecondaire,
                        fontFamily: estFrancais ? 'PlayfairDisplay' : 'NoteNaskhArabic',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: lieuController,
                      style: TextStyle(
                        color: CouleursApp.texteSecondaire,
                        fontFamily: estFrancais ? 'PlayfairDisplay' : 'NoteNaskhArabic',
                      ),
                      decoration: InputDecoration(
                        hintText: estFrancais ? 'Ex: Avenue Habib Bourguiba, Tunis' : 'مثال: شارع الحبيب بورقيبة، تونس',
                        hintStyle: TextStyle(
                          color: CouleursApp.texteSecondaire,
                          fontFamily: estFrancais ? 'PlayfairDisplay' : 'NoteNaskhArabic',
                        ),
                        filled: true,
                        fillColor: CouleursApp.champ,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: CouleursApp.bordure,
                            width: 1.5,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 35),

                    //Questions Oui/Non
                    //Blesses
                    QuestionOuiNon(
                      label: estFrancais ? 'Y a-t-il des blessés (Même légers)?' : 'هل يوجد جرحى (حتى الخفيفة منها)؟',
                      valeur: constat.blesses,
                      change: provider.setBlesses,
                      estFrancais: estFrancais,
                    ),
                    const SizedBox(height: 25),

                    //Dégâts matériels
                    QuestionOuiNon(
                      label: estFrancais ? 'Y a-t-il des dégâts matériels autres qu\'aux véhicules A et B?' : 'هل يوجد أضرار مادية غير السيارتين أ و ب؟',
                      valeur: constat.degatsMat,
                      change: provider.setDegatsMat,
                      estFrancais: estFrancais,
                    ),
                    const SizedBox(height: 20),

                    //Témoins
                    QuestionOuiNon(
                      label: estFrancais ? 'Y a-t-il des témoins?' : 'هل يوجد شهود؟',
                      valeur: constat.temoins,
                      change: provider.setTemoins,
                      estFrancais: estFrancais,
                    ),
                    // if(constat.temoins){
                    //
                    // },
                    const SizedBox(height: 20),
                  ],
                ),
            ),
          ),
        ),
      ),
    );
  }
}
