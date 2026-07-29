import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:printing/printing.dart';
import '../providers/constat_provider.dart';
import '../models/constat_model.dart';
import '../widgets/entete_etape.dart';
import '../widgets/bouton_principal.dart';
import '../theme/couleurs.dart';
// import '../utils/generateur_pdf.dart';
import '../utils/generateurPDF.dart';
import 'dart:io';
import 'package:share_plus/share_plus.dart';
import '../ecrans/ecran_pdf.dart';
import '../services/service_api.dart';

class EcranRecapitulatif extends StatefulWidget{
  const EcranRecapitulatif({super.key});

  @override
  State<EcranRecapitulatif> createState() => _EcranRecapitulatifState();
}

class _EcranRecapitulatifState extends State<EcranRecapitulatif>{
  bool enCoursDeGeneration = false;

  Future<void> _telechargerPdf() async {
    setState(() => enCoursDeGeneration = true);
    try {
      final provider = context.read<ConstatProvider>();

      //Envoi du constat vers le backend
      await ApiService.envoyerConstat(provider.constat);

      final bytes = await GenerateurPDF.genererConstatSurModele(
        provider.constat,
        provider.constat.vehiculeA,
        provider.constat.vehiculeB,
        provider.enFrancais,
      );

      if(!mounted) return;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => EcranPdf(
            pdfBytes: bytes,
            enFrancais: provider.enFrancais,
          ),
        ),
      );
    }catch(e, stack){
      debugPrint("Erreur PDF: $e");
      debugPrint("$stack");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Erreur génération PDF : $e"),
        ),
      );
    } finally {
      if(mounted) setState(() => enCoursDeGeneration = false);
    }
  }

  Widget _carteSection(String titre, List<Widget> lignes, Color couleur, bool enFrancais){
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: CouleursApp.champ,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: couleur,
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titre,
            style: TextStyle(
              color: couleur,
              fontSize: 17,
              fontWeight: FontWeight.bold,
              fontFamily: enFrancais ? 'PlayfairDisplay' : 'NotoNaskhArabic',
            ),
          ),
          const SizedBox(height: 10),
          ...lignes,
        ],
      ),
    );
  }

  Widget _ligne(String label, String valeur, bool enFrancais){
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: TextStyle(
              color: CouleursApp.texteSecondaire,
              fontSize: 14,
              fontFamily: enFrancais ? 'PlayfairDisplay' : 'NotoNaskhArabic',
            ),
          ),
          Expanded(
              child: Text(
                valeur.isEmpty ? '-' : valeur,
                style: TextStyle(
                  color: CouleursApp.texte,
                  fontSize: 14,
                  fontFamily: enFrancais ? 'PlayfairDisplay' : 'NotoNaskhArabic',
                ),
              ),
          ),
        ],
      ),
    );
  }

  String _fmtDate(DateTime? d) {
    if(d == null) return '';
    return '${d.day}/${d.month}/${d.year}';
  }

  Future<void> partagerPdf(ConstatModel constat, bool enFrancais) async{
    try{
      final pdfBytes = await GenerateurPDF.genererConstatSurModele(
          constat,
          constat.vehiculeA,
          constat.vehiculeB,
          enFrancais,
      );
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/constat_amiable.pdf');
      await file.writeAsBytes(pdfBytes);
      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path)],
          text: 'Constat amiable',
        ),
      );
    }catch(e){
      debugPrint("Erreur partage PDF : $e");
    }
  }
  @override
  Widget build(BuildContext context){
    final provider = context.watch<ConstatProvider>();
    final enFrancais = provider.enFrancais;
    final constat = provider.constat;

    final date = constat.dateAccident;
    final dateTexte = (date == null)
        ? ''
        : '${date.day}/${date.month}/${date.year} — ${date.hour}:${date.minute.toString().padLeft(2, '0')}';

    return Directionality(
        textDirection: enFrancais ? TextDirection.ltr : TextDirection.rtl,
        child: Scaffold(
          backgroundColor: CouleursApp.fond,
          body: SafeArea(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 90, left: 20, right: 20, top: 20),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          EnteteEtape(
                              icone: Icons.summarize_rounded,
                              couleurIcone: CouleursApp.succes,
                              titreFr: 'Récapitulatif',
                              titreAr: 'ملخص',
                              etapeActuelle: 7,
                              enFrancais: enFrancais
                          ),
                          const SizedBox(height: 36),
                          _carteSection(
                            enFrancais ? "Informations sur l'accident" : 'معلومات الحادث',
                            [
                              _ligne(
                                  enFrancais ? 'Date et heure' : 'التاريخ والوقت',
                                  dateTexte,
                                  enFrancais
                              ),
                              _ligne(
                                  enFrancais ? 'Lieu' : 'المكان',
                                  constat.lieuAccident,
                                  enFrancais,
                              ),
                              _ligne(
                                  enFrancais ? 'Blessés' : 'جرحى',
                                  constat.blesses ? (enFrancais ? 'Oui' : 'نعم') : (enFrancais ? 'Non' : 'لا'),
                                  enFrancais,
                              ),
                              _ligne(
                                  enFrancais ? 'Dégâts matériels' : 'أضرار مادية',
                                  constat.degatsMat ? (enFrancais ? 'Oui' : 'نعم') : (enFrancais ? 'Non' : 'لا'),
                                  enFrancais,
                              ),
                              _ligne(
                                enFrancais ? 'Témoins' : 'شهود',
                                constat.temoins ? (enFrancais ? 'Oui (${constat.listeTemoins.length} témoin(s))' : 'نعم (${constat.listeTemoins.length} شاهد/شهود)') : (enFrancais ? 'Non' : 'لا'),
                                enFrancais
                              ),
                              if (constat.temoins && constat.listeTemoins.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4),
                                  child: RichText(
                                     text: TextSpan(
                                       children: [
                                         TextSpan(
                                           text: enFrancais ? 'Témoins: ' : 'الشهود: ',
                                           style: TextStyle(
                                             color: CouleursApp.texteSecondaire,
                                             fontSize: 14,
                                             fontFamily: enFrancais ? 'PlayfairDisplay' : 'NotoNaskhArabic',
                                           ),
                                         ),
                                         TextSpan(
                                           text: enFrancais
                                                 ? constat.listeTemoins.map((t) => '${t.nom} ${t.prenom} (N° tel: ${t.numTel} / Adresse: ${t.adresse})').join('\n')
                                                 : constat.listeTemoins.map((t) => '${t.prenom} ${t.nom}\n''العنوان: ${t.adresse}\n''رقم الهاتف: ${t.numTel}').join('\n\n'),
                                           style: TextStyle(
                                             color: CouleursApp.texte,
                                             fontSize: 14,
                                             fontFamily: enFrancais ? 'PlayfairDisplay' : 'NotoNaskhArabic',
                                           ),
                                         ),
                                       ],
                                     ),
                                  ),
                                ),
                            ],
                            CouleursApp.alerte,
                            enFrancais,
                          ),
                          _carteSection(
                            enFrancais ? 'Véhicule A' : 'السيارة أ',
                            [
                              _ligne(
                                  enFrancais ? 'Société d\'assurance' : 'شركة التأمين',
                                  constat.vehiculeA.assurance,
                                  enFrancais,
                              ),
                              _ligne(
                                  enFrancais ? 'N° contrat' : 'رقم العقد',
                                  constat.vehiculeA.numContrat,
                                  enFrancais,
                              ),
                              _ligne(
                                  enFrancais ? 'Agence' : 'الوكالة',
                                  constat.vehiculeA.agence,
                                  enFrancais,
                              ),
                              _ligne(
                                enFrancais ? 'Validité attestation' : 'صلاحية الشهادة',
                                '${_fmtDate(constat.vehiculeA.dateDebutAttestation)} - ${_fmtDate(constat.vehiculeA.dateFinAttestation)}',
                                enFrancais,
                              ),
                              _ligne(
                                  enFrancais ? 'Nom conducteur' : 'اسم السائق',
                                  constat.vehiculeA.nomConducteur,
                                  enFrancais,
                              ),
                              _ligne(
                                  enFrancais ? 'Prénom conducteur' : 'لقب السائق',
                                  constat.vehiculeA.prenomConducteur,
                                  enFrancais,
                              ),
                              _ligne(
                                  enFrancais ? 'Adresse conducteur' : 'عنوان السائق',
                                  constat.vehiculeA.adresseConducteur,
                                  enFrancais,
                              ),
                              _ligne(
                                  enFrancais ? 'N° permis' : 'رقم الرخصة',
                                  constat.vehiculeA.numPermis,
                                  enFrancais,
                              ),
                              _ligne(
                                  enFrancais ? 'Date permis' : 'تاريخ الرخصة',
                                  _fmtDate(constat.vehiculeA.datePermis),
                                  enFrancais,
                              ),
                              _ligne(
                                  enFrancais ? 'Nom assuré' : 'اسم المؤمَّن له',
                                  constat.vehiculeA.nomAssure,
                                  enFrancais,
                              ),
                              _ligne(
                                  enFrancais ? 'Prénom assuré' : 'لقب المؤمَّن له',
                                  constat.vehiculeA.prenomAssure,
                                  enFrancais,
                              ),
                              _ligne(
                                  enFrancais ? 'Adresse assuré' : 'عنوان المؤمَّن له',
                                  constat.vehiculeA.adresseAssure,
                                  enFrancais,
                              ),
                              _ligne(
                                  enFrancais ? 'Tél assuré' : 'هاتف المؤمَّن له',
                                  constat.vehiculeA.numTel,
                                  enFrancais,
                              ),
                              _ligne(
                                  enFrancais ? 'Marque, Type' : 'العلامة، النوع',
                                  '${constat.vehiculeA.marque} ${constat.vehiculeA.type}',
                                  enFrancais,
                              ),
                              _ligne(
                                  enFrancais ? 'Sens suivi' : 'الاتجاه المتبع',
                                  constat.vehiculeA.sensSuivi,
                                  enFrancais,
                              ),
                              _ligne(
                                  enFrancais ? 'Venant de' : 'قادم من',
                                  constat.vehiculeA.venantDe,
                                  enFrancais,
                              ),
                              _ligne(
                                  enFrancais ? 'Allant à' : 'متجه إلى',
                                  constat.vehiculeA.allantA,
                                  enFrancais,
                              ),
                              _ligne(
                                  enFrancais ? 'Dégâts apparents' : 'الأضرار الظاهرة',
                                  constat.vehiculeA.degatsApparents,
                                  enFrancais,
                              ),
                              _ligne(
                                  enFrancais ? 'Observations' : 'ملاحظات',
                                  constat.vehiculeA.observations,
                                  enFrancais,
                              ),
                            ],
                            CouleursApp.fondVehiculeA2,
                            enFrancais,
                          ),
                          _carteSection(
                            enFrancais ? 'Véhicule B' : 'السيارة ب',
                            [
                              _ligne(
                                enFrancais ? 'Société d\'assurance' : 'شركة التأمين',
                                constat.vehiculeB.assurance,
                                enFrancais,
                              ),
                              _ligne(
                                enFrancais ? 'N° contrat' : 'رقم العقد',
                                constat.vehiculeB.numContrat,
                                enFrancais,
                              ),
                              _ligne(
                                enFrancais ? 'Agence' : 'الوكالة',
                                constat.vehiculeB.agence,
                                enFrancais,
                              ),
                              _ligne(
                                enFrancais ? 'Validité attestation' : 'صلاحية الشهادة',
                                '${_fmtDate(constat.vehiculeB.dateDebutAttestation)} - ${_fmtDate(constat.vehiculeB.dateFinAttestation)}',
                                enFrancais,
                              ),
                              _ligne(
                                enFrancais ? 'Nom conducteur' : 'اسم السائق',
                                constat.vehiculeB.nomConducteur,
                                enFrancais,
                              ),
                              _ligne(
                                enFrancais ? 'Prénom conducteur' : 'لقب السائق',
                                constat.vehiculeB.prenomConducteur,
                                enFrancais,
                              ),
                              _ligne(
                                enFrancais ? 'Adresse conducteur' : 'عنوان السائق',
                                constat.vehiculeB.adresseConducteur,
                                enFrancais,
                              ),
                              _ligne(
                                enFrancais ? 'N° permis' : 'رقم الرخصة',
                                constat.vehiculeB.numPermis,
                                enFrancais,
                              ),
                              _ligne(
                                enFrancais ? 'Date permis' : 'تاريخ الرخصة',
                                _fmtDate(constat.vehiculeB.datePermis),
                                enFrancais,
                              ),
                              _ligne(
                                enFrancais ? 'Nom assuré' : 'اسم المؤمَّن له',
                                constat.vehiculeB.nomAssure,
                                enFrancais,
                              ),
                              _ligne(
                                enFrancais ? 'Prénom assuré' : 'لقب المؤمَّن له',
                                constat.vehiculeB.prenomAssure,
                                enFrancais,
                              ),
                              _ligne(
                                enFrancais ? 'Adresse assuré' : 'عنوان المؤمَّن له',
                                constat.vehiculeB.adresseAssure,
                                enFrancais,
                              ),
                              _ligne(
                                enFrancais ? 'Tél assuré' : 'هاتف المؤمَّن له',
                                constat.vehiculeB.numTel,
                                enFrancais,
                              ),
                              _ligne(
                                enFrancais ? 'Marque, Type' : 'العلامة، النوع',
                                '${constat.vehiculeB.marque} ${constat.vehiculeB.type}',
                                enFrancais,
                              ),
                              _ligne(
                                enFrancais ? 'Sens suivi' : 'الاتجاه المتبع',
                                constat.vehiculeB.sensSuivi,
                                enFrancais,
                              ),
                              _ligne(
                                enFrancais ? 'Venant de' : 'قادم من',
                                constat.vehiculeB.venantDe,
                                enFrancais,
                              ),
                              _ligne(
                                enFrancais ? 'Allant à' : 'متجه إلى',
                                constat.vehiculeB.allantA,
                                enFrancais,
                              ),
                              _ligne(
                                enFrancais ? 'Dégâts apparents' : 'الأضرار الظاهرة',
                                constat.vehiculeB.degatsApparents,
                                enFrancais,
                              ),
                              _ligne(
                                enFrancais ? 'Observations' : 'ملاحظات',
                                constat.vehiculeB.observations,
                                enFrancais,
                              ),
                            ],
                            CouleursApp.fondVehiculeB2,
                            enFrancais,
                          ),
                          _carteSection(
                            enFrancais ? 'Circonstances' : 'الظروف',
                            [
                              _ligne(
                                  enFrancais ? 'Véhicule A' : 'المركبة "أ"',
                                  '${constat.circonstancesA.where((v) => v).length} / 17',
                                  enFrancais,
                              ),
                              _ligne(
                                  enFrancais ? 'Véhicule B' : 'المركبة "ب"',
                                  '${constat.circonstancesB.where((v) => v).length} / 17',
                                  enFrancais,
                              ),
                            ],
                            CouleursApp.alerte,
                            enFrancais,
                          ),
                          if((constat.vehiculeA.imagePointChoc != null) && (constat.vehiculeB.imagePointChoc != null))
                            _carteSection(
                              enFrancais ? 'Points de choc initial' : 'نقاط الصدمة الأولية',
                              [
                                Container(
                                  margin: const EdgeInsets.only(top: 4),
                                  padding: const EdgeInsets.all(8),
                                  height: 160,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(12),
                                          child: Image.memory(
                                            constat.vehiculeA.imagePointChoc!,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(12),
                                          child: Image.memory(
                                            constat.vehiculeB.imagePointChoc!,
                                            fit: BoxFit.contain,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                              CouleursApp.bordure2,
                              enFrancais,
                            ),
                          if(constat.croquis != null)
                            _carteSection(
                              enFrancais ? 'Croquis de l\'accident' : 'رسم توضيحي للحادث',
                              [
                                Container(
                                  margin: const EdgeInsets.only(bottom: 16),
                                  height: 160,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: CouleursApp.bordure2),
                                  ),
                                  child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: Image.memory(
                                          constat.croquis!,
                                          fit: BoxFit.contain,
                                      ),
                                    ),
                                ),
                              ],
                              CouleursApp.bordure2,
                              enFrancais,
                            ),
                        ],
                      ),
                    ),
                  ),
                  BoutonPrincipal(
                    label: enCoursDeGeneration
                        ? (enFrancais ? 'Génération...' : 'جارٍ الإنشاء...')
                        : (enFrancais ? 'Générer le PDF' : 'تنزيل PDF'),
                    couleur: CouleursApp.succes,
                    click: enCoursDeGeneration ? null : _telechargerPdf,
                    enFrancais: enFrancais,
                  ),
                ],
              ),
          ),
        ),
    );
  }
}