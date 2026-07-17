import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/constat_provider.dart';
import '../models/constat_model.dart';
import '../widgets/entete_etape.dart';
import '../widgets/champ_bouton.dart';
import '../theme/couleurs.dart';
import '../widgets/champ_texte.dart';
import '../utils/dialogues.dart';
import '../widgets/bouton_principal.dart';
import '../widgets/champ_point_choc.dart';

class Question{
  final String cle;
  final String labelFR;
  final String labelAR;
  final String type;

  const Question({
    required this.cle,
    required this.labelFR,
    required this.labelAR,
    required this.type,  //texte, date ou pointChoc
  });
}


class Groupe{
  final String titreFR;
  final String titreAR;
  final List<Question> questions;

  const Groupe({
    required this.titreFR,
    required this.titreAR,
    required this.questions,
  });
}

class EcranVehicule extends StatefulWidget{
  final String nomVehicule;
  const EcranVehicule({super.key, required this.nomVehicule});

  @override
  State <EcranVehicule> createState() => _EcranVehiculeState();
}
class _EcranVehiculeState extends State<EcranVehicule>{
  int groupeAct = 0;
  bool questionsTerminees = false;

  final Map<String, TextEditingController> controleursTexte = {};
  final Map<String, DateTime?> reponsesDate = {};

  Offset? pointChocSelectionne;
  Uint8List? imagePointChocSelectionne;

  static const List<Groupe> groupes = [
    Groupe(
        titreFR: 'Sociéte d\'assurances',
        titreAR: 'شركة التأمين',
        questions: [
          Question(cle: 'assurance',
              labelFR: "Nom de la société d'assurance:",
              labelAR: 'اسم شركة التأمين:',
              type: 'texte'),

          Question(cle: 'numContrat',
              labelFR: 'Numéro de contrat:',
              labelAR: 'رقم عقد التأمين:',
              type: 'texte'),

          Question(cle: 'agence',
              labelFR: 'Agence:',
              labelAR: 'الوكالة:',
              type: 'texte'),

          Question(cle: 'dateDebutAttestation',
              labelFR: "Début de validité de l'attestation:",
              labelAR: 'بداية الصلاحية:',
              type: 'date'),

          Question(cle: 'dateFinAttestation',
              labelFR: "Fin de validité de l'attestation:",
              labelAR: 'نهاية الصلاحية:',
              type: 'date'),
        ]
    ),

    Groupe(
        titreFR: 'Identité du conducteur',
        titreAR: 'هوية السائق:',
        questions: [
          Question(cle: 'nomConducteur',
              labelFR: 'Nom du conducteur:',
              labelAR: 'اسم السائق:',
              type: 'texte'),

          Question(cle: 'prenomConducteur',
              labelFR: 'Prénom du conducteur:',
              labelAR: 'لقب السائق:',
              type: 'texte'),

          Question(cle: 'adresseConducteur',
              labelFR: 'Adresse du conducteur:',
              labelAR: 'عنوان السائق:',
              type: 'texte'),

          Question(cle: 'numPermis',
              labelFR: 'Numéro du permis de conduire:',
              labelAR: 'رقم رخصة السياقة:',
              type: 'texte'),

          Question(cle: 'datePermis',
              labelFR: 'Date de délivrance du permis:',
              labelAR: 'تاريخ إصدار الرخصة:',
              type: 'date'),
        ]
    ),

    Groupe(
        titreFR: 'Assuré',
        titreAR: 'المؤمَّن له',
        questions: [
          Question(cle: 'nomAssure',
              labelFR: "Nom de l'assuré:",
              labelAR: 'اسم المؤمَّن له:',
              type: 'texte'),

          Question(cle: 'prenomAssure',
              labelFR: "Prénom de l'assuré:",
              labelAR: 'لقب المؤمَّن له:',
              type: 'texte'),

          Question(cle: 'adresseAssure',
              labelFR: "Adresse de l'assuré:",
              labelAR: 'عنوان المؤمَّن له:',
              type: 'texte'),

          Question(cle: 'numTel',
              labelFR: 'Numéro de téléphone:',
              labelAR: ':رقم الهاتف',
              type: 'texte'),
        ]
    ),

    Groupe(
        titreFR: 'Identité du véhicule',
        titreAR: 'هوية السيارة',
        questions: [
          Question(cle: 'marque',
              labelFR: 'Marque du véhicule:',
              labelAR: 'ماركة السيارة:',
              type: 'texte'),

          Question(cle: 'type',
              labelFR: 'Type du véhicule:',
              labelAR: 'نوع السيارة:',
              type: 'texte'),

          Question(cle: 'sensSuivi',
              labelFR: 'Sens suivi:',
              labelAR: 'الاتجاه المتبع:',
              type: 'texte'),

          Question(cle: 'venantDe',
              labelFR: 'Venant de:',
              labelAR: 'قادم من:',
              type: 'texte'),

          Question(cle: 'allantA',
              labelFR: 'Allant à:',
              labelAR: 'متجه إلى:',
              type: 'texte'),
        ]
    ),

    Groupe(
        titreFR: 'Point de choc initial',
        titreAR: 'نقطة الاصطدام الأولي',
        questions: [
          Question(cle: 'pointChoc',
              labelFR: 'Indiquez le point de choc:',
              labelAR: 'حدد نقطة الاصطدام:',
              type: 'pointChoc'),
        ]
    ),

    Groupe(
        titreFR: 'Finalisation',
        titreAR: 'الإنهاء',
        questions: [
          Question(cle: 'degatsApparents',
              labelFR: 'Dégâts apparents:',
              labelAR: 'الأضرار الظاهرة:',
              type: 'texte'),
          Question(cle: 'observations',
              labelFR: 'Observations:',
              labelAR: 'ملاحظات:',
              type: 'texte'),
        ]
    ),
  ];
  @override
  void initState() {
    super.initState();
    for(final g in groupes) {
      for(final q in g.questions) {
        if(q.type == 'texte') {
          controleursTexte[q.cle] = TextEditingController();
        } else if(q.type =='date'){
          reponsesDate[q.cle] = null;
        }
      }
    }

  }
  late ConstatProvider provider;
  bool donneesChargees = false;
  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    provider = context.read<ConstatProvider>();

    if(!donneesChargees){
      chargerDonneesExistantes();
      donneesChargees = true;
    }
  }

  void chargerDonneesExistantes(){
    final info = (widget.nomVehicule == 'A') ? provider.vehiculeA : provider.vehiculeB;
    if(info == null){
      return;
    }

    controleursTexte['assurance']!.text = info.assurance;
    controleursTexte['numContrat']!.text = info.numContrat;
    controleursTexte['agence']!.text = info.agence;
    reponsesDate['dateDebutAttestation'] = info.dateDebutAttestation;
    reponsesDate['dateFinAttestation'] = info.dateFinAttestation;

    controleursTexte['nomConducteur']!.text = info.nomConducteur;
    controleursTexte['prenomConducteur']!.text = info.prenomConducteur;
    controleursTexte['adresseConducteur']!.text = info.adresseConducteur;
    controleursTexte['numPermis']!.text = info.numPermis;
    reponsesDate['datePermis'] = info.datePermis;

    controleursTexte['nomAssure']!.text = info.nomAssure;
    controleursTexte['prenomAssure']!.text = info.prenomAssure;
    controleursTexte['adresseAssure']!.text = info.adresseAssure;
    controleursTexte['numTel']!.text = info.numTel;

    controleursTexte['marque']!.text = info.marque;
    controleursTexte['type']!.text = info.type;
    controleursTexte['sensSuivi']!.text = info.sensSuivi;
    controleursTexte['venantDe']!.text = info.venantDe;
    controleursTexte['allantA']!.text = info.allantA;

    pointChocSelectionne = info.pointChoc;
    imagePointChocSelectionne = info.imagePointChoc;

    controleursTexte['degatsApparents']!.text = info.degatsApparents;
    controleursTexte['observations']!.text = info.observations;

    setState(() {});
  }

  @override
  void dispose() {
    sauvegarderDonnees();
    for(final c in controleursTexte.values) {
      c.dispose();
    }
    super.dispose();
  }

  void sauvegarderDonnees(){
    final infoVehicule = VehiculeInfo(
      assurance: controleursTexte['assurance']!.text.trim(),
      numContrat: controleursTexte['numContrat']!.text.trim(),
      agence: controleursTexte['agence']!.text.trim(),
      dateDebutAttestation: reponsesDate['dateDebutAttestation'],
      dateFinAttestation: reponsesDate['dateFinAttestation'],

      nomConducteur: controleursTexte['nomConducteur']!.text.trim(),
      prenomConducteur: controleursTexte['prenomConducteur']!.text.trim(),
      adresseConducteur: controleursTexte['adresseConducteur']!.text.trim(),
      numPermis: controleursTexte['numPermis']!.text.trim(),
      datePermis: reponsesDate['datePermis'],

      nomAssure: controleursTexte['nomAssure']!.text.trim(),
      prenomAssure: controleursTexte['prenomAssure']!.text.trim(),
      adresseAssure: controleursTexte['adresseAssure']!.text.trim(),
      numTel: controleursTexte['numTel']!.text.trim(),

      marque: controleursTexte['marque']!.text.trim(),
      type: controleursTexte['type']!.text.trim(),
      sensSuivi: controleursTexte['sensSuivi']!.text.trim(),
      venantDe: controleursTexte['venantDe']!.text.trim(),
      allantA: controleursTexte['allantA']!.text.trim(),

      pointChoc: pointChocSelectionne,
      imagePointChoc: imagePointChocSelectionne,

      degatsApparents: controleursTexte['degatsApparents']!.text.trim(),
      observations: controleursTexte['observations']!.text.trim(),
    );

    if (widget.nomVehicule == 'A') {
      provider.setVehiculeA(infoVehicule);
    } else {
      provider.setVehiculeB(infoVehicule);
    }
  }

  //Fonction pour sélectionner une date
  Future <void> choisirDate(String cle) async{
    final resultat = await showDatePicker(
      context: context,
      initialDate: reponsesDate[cle] ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2050),
    );

    if(resultat != null){  //Si l'utilisateur clique sur "OK" au lieu de "Annuler"
      setState(() {
        reponsesDate[cle] = resultat;
      });
    }
  }

  String? erreurPourGroupe(Groupe g){
    final provider = context.read<ConstatProvider>();
    final enFrancais = provider.enFrancais;

    //Vérifier que TOUS les champs, SAUF observations, sont remplis
    for (final q in g.questions) {
      if (q.cle == 'observations')
        continue; //Le champ "Observations" n'est pas obligatoire
      bool questionVide;

      switch (q.type) {
        case 'texte':
          questionVide = controleursTexte[q.cle]!.text.trim().isEmpty;
          break;
        case 'date':
          questionVide = (reponsesDate[q.cle] == null);
          break;
        case 'pointChoc':
          questionVide = (pointChocSelectionne == null) || (imagePointChocSelectionne == null);
          break;
        default:
          questionVide = true;
          break;
      }
      if (questionVide) {
        return enFrancais ? 'Veuillez remplir tous les champs avant de continuer'
                          : 'يرجى ملء جميع الحقول قبل المتابعة';
      }
    }

    //Contrôle des champs nomConducteur, prenomConducteur, nomAssure, prenomAssure
    const clesNomPrenom = [('nomConducteur', 'nom du conducteur'),
                           ('prenomConducteur', 'prénom du conducteur'),
                           ('nomAssure', 'nom de l\'assuré'),
                           ('prenomAssure', 'prénom de l\'assuré')
    ];
    for(final cle in clesNomPrenom){
      if(g.questions.any((q) => (q.cle == cle.$1))){
        final valeur = controleursTexte[cle.$1]!.text.trim();
        if(!RegExp(r"^[a-zA-ZÀ-ÿ\s'-]+$").hasMatch(valeur)){
          return enFrancais ? 'Le ${cle.$2} ne doit contenir que des lettres'
                            : 'يجب أن يحتوي هذا الحقل على أحرف فقط';
        }
      }
    }

    //Contrôle du champ numTel (8 chiffres)
    if(g.questions.any((q) => (q.cle == 'numTel'))){
      final tel = controleursTexte['numTel']!.text.trim();
      if(!RegExp(r'^[0-9]{8}$').hasMatch(tel)){
        return enFrancais ? 'Le numéro de téléphone doit contenir exactement 8 chiffres'
                          : 'يجب أن يتكون رقم الهاتف من 8 أرقام بالضبط';
      }
    }

    //Contrôle des champs dateDebutAttestaion et dateFinAttestation (dateDebutAttestaion < dateFinAttestation)
    if(g.questions.any((q) => (q.cle == 'dateDebutAttestation'))){
      final debut = reponsesDate['dateDebutAttestation'];
      final fin = reponsesDate['dateFinAttestation'];
      if((debut != null) && (fin != null) && (!debut.isBefore(fin))){
        return enFrancais ? 'La date de début doit être antérieure à la date de fin'
                          : 'يجب أن يكون تاريخ البداية قبل تاريخ النهاية';
      }
    }

    //Contrôle du champ numPermis (composé seulement par des chiffres)
    if(g.questions.any((q) => (q.cle == 'numPermis'))){
      final nPermis = controleursTexte['numPermis']!.text.trim();
      if(!RegExp(r'^[0-9]+$').hasMatch(nPermis)){
        return enFrancais ? 'Le numéro de permis doit contenir que des chiffres'
            : 'يجب أن يحتوي رقم التصريح على أرقام فقط';
      }
    }

    return null;  //Tous les champs sont valide
  }

  void groupeSuivant(){
    final provider = context.read<ConstatProvider>();
    final enFrancais = provider.enFrancais;
    final erreur = erreurPourGroupe(groupes[groupeAct]);

    if (erreur != null) {
      afficherErreur(
        context,
        erreur,
        enFrancais,
      );
      return;
    }

    if(groupeAct < groupes.length - 1){
      setState(() {
        groupeAct++;
      });
    }
  }

  void groupePrecedent(){
    setState(() {
      groupeAct--;
    });
  }

  void terminer(){
    final provider = context.read<ConstatProvider>();
    final erreur = erreurPourGroupe(groupes[groupes.length - 1]);
    final enFrancais = provider.enFrancais;

    if (erreur != null) {
      afficherErreur(
        context,
        erreur,
        enFrancais,
      );
      return;
    }

    //Si le dernier groupe est validé
    final infoVehicule = VehiculeInfo(
      //Societe d'assurances
      assurance: controleursTexte['assurance']!.text.trim(),
      numContrat: controleursTexte['numContrat']!.text.trim(),
      agence: controleursTexte['agence']!.text.trim(),
      dateDebutAttestation: reponsesDate['dateDebutAttestation']!,
      dateFinAttestation: reponsesDate['dateFinAttestation']!,

      //Identite du conducteur
      nomConducteur: controleursTexte['nomConducteur']!.text.trim(),
      prenomConducteur: controleursTexte['prenomConducteur']!.text.trim(),
      adresseConducteur: controleursTexte['adresseConducteur']!.text.trim(),
      numPermis: controleursTexte['numPermis']!.text.trim(),
      datePermis: reponsesDate['datePermis']!,

      //Assure
      nomAssure: controleursTexte['nomAssure']!.text.trim(),
      prenomAssure: controleursTexte['prenomAssure']!.text.trim(),
      adresseAssure: controleursTexte['adresseAssure']!.text.trim(),
      numTel: controleursTexte['numTel']!.text.trim(),

      //Identite du vehicule
      marque: controleursTexte['marque']!.text.trim(),
      type: controleursTexte['type']!.text.trim(),
      sensSuivi: controleursTexte['sensSuivi']!.text.trim(),
      venantDe: controleursTexte['venantDe']!.text.trim(),
      allantA: controleursTexte['allantA']!.text.trim(),

      //Point de choc
      pointChoc: pointChocSelectionne,
      imagePointChoc: imagePointChocSelectionne,

      //Degat apparents
      degatsApparents: controleursTexte['degatsApparents']!.text.trim(),

      //Observations
      observations: controleursTexte['observations']!.text.trim(),
    );

    if(widget.nomVehicule == 'A'){
      provider.setVehiculeA(infoVehicule);
      Navigator.pushNamed(context, '/vehiculeB');
    }else{
      provider.setVehiculeB(infoVehicule);
      Navigator.pushNamed(context, '/circonstances');
    }
}


  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ConstatProvider>();
    final enFrancais = provider.enFrancais;
    final groupe = groupes[groupeAct];

    return Directionality(
      textDirection: enFrancais ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        backgroundColor: (widget.nomVehicule == 'A') ? CouleursApp.fondVehiculeA : CouleursApp.fondVehiculeB,
        body: SafeArea(
          child: Stack(
            fit: StackFit.expand,
            children: [
              Padding(
                padding: const EdgeInsets.all(20),
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
                              icone: Icons.car_crash_rounded,
                              couleurIcone: (widget.nomVehicule == 'A') ? CouleursApp.texteVehiculeA : CouleursApp.texteVehiculeB,
                              titreFr: (widget.nomVehicule == 'A') ? 'Véhicule A' : 'Véhicule B',
                              titreAr: (widget.nomVehicule == 'A') ? 'السيارة "أ"' : 'السيارة "ب"',
                              etapeActuelle: (widget.nomVehicule == 'A') ? 2 : 3,
                              enFrancais: provider.enFrancais,
                          ),
                          const SizedBox(height: 36),
                          Container(
                            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
                            decoration: BoxDecoration(
                              color: CouleursApp.bordure1,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: CouleursApp.bordure1,
                                width: 1.5,
                              ),
                            ),

                            //Formulaire
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    //Bouton GroupePrecedent
                                    ElevatedButton.icon(
                                      onPressed: (groupeAct > 0) ? groupePrecedent
                                                                 : null, //Si c'est le 1er groupe alors le bouton est désactivé
                                      icon: const Icon(
                                        Icons.arrow_back,
                                        size: 15,
                                      ),
                                      label: Text(
                                        enFrancais ? 'Précédent' : 'السابق',
                                      ),
                                      style: ButtonStyle(foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                                          if (states.contains(WidgetState.disabled)) {
                                            return Colors.grey; //Couleur du texte et de l'icône désactivés
                                          }
                                          return (widget.nomVehicule == 'A') ? CouleursApp.texteVehiculeA : CouleursApp.texteVehiculeB;
                                        }),
                                        minimumSize: WidgetStatePropertyAll(
                                          const Size(0, 28),
                                        ),
                                        textStyle: WidgetStatePropertyAll(
                                          TextStyle(
                                            fontFamily: enFrancais ? 'PlayfairDisplay' : 'NoteNaskhArabic',
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: (widget.nomVehicule == 'A') ? CouleursApp.texteVehiculeA : CouleursApp.texteVehiculeB,
                                          ),

                                        ),
                                      ),
                                    ),

                                    //Bouton GroupeSuivant
                                    ElevatedButton.icon(
                                        onPressed: (groupeAct < groupes.length - 1) ? groupeSuivant
                                                                                    : null,   //Si c'est le dernier groupe alors le bouton est désactivé
                                        icon: const Icon(
                                          Icons.arrow_forward,
                                          size: 15,
                                        ),
                                        label: Text(
                                          enFrancais ? 'Suivant' : 'التالي',
                                        ),
                                        style: ButtonStyle(foregroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                                            if (states.contains(WidgetState.disabled)) {
                                              return Colors.grey; //Couleur du texte et de l'icône désactivés
                                            }
                                            return (widget.nomVehicule == 'A') ? CouleursApp.texteVehiculeA : CouleursApp.texteVehiculeB;
                                          }),
                                          minimumSize: WidgetStatePropertyAll(
                                            const Size(0, 28),
                                          ),
                                          textStyle: WidgetStatePropertyAll(
                                            TextStyle(
                                              fontFamily: enFrancais ? 'PlayfairDisplay' : 'NoteNaskhArabic',
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold,
                                              color: (widget.nomVehicule == 'A') ? CouleursApp.texteVehiculeA : CouleursApp.texteVehiculeB,
                                            ),

                                          ),
                                        )
                                    ),

                                  ],
                                ),
                                const SizedBox(height: 15),

                                //Titre du groupe
                                Text(
                                  enFrancais ? groupes[groupeAct].titreFR
                                             : groupes[groupeAct].titreAR,
                                  style: TextStyle(
                                    color: (widget.nomVehicule == 'A') ? CouleursApp.texteVehiculeA : CouleursApp.texteVehiculeB,
                                    fontFamily: enFrancais ? 'PlayfairDisplay' : 'NoteNaskhArabic',
                                    fontSize: 23,
                                    fontWeight: FontWeight.bold,
                                    decoration: TextDecoration.underline,
                                    decorationColor: (widget.nomVehicule == 'A') ? CouleursApp.texteVehiculeA : CouleursApp.texteVehiculeB,
                                    decorationThickness: 5,
                                    decorationStyle: TextDecorationStyle.solid,
                                  ),
                                ),
                                const SizedBox(height: 25),

                                //Questions/
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: groupe.questions.length,
                                  itemBuilder: (context, index) {
                                    final q = groupe.questions[index];
                                    Widget champ;
                                    switch (q.type) {
                                    //Champ texte
                                      case "texte":
                                        champ = ChampTexte(
                                          label: enFrancais ? q.labelFR : q.labelAR,
                                          controleur: controleursTexte[q.cle]!,
                                          enFrancais: enFrancais,
                                          changed: (value) {setState(() {});},
                                          hintText: "",
                                        );
                                        break;

                                    //Sélection d'une date
                                      case "date":
                                        champ = ChampBouton(
                                          label: enFrancais ? q.labelFR : q.labelAR,
                                          valeur: (reponsesDate[q.cle] == null)
                                              ? (enFrancais ? 'Choisir' : 'اختر')
                                              : '${reponsesDate[q.cle]!.day}/${reponsesDate[q.cle]!.month}/${reponsesDate[q.cle]!.year}',
                                          click: () {
                                            choisirDate(q.cle);
                                          },
                                          enFrancais: enFrancais,
                                        );
                                        break;

                                    //Point de choc
                                      case "pointChoc":
                                        champ = Column(
                                          children: [
                                            Text(
                                               enFrancais ? q.labelFR : q.labelAR,
                                               style: TextStyle(
                                                  color: CouleursApp.texteSecondaire,
                                                  fontFamily: enFrancais? 'PlayfairDisplay': 'NoteNaskhArabic',
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                               ),
                                            ),
                                            const SizedBox(height: 15),
                                            ChampPointChoc(
                                               valeurInitiale: pointChocSelectionne,
                                               pointChoisi: (Offset point,Uint8List? image) {
                                                  setState(() {
                                                     pointChocSelectionne = point;
                                                     imagePointChocSelectionne = image;
                                                  });
                                               },
                                            ),
                                          ],
                                        );
                                        break;
                                      default:
                                        champ = const SizedBox.shrink();
                                        break;
                                    }
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          bottom: 20),
                                      child: champ,
                                    );
                                  },
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
                couleur: (widget.nomVehicule == 'A') ? CouleursApp.texteVehiculeA : CouleursApp.texteVehiculeB,
                click: erreurPourGroupe(groupes[groupes.length - 1]) == null ? terminer : null,
                enFrancais: enFrancais,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

