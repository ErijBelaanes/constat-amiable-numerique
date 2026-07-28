import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:projet_constat/widgets/titre_souligne.dart';
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
import '../utils/localisation.dart';
import '../widgets/galerie_photo.dart';

class Question{
  final String cle;
  final String cleLabel;
  final String type;

  const Question({
    required this.cle,
    required this.cleLabel,
    required this.type,  //texte, date, pointChoc ou photos
  });
}


class Groupe{
  final String cleTitre;
  final List<Question> questions;

  const Groupe({
    required this.cleTitre,
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
  List<Uint8List> photosDegatsApparents = [];

  static const List<Groupe> groupes = [
    Groupe(
      cleTitre: 'societe_assurance',
      questions: [
        Question(
          cle: 'assurance',
          cleLabel: 'assurance',
          type: 'texte',
        ),

        Question(
          cle: 'numContrat',
          cleLabel: 'numAssurance',
          type: 'texte',
        ),

        Question(
          cle: 'agence',
          cleLabel: 'agence',
          type: 'texte',
        ),

        Question(
          cle: 'dateDebutAttestation',
          cleLabel: 'dateDebutAttestation',
          type: 'date',
        ),

        Question(
          cle: 'dateFinAttestation',
          cleLabel: 'dateFinAttestation',
          type: 'date',
        ),
      ],
    ),


    Groupe(
      cleTitre: 'identite_conduxteur',
      questions: [
        Question(
          cle: 'nomConducteur',
          cleLabel: 'nomConducteur',
          type: 'texte',
        ),

        Question(
          cle: 'prenomConducteur',
          cleLabel: 'prenomConducteur',
          type: 'texte',
        ),

        Question(
          cle: 'adresseConducteur',
          cleLabel: 'adresseConducteur',
          type: 'texte',
        ),

        Question(
          cle: 'numPermis',
          cleLabel: 'numPermis',
          type: 'texte',
        ),

        Question(
          cle: 'datePermis',
          cleLabel: 'datePermis',
          type: 'date',
        ),
      ],
    ),


    Groupe(
      cleTitre: 'assure',
      questions: [
        Question(
          cle: 'nomAssure',
          cleLabel: 'nomAssure',
          type: 'texte',
        ),

        Question(
          cle: 'prenomAssure',
          cleLabel: 'prenomAssure',
          type: 'texte',
        ),

        Question(
          cle: 'adresseAssure',
          cleLabel: 'adresseAssure',
          type: 'texte',
        ),

        Question(
          cle: 'numTel',
          cleLabel: 'numTelAssure',
          type: 'texte',
        ),
      ],
    ),


    Groupe(
      cleTitre: 'identite_vehicule',
      questions: [
        Question(
          cle: 'marque',
          cleLabel: 'marqueVehicule',
          type: 'texte',
        ),

        Question(
          cle: 'type',
          cleLabel: 'typeVehicule',
          type: 'texte',
        ),

        Question(
          cle: 'numImmatriculation',
          cleLabel: 'numImmatriculation',
          type: 'texte',
        ),

        Question(
          cle: 'sensSuivi',
          cleLabel: 'sensSuivi',
          type: 'texte',
        ),

        Question(
          cle: 'venantDe',
          cleLabel: 'venantDe',
          type: 'texte',
        ),

        Question(
          cle: 'allantA',
          cleLabel: 'allantA',
          type: 'texte',
        ),
      ],
    ),


    Groupe(
      cleTitre: 'pointDeChocInit',
      questions: [
        Question(
          cle: 'pointChoc',
          cleLabel: 'selection_pointCoc',
          type: 'pointChoc',
        ),
      ],
    ),


    Groupe(
      cleTitre: 'finalisation',
      questions: [
        Question(
          cle: 'degatsApparents',
          cleLabel: 'degatsApparents',
          type: 'texte',
        ),

        Question(
          cle: 'photosDegats',
          cleLabel: 'photosDegatsApparents',
          type: 'photos',
        ),

        Question(
          cle: 'observations',
          cleLabel: 'observations',
          type: 'texte',
        ),
      ],
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
    final info = (widget.nomVehicule == 'A') ? provider.constat.vehiculeA : provider.constat.vehiculeB;

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
    controleursTexte['numImmatriculation']!.text = info.numImmatriculation;
    controleursTexte['sensSuivi']!.text = info.sensSuivi;
    controleursTexte['venantDe']!.text = info.venantDe;
    controleursTexte['allantA']!.text = info.allantA;

    pointChocSelectionne = info.pointChoc;
    imagePointChocSelectionne = info.imagePointChoc;

    controleursTexte['degatsApparents']!.text = info.degatsApparents;
    photosDegatsApparents = List<Uint8List>.from(info.photosDegatsApparents);
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
      numImmatriculation: controleursTexte['numImmatriculation']!.text.trim(),
      sensSuivi: controleursTexte['sensSuivi']!.text.trim(),
      venantDe: controleursTexte['venantDe']!.text.trim(),
      allantA: controleursTexte['allantA']!.text.trim(),

      pointChoc: pointChocSelectionne,
      imagePointChoc: imagePointChocSelectionne,

      degatsApparents: controleursTexte['degatsApparents']!.text.trim(),
      photosDegatsApparents: photosDegatsApparents,

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
          if(q.cle == 'degatsApparents'){
            questionVide = controleursTexte['degatsApparents']!.text.trim().isEmpty
                && photosDegatsApparents.isEmpty;
          }else{
            questionVide = controleursTexte[q.cle]!.text.trim().isEmpty;
          }
          break;
        case 'date':
          questionVide = (reponsesDate[q.cle] == null);
          break;
        case 'pointChoc':
          questionVide = (pointChocSelectionne == null) || (imagePointChocSelectionne == null);
          break;
        case 'photos':
          continue;
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
    const clesNomPrenom = [('nomConducteur', 'nom du conducteur', 'اسم السائق'),
                           ('prenomConducteur', 'prénom du conducteur', 'لقب السائق'),
                           ('nomAssure', 'nom de l\'assuré', 'اسم المؤمن عليه'),
                           ('prenomAssure', 'prénom de l\'assuré', 'لقب المؤمن عليه')
    ];
    for(final cle in clesNomPrenom){
      if(g.questions.any((q) => (q.cle == cle.$1))){
        final valeur = controleursTexte[cle.$1]!.text.trim();
        if(!RegExp(r"^[a-zA-ZÀ-ÿ\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\s'-]+$").hasMatch(valeur)){
          return enFrancais ? 'Le ${cle.$2} ne doit contenir que des lettres'
                            : 'يجب أن يحتوي ${cle.$3} على أحرف فقط';
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

    //Contrôle du champ numImmatriculation (composé seulement par des chiffres)
    if(g.questions.any((q) => (q.cle == 'numImmatriculation'))){
      final numIm = controleursTexte['numImmatriculation']!.text.trim();
      if(!RegExp(r'^[0-9]+$').hasMatch(numIm)){
        return enFrancais ? 'Le numéro d\'immatriculation de la véhicule doit contenir que des chiffres'
            : 'يجب أن يحتوي رقم تسجيل المركبة على أرقام فقط';
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
      numImmatriculation: controleursTexte['numImmatriculation']!.text.trim(),
      sensSuivi: controleursTexte['sensSuivi']!.text.trim(),
      venantDe: controleursTexte['venantDe']!.text.trim(),
      allantA: controleursTexte['allantA']!.text.trim(),

      //Point de choc
      pointChoc: pointChocSelectionne,
      imagePointChoc: imagePointChocSelectionne,

      //Degat apparents
      degatsApparents: controleursTexte['degatsApparents']!.text.trim(),
      photosDegatsApparents: photosDegatsApparents,

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
                  thumbVisibility: false,
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
                              titreAr: (widget.nomVehicule == 'A') ? 'المركبة "أ"' : 'المركبة "ب"',
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
                                TitreSouligne(
                                  texte: Localisation.get(groupe.cleTitre, enFrancais),
                                  style: TextStyle(
                                    color: (widget.nomVehicule == 'A') ? CouleursApp.texteVehiculeA : CouleursApp.texteVehiculeB,
                                    fontFamily: enFrancais ? 'PlayfairDisplay' : 'NoteNaskhArabic',
                                    fontSize: 23,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  couleurLigne: (widget.nomVehicule == 'A') ? CouleursApp.texteVehiculeA : CouleursApp.texteVehiculeB,
                                  espacement: enFrancais ? 4 : 4.5,
                                  styleLigne: StyleLigne.wavy,
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
                                          label: Localisation.get(q.cleLabel, enFrancais),
                                          controleur: controleursTexte[q.cle]!,
                                          enFrancais: enFrancais,
                                          changed: (value) {setState(() {});},
                                          hintText: "",
                                        );
                                        break;

                                      //Sélection d'une date
                                      case "date":
                                        champ = ChampBouton(
                                          label: Localisation.get(q.cleLabel, enFrancais),
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
                                               Localisation.get(q.cleLabel, enFrancais),
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

                                      //Photos
                                      case "photos":
                                        champ = GaleriePhotos(
                                          photos: photosDegatsApparents,
                                          changed: (nouvellesPhotos) {
                                            setState(() {
                                              photosDegatsApparents = nouvellesPhotos;
                                            });
                                            if (widget.nomVehicule == 'A') {
                                              provider.setPhotosDegatsVehiculeA(nouvellesPhotos);
                                            } else {
                                              provider.setPhotosDegatsVehiculeB(nouvellesPhotos);
                                            }
                                          },
                                          enFrancais: enFrancais,
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

