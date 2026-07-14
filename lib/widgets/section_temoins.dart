import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/constat_provider.dart';
import '../theme/couleurs.dart';
import 'champ_texte.dart';

class SectionTemoins extends StatefulWidget {
  final bool estFrancais;

  const SectionTemoins({
    super.key,
    required this.estFrancais,
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
                  estFrancais: widget.estFrancais,
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
              widget.estFrancais ? 'Ajouter un témoin' : 'إضافة شاهد',
              style: TextStyle(
                color: CouleursApp.alerte,
                fontFamily: widget.estFrancais ? 'PlayfairDisplay' : 'NoteNaskhArabic',
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
  final bool estFrancais;
  final TextEditingController controleurNom;
  final TextEditingController controleurPrenom;
  final TextEditingController controleurAdresse;
  final TextEditingController controleurNumTel;


  const _CarteTemoin({
    required this.index,
    required this.estFrancais,
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
            children: [
              Expanded(
                child: Text(
                  estFrancais ? 'Témoin ${index+1}' : 'الشاهد ${index + 1}',
                  style: TextStyle(
                    color: CouleursApp.alerte,
                    fontFamily: estFrancais ? 'PlayfairDisplay' : 'NoteNaskhArabic',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
                  label: estFrancais ? 'Nom' : 'اللقب',
                  controleur: controleurNom,
                  estFrancais: estFrancais,
                  hintText: estFrancais ? 'Mhiri' : 'المهيري',
                ),
              ),
              const SizedBox(width: 8),

              //Prénom
              Expanded(
                child: ChampTexte(
                  label: estFrancais ? 'Prénom' : 'الاسم',
                  controleur: controleurPrenom,
                  estFrancais: estFrancais,
                  hintText: estFrancais ? 'Ahmed' : 'أحمد',
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),

          //Adresse
          ChampTexte(
              label: estFrancais ? 'Adresse' : 'العنوان',
              controleur: controleurAdresse,
              estFrancais: estFrancais,
              hintText: estFrancais ? 'Ex: Rue de Marseille, Tunis' : 'مثال: نهج مرسيليا، تونس',
          ),
          const SizedBox(height: 25),

          //Numéro du téléphone
          ChampTexte(
            label: estFrancais ? 'Numéro de téléphone' : 'رقم الهاتف',
            controleur: controleurNumTel,
            estFrancais: estFrancais,
            hintText: estFrancais ? 'Ex: 98 123 456' : 'مثال: 98 123 456',
          ),
        ],
      ),
    );
  }
}