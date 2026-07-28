import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/constat_provider.dart';
import '../theme/couleurs.dart';
import 'champ_texte.dart';

class SectionTemoins extends StatefulWidget {
  final bool enFrancais;

  const SectionTemoins({
    super.key,
    required this.enFrancais,
  });

  @override
  State <SectionTemoins> createState() => _SectionTemoinsState();
}

class _SectionTemoinsState extends State<SectionTemoins>{
  // Un contrôleur par champ, par témoin — clé = "nom_0", "prenom_0", "nom_1"...
  final Map<String, TextEditingController> controleurs = {};

  TextEditingController _controleurPour(int index, String champ, String valeurActuelle) {
    final cle = '${champ}_$index';
    return controleurs.putIfAbsent(cle, () => TextEditingController(text: valeurActuelle));
  }

  @override
  void dispose() {
    for (final c in controleurs.values) {  //On parcourt toutes les valeurs de la Map controleurs
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ConstatProvider>();
    final temoins = provider.constat.listeTemoins;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        //La 1ere carte témoin
        for (int i = 0; i<temoins.length; i++)
          Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _CarteTemoin(
                  index: i,
                  enFrancais: widget.enFrancais,
                  controleurNom: _controleurPour(i, 'nom', temoins[i].nom),
                  controleurPrenom: _controleurPour(i, 'prenom', temoins[i].prenom),
                  controleurAdresse: _controleurPour(i, 'adresse', temoins[i].adresse),
                  controleurNumTel: _controleurPour(i, 'numTel', temoins[i].numTel),
              ),
          ),

          //Bouton pour ajouter un nouveau témoin
          OutlinedButton.icon(
            onPressed: provider.ajouterTemoin,
            icon: const Icon(
              Icons.add,
              color: CouleursApp.alerte,
            ),
            label:Text(
              widget.enFrancais ? 'Ajouter un témoin' : 'إضافة شاهد',
              style: TextStyle(
                color: CouleursApp.alerte,
                fontFamily: widget.enFrancais ? 'PlayfairDisplay' : 'NoteNaskhArabic',
                fontSize: 16.5,
                fontWeight: FontWeight.bold,
              ),
            ),
            style: OutlinedButton.styleFrom(
              backgroundColor: CouleursApp.alerte.withValues(alpha: 0.15),
              side: const BorderSide(
                color: CouleursApp.alerte,
                width: 1.5,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              )
            ),

        ),
      ],
    );
  }
}

class _CarteTemoin extends StatelessWidget{
  final int index;
  final bool enFrancais;
  final TextEditingController controleurNom;
  final TextEditingController controleurPrenom;
  final TextEditingController controleurAdresse;
  final TextEditingController controleurNumTel;


  const _CarteTemoin({
    required this.index,
    required this.enFrancais,
    required this.controleurNom,
    required this.controleurPrenom,
    required this.controleurAdresse,
    required this.controleurNumTel,

  });

  @override
  Widget build(BuildContext context){
    final provider = context.watch<ConstatProvider>();
    final temoin = provider.constat.listeTemoins[index];

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.redAccent.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: CouleursApp.alerte,
          width: 1.5,
        )
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //Titre de l'étape et l'icone d'un témoin
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  //Icone
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: CouleursApp.alerte.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Icon(
                        Icons.person,
                        color: CouleursApp.alerte,
                    ),
                  ),
                  const SizedBox(width: 10),

                  //Titre de l'étape
                  Text(
                    enFrancais ? 'Témoin ${index+1}' : 'الشاهد ${index + 1}',
                    textAlign: enFrancais ? TextAlign.left : TextAlign.right,
                    textDirection: enFrancais ? TextDirection.ltr : TextDirection.rtl,
                    style: TextStyle(
                      color: CouleursApp.alerte,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                      fontFamily: enFrancais ? 'PlayfairDisplay' : 'NoteNaskhArabic',
                    ),
                  ),

                ],
              ),

              GestureDetector(
                onTap: () => provider.supprimerTemoin(index),
                child: const Icon(
                  Icons.close,
                  color: CouleursApp.alerte,
                  size: 25,
                ),
              )
            ],
          ),
          const SizedBox(height: 10),

          const Divider(
            color: CouleursApp.alerte,
            thickness: 1.5,
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              //Nom
              Expanded(
                child: ChampTexte(
                  label: enFrancais ? 'Nom' : 'اللقب',
                  controleur: controleurNom,
                  enFrancais: enFrancais,
                  changed: (value) {provider.setNomTemoin(index, value);},
                  hintText: enFrancais ? 'Ex: Mhiri' : 'مثال: المهيري',
                ),
              ),
              const SizedBox(width: 8),

              //Prénom
              Expanded(
                child: ChampTexte(
                  label: enFrancais ? 'Prénom' : 'الاسم',
                  controleur: controleurPrenom,
                  enFrancais: enFrancais,
                  changed: (value) {provider.setPrenomTemoin(index, value);},
                  hintText: enFrancais ? 'Ex: Ahmed' : 'مثال: أحمد',
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),

          //Adresse
          ChampTexte(
            label: enFrancais ? 'Adresse' : 'العنوان',
            controleur: controleurAdresse,
            enFrancais: enFrancais,
            changed: (value) {
              provider.setAdresseTemoin(index, value);
            },
            hintText: enFrancais
                ? 'Ex: Rue de Marseille, Tunis'
                : 'مثال: نهج مرسيليا، تونس',
          ),
          const SizedBox(height: 25),

          //Numéro du téléphone
          ChampTexte(
            label: enFrancais ? 'Numéro de téléphone' : 'رقم الهاتف',
            controleur: controleurNumTel,
            enFrancais: enFrancais,
            changed: (value) {provider.setNumTelTemoin(index, value);},
            hintText: enFrancais ? 'Ex: 98 123 456' : 'مثال: 98 123 456',
          ),
        ],
      ),
    );
  }
}