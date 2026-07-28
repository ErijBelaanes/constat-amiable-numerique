import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/constat_provider.dart';
import '../widgets/entete_etape.dart';
import '../widgets/champ_bouton.dart';
import '../widgets/question_oui_non.dart';
import '../theme/couleurs.dart';
import '../widgets/champ_texte.dart';
import '../widgets/section_temoins.dart';
import '../utils/dialogues.dart';
import '../widgets/bouton_principal.dart';
import '../services/service_geolocalisation.dart';

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
    final enFrancais = provider.enFrancais;
    final temoins = provider.constat.temoins;
    final listeTemoins = provider.constat.listeTemoins;

    if(dateChoisie == null || heureChoisie == null){
      afficherErreur(
        context,
        enFrancais
            ? 'Veuillez indiquer la date et l\'heure de l\'accident'
            : 'يرجى تحديد تاريخ ووقت الحادث',
        enFrancais,
      );
      return;
    }

    if(lieuController.text.trim().isEmpty){
      afficherErreur(
        context,
        enFrancais
            ? 'Veuillez indiquer le lieu de l\'accident'
            : 'يرجى تحديد مكان الحادث',
        enFrancais,
      );
      return;
    }

    if(temoins){
      for(final t in listeTemoins){
        if(t.nom.trim().isEmpty
          || t.prenom.trim().isEmpty
          || t.adresse.trim().isEmpty
          || t.numTel.trim().isEmpty){
          afficherErreur(
            context,
            enFrancais
               ? 'Veuillez renseigner les informations nécessaires de chaque témoin'
               : 'يرجى إدخال المعلومات اللازمة لكل شاهد',
            enFrancais,
          );
          return;
        }
        //Contrôle du nom (Composé que par des lettres)
        if(!RegExp( r"^[a-zA-ZÀ-ÿ\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\s'-]+$").hasMatch(t.nom.trim())){
          return afficherErreur(
            context,
            enFrancais ? 'Le nom du témoin ne doit contenir que des lettres'
                : 'يجب أن يحتوي لقب الشاهد على أحرف فقط',
            enFrancais,
          );
        }
        //Contrôle du prénom (Composé que par des lettres)
        if(!RegExp( r"^[a-zA-ZÀ-ÿ\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF\s'-]+$").hasMatch(t.prenom.trim())){
          return afficherErreur(
            context,
            enFrancais ? 'Le prénom du témoin ne doit contenir que des lettres'
                : 'يجب أن يحتوي اسم الشاهد على أحرف فقط',
            enFrancais,
          );
        }
        //Contrôle du numéro de téléphone (Composé par 8 chiffres)
        if(!RegExp(r'^[0-9]{8}$').hasMatch(t.numTel.trim())){
          afficherErreur(
            context,
            enFrancais
                ? 'Le numéro de téléphone du témoin doit contenir exactement 8 chiffres'
                : 'يجب أن يتكون رقم هاتف الشاهد من 8 أرقام بالضبط',
            enFrancais,
          );
          return;
        }
      }
    }


    final dateComplet = DateTime(
      dateChoisie!.year,
      dateChoisie!.month,
      dateChoisie!.day,
      heureChoisie!.hour,
      heureChoisie!.minute,
    );
    provider.setDateAccident(dateComplet);
    provider.setLieuAccident(lieuController.text.trim());
    Navigator.pushNamed(context, '/vehiculeA');
  }

  bool recherchePositionEnCours = false;
  Future<void> utiliserPositionActuelle() async {
    setState(() => recherchePositionEnCours = true);
    try {
      final adresse = await ServiceGeolocalisation.obtenirAdresseActuelle();
      if(!mounted) return;
      setState(() {
        lieuController.text = adresse;
      });
      context.read<ConstatProvider>().setLieuAccident(adresse);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur : ${e.toString()}')),
        );
      }
    } finally {
      if(mounted) {
        setState(() => recherchePositionEnCours = false);
      }
    }
  }

  String _messageErreur(Object e) {
    final texte = e.toString();
    return texte.startsWith('Exception: ') ? texte.substring(11) : texte;
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ConstatProvider>();
    final enFrancais = provider.enFrancais;

    final constat = provider.constat;

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
                                icone: Icons.warning_amber_rounded,
                                couleurIcone: CouleursApp.alerte,
                                titreFr: 'Informations communes',
                                titreAr: 'معلومات عامة',
                                etapeActuelle: 1,
                                enFrancais: provider.enFrancais,
                            ),
                            const SizedBox(height: 36),

                            //Formulaire
                            //Date et heure
                            Row(
                              children: [
                                //Date
                                Expanded(
                                  child: ChampBouton(
                                    label: enFrancais ? 'Date' : 'التاريخ',
                                    valeur: dateChoisie == null
                                        ? (enFrancais ? 'Choisir' : 'اختر')
                                        : '${dateChoisie!.day}/${dateChoisie!
                                        .month}/${dateChoisie!.year}',
                                    click: choisirDate,
                                    enFrancais: enFrancais,
                                  ),
                                ),
                                const SizedBox(width: 25),
                                //Heure
                                Expanded(
                                  child: ChampBouton(
                                    label: enFrancais ? 'Heure' : 'الساعة',
                                    valeur: heureChoisie == null
                                        ? (enFrancais ? 'Choisir' : 'اختر')
                                        : heureChoisie!.format(context),
                                    click: choisirHeure,
                                    enFrancais: enFrancais,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 30),
                            //Lieu
                            ChampTexte(
                              label: enFrancais
                                  ? 'Lieu de l\'accident'
                                  : 'مكان الحادث',
                              controleur: lieuController,
                              enFrancais: enFrancais,
                              changed: (value) {
                                provider.setLieuAccident(value);
                              },
                              hintText: enFrancais
                                  ? 'Ex: Avenue Habib Bourguiba, Tunis'
                                  : 'مثال: شارع الحبيب بورقيبة، تونس',
                            ),
                            const SizedBox(height: 6),
                            TextButton.icon(
                              onPressed: recherchePositionEnCours ? null : utiliserPositionActuelle,
                              icon: recherchePositionEnCours
                                  ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2, color: CouleursApp.texte),
                              )
                                  : const Icon(Icons.my_location, size: 18, color: CouleursApp.texte),
                              label: Text(
                                enFrancais ? 'Utiliser ma position actuelle' : 'استخدام موقعي الحالي',
                                style: TextStyle(
                                  color: CouleursApp.texte,
                                  fontFamily: enFrancais ? 'PlayfairDisplay' : 'NotoNaskhArabic',
                                ),
                              ),
                            ),

                            const SizedBox(height: 35),

                            //Questions Oui/Non
                            //Blesses
                            QuestionOuiNon(
                              label: enFrancais
                                  ? 'Y a-t-il des blessés (Même légers)?'
                                  : 'هل يوجد جرحى (حتى الخفيفة منها)؟',
                              valeur: constat.blesses,
                              change: provider.setBlesses,
                              enFrancais: enFrancais,
                            ),
                            const SizedBox(height: 30),

                            //Dégâts matériels
                            QuestionOuiNon(
                              label: enFrancais
                                  ? 'Y a-t-il des dégâts matériels autres qu\'aux véhicules A et B?'
                                  : 'هل يوجد أضرار مادية غير السيارتين أ و ب؟',
                              valeur: constat.degatsMat,
                              change: provider.setDegatsMat,
                              enFrancais: enFrancais,
                            ),
                            const SizedBox(height: 30),

                            //Témoins
                            QuestionOuiNon(
                              label: enFrancais
                                  ? 'Y a-t-il des témoins?'
                                  : 'هل يوجد شهود؟',
                              valeur: constat.temoins,
                              change: provider.setTemoins,
                              enFrancais: enFrancais,
                            ),
                            const SizedBox(height: 30),

                            //Section des témoins
                            if(constat.temoins)
                              SectionTemoins(enFrancais: enFrancais),
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
                 click: validerEtSauvegarder,
                 enFrancais: enFrancais,
               ),
             ],
          ),
        ),
      ),
    );
  }
}
