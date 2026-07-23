import 'dart:math';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:provider/provider.dart';
import '../models/constat_model.dart';
import '../providers/constat_provider.dart';
import 'package:arabic_reshaper/arabic_reshaper.dart';
import 'package:intl/intl.dart' as intl;

class GenerateurPdf {
  static String ar(String texte) => texte;
  //Variables globales pour stocker les polices
  static pw.Font? _maFontFr;
  static pw.Font? _maFontAr;
  static pw.Widget _blocSignature(String lettre, Uint8List? image, bool enFrancais) {
    return pw.Container(
      width: double.infinity,
      child: pw.Column(
        children: [
          if(enFrancais)
            pw.Text(
              'Signature $lettre',
              textDirection: pw.TextDirection.ltr,
              style: pw.TextStyle(
                fontSize: 8,
                fontWeight: pw.FontWeight.bold,
                font: _maFontFr,
              ),
            )
          else
            pw.Directionality(
              textDirection: pw.TextDirection.rtl,
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                mainAxisSize: pw.MainAxisSize.min,
                children: [
                  pw.Text(
                    ar('توقيع السائق '),
                    style: pw.TextStyle(
                      fontSize: 8,
                      fontWeight: pw.FontWeight.bold,
                      font: _maFontAr,
                    ),
                  ),
                  pw.Text(
                    lettre,
                    style: pw.TextStyle(
                      fontSize: 8,
                      fontWeight: pw.FontWeight.bold,
                      font: _maFontAr,
                    ),
                  ),
                ],
              ),
            ),
          pw.SizedBox(height: 4),
          pw.Container(
            height: 70,
            width: double.infinity,
            decoration: pw.BoxDecoration(
              border: pw.Border.all(width: 0.5),
            ),
            child: (image != null && image.isNotEmpty)
                ? pw.Image(
              pw.MemoryImage(image),
              fit: pw.BoxFit.contain,
            )
                : null,
          ),
        ],
      ),
    );
  }
  //Méthode asynchrone pour charger les polices une seule fois
  static Future<void> _chargerPolices() async {
    if ((_maFontFr != null) && (_maFontAr != null)) return; // Déjà chargées

    final fontDataFr = await rootBundle.load("fonts/PlayfairDisplay-VariableFont_wght.ttf");
    final fontDataAr = await rootBundle.load("fonts/NotoNaskhArabic-VariableFont_wght.ttf");

    _maFontFr = pw.Font.ttf(fontDataFr);
    _maFontAr = pw.Font.ttf(fontDataAr);
  }

  static Future<Uint8List> genererConstat(BuildContext context, ConstatModel constat, VehiculeInfo vehiculeA, VehiculeInfo vehiculeB) async{
    try {
      await _chargerPolices();
      final doc = pw.Document();
      final provider = context.read<ConstatProvider>();
      final enFrancais = provider.enFrancais;

      doc.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(10),
          build: (context) =>
          [
            pw.Column(
              children: [
                _entete(enFrancais),
                pw.SizedBox(height: 8),
                _infosAccident(constat, enFrancais),
                pw.SizedBox(height: 4),

                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: enFrancais
                   ? [
                    //Version Française : Colonne A à droite, Circonstances au milieu, Colonne B à gauche
                    pw.Expanded(
                      flex: 3,
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                        children: [
                          _colonneVehicule(
                            'A',
                            vehiculeA,
                            const PdfColor.fromInt(0xFFFFECAA),
                            enFrancais,
                          ),
                          pw.SizedBox(height: 10),
                          _blocSignature('A', constat.signatureA, enFrancais),
                        ],
                      ),
                    ),
                    pw.SizedBox(width: 8),

                    pw.Expanded(
                      flex: 4,
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                        children: [
                          _colonneCirconstances(constat, enFrancais),
                          pw.SizedBox(height: 8),
                          _sectionCroquis(constat, enFrancais),
                        ],
                      ),
                    ),
                    pw.SizedBox(width: 8),

                    pw.Expanded(
                      flex: 3,
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                        children: [
                          _colonneVehicule(
                            'B',
                            vehiculeB,
                            PdfColor.fromInt(0xFFB3E5FC),
                            enFrancais,
                          ),
                          pw.SizedBox(height: 10),
                          _blocSignature('B', constat.signatureB, enFrancais),
                        ],
                      ),
                    ),
                   ]
                  : [
                    //Version Arabe : Colonne B à gauche, Circonstances au milieu, Colonne A à droite
                    pw.Expanded(
                      flex: 3,
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                        children: [
                          _colonneVehicule('ب', vehiculeB, PdfColor.fromInt(0xFFB3E5FC), enFrancais),
                          pw.SizedBox(height: 10),
                          _blocSignature('ب', constat.signatureB, enFrancais),
                        ],
                      ),
                    ),
                    pw.SizedBox(width: 8),
                    pw.Expanded(
                      flex: 4,
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                        children: [
                          _colonneCirconstances(constat, enFrancais),
                          pw.SizedBox(height: 8),
                          _sectionCroquis(constat, enFrancais),
                        ],
                      ),
                    ),
                    pw.SizedBox(width: 8),
                    pw.Expanded(
                      flex: 3,
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.stretch,
                        children: [
                          _colonneVehicule('أ', vehiculeA, const PdfColor.fromInt(0xFFFFECAA), enFrancais),
                          pw.SizedBox(height: 10),
                          _blocSignature('أ', constat.signatureA, enFrancais),
                        ],
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 5),
              ],
            ),
          ],
        ),
      );
      return doc.save();
    }catch(e, s) {
      debugPrint('Erreur génération PDF : $e');
      debugPrint(s.toString());
      rethrow;
    }
  }

  //En-tête
  static pw.Widget _entete(bool enFrancais){
    return pw.Column(
      crossAxisAlignment: enFrancais ? pw.CrossAxisAlignment.start : pw.CrossAxisAlignment.end,
      children: [
        pw.Text(
          enFrancais ? 'Constat amiable d\'accident automobile'
                     : ar('المعاينة الودية'),
          textDirection: enFrancais ? pw.TextDirection.ltr : pw.TextDirection.rtl,
          style: pw.TextStyle(
            fontWeight: pw.FontWeight.bold,
            fontSize: 20,
            font: enFrancais ? _maFontFr : _maFontAr,
          ),
        ),
        pw.Text(
          enFrancais ? 'Ne constitue pas une reconnaissance de responsabilité, mais un relevé des identités et des faits'
                     : ar('لا يُعد ذلك إقراراً بالمسؤولية، بل سجلاً للهويات والوقائع'),
          textDirection: enFrancais ? pw.TextDirection.ltr : pw.TextDirection.rtl,
          style: pw.TextStyle(
            color: PdfColor.fromInt(0xFFFF5252),
            fontWeight: pw.FontWeight.bold,
            fontSize: 12,
            font: enFrancais ? _maFontFr : _maFontAr,
          ),
        ),
        pw.Divider(thickness: 2),
      ],
    );
  }

  //Informations communes de l'accident
  static _infosAccident(ConstatModel c, bool enFrancais){
    final date = c.dateAccident;
    final String dateTexte = ((date == null) ? '' : (enFrancais ? '${date.day}/${date.month}/${date.year}' : '${date.year}/${date.month}/${date.day}'));
    final String heureTexte = ((date == null) ? '' : (enFrancais ? '${date.hour} : ${date.minute.toString().padLeft(2, '0')}' : '${date.minute.toString().padLeft(2, '0')} : ${date.hour}'));

    pw.Widget champ(
        String numero,
        String labelFr,
        String labelAr,
        String valeur,
        bool enFrancais,{
        bool valeurLTR = false,
    }){
      if(enFrancais){
        return pw.Text(
          '${numero.isEmpty ? '' : '$numero '}$labelFr$valeur',
          style: pw.TextStyle(
            fontSize: 9,
            font: _maFontFr,
          ),
        );
      }
      return pw.Directionality(
        textDirection: pw.TextDirection.rtl,
        child: pw.Row(
          mainAxisSize: pw.MainAxisSize.min,
          children: [
            if (numero.isNotEmpty)
              pw.Text(
                numero,
                textDirection: pw.TextDirection.ltr,
                style: pw.TextStyle(
                  fontSize: 9,
                  font: _maFontAr,
                ),
              ),

            if (numero.isNotEmpty)
              pw.SizedBox(width: 4),

            pw.Text(
              ar(labelAr),
              style: pw.TextStyle(
                fontSize: 9,
                font: _maFontAr,
              ),
            ),
            pw.SizedBox(width: 4),

            pw.Text(
              valeurLTR ? valeur : ar(valeur),
              textDirection: valeurLTR ? pw.TextDirection.ltr : pw.TextDirection.rtl,
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: 9,
                font: _maFontAr,
              ),
            ),
          ],
        ),
      );
    }

    return pw.Container(
        padding: const pw.EdgeInsets.all(8),
        decoration: pw.BoxDecoration(
          border: pw.Border.all(width: 0.5),
        ),
        child: pw.Column(
            crossAxisAlignment: enFrancais ? pw.CrossAxisAlignment.start : pw.CrossAxisAlignment.end,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: enFrancais ? [
                  champ('1.', 'Date: ', 'التاريخ: ', dateTexte, enFrancais, valeurLTR: true),
                  pw.SizedBox(width: 15),

                  champ('', 'Heure: ', 'الوقت: ', heureTexte, enFrancais, valeurLTR: true),
                  pw.SizedBox(width: 15),

                  champ('2.', 'Lieu: ', 'المكان: ', c.lieuAccident, enFrancais),
                ] : [
                  champ('2.', 'Lieu: ', 'المكان: ', c.lieuAccident, enFrancais),
                  pw.SizedBox(width: 15),

                  champ('', 'Heure: ', 'الوقت: ', heureTexte, enFrancais, valeurLTR: true),
                  pw.SizedBox(width: 15),

                  champ('1.', 'Date: ', 'التاريخ: ', dateTexte, enFrancais, valeurLTR: true),
                ],
              ),
            pw.SizedBox(height: 6),
            pw.Row(
              mainAxisAlignment: enFrancais ? pw.MainAxisAlignment.start : pw.MainAxisAlignment.end,
              children: enFrancais ? [
                champ('3.', 'Blessés: ', 'إصابات: ', c.blesses ? 'Oui' : 'Non', enFrancais),
                pw.SizedBox(width: 180),
                champ('4.', 'Dégâts matériels: ', 'أضرار مادية: ', c.degatsMat ? 'Oui' : 'Non', enFrancais),
              ] : [
                champ('4.', 'Dégâts matériels: ', 'أضرار مادية: ', c.degatsMat ? 'نعم' : 'لا', enFrancais),
                pw.SizedBox(width: 180),
                champ('3.', 'Blessés: ', 'إصابات: ', c.blesses ? 'نعم' : 'لا', enFrancais),
              ],
            ),
            pw.SizedBox(height: 6),

            pw.Column(
              crossAxisAlignment: enFrancais ? pw.CrossAxisAlignment.start : pw.CrossAxisAlignment.end,
              children: [
                champ('5.', 'Témoins: ', 'الشهود: ', c.temoins ? (enFrancais ? 'Oui' : 'نعم') : (enFrancais ? 'Non' : 'لا'), enFrancais),

                if (c.temoins && c.listeTemoins.isNotEmpty) ...[
                   pw.SizedBox(height: 5),
                   ...c.listeTemoins.map((t){
                     //Nom Prenom (Tél: ... / Adresse: ...)
                     final descriptionTemoin = enFrancais
                         ? '${t.nom} ${t.prenom} ( N° tel: ${t.numTel} / Adresse: ${t.adresse})'
                         : '${t.nom} ${t.prenom} ( رقم الهاتف: ${t.numTel} / العنوان: ${t.adresse})';
                     return pw.Padding(
                       padding: const pw.EdgeInsets.only(bottom: 3),
                       child: pw.Text(
                         descriptionTemoin,
                         textDirection: enFrancais ? pw.TextDirection.ltr : pw.TextDirection.rtl,
                         style: pw.TextStyle(
                           fontWeight: pw.FontWeight.bold,
                           fontSize: 9,
                           font: enFrancais ? _maFontFr : _maFontAr,
                         ),
                       ),
                     );
                   }),
                ],
              ],
            ),
          ],
        ),
    );
  }

  //Informations du véhicule
  static _colonneVehicule(String lettre, VehiculeInfo v, PdfColor fond, bool enFrancais){
    pw.Widget ligne(
      String label,
      String valeur,{
        bool valeurLTR = false,
      }) {
      if(enFrancais){
        return pw.Text(
          '$label$valeur',
          style: pw.TextStyle(
            fontWeight: pw.FontWeight.bold,
            fontSize: 9,
            font: _maFontFr,
          ),
        );
      }
      return pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.start,
        crossAxisAlignment: pw.CrossAxisAlignment.end,
        children: [
          pw.Text(
            label,
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              fontSize: 9,
              font: _maFontAr,
            ),
          ),
          pw.SizedBox(width: 3),

          pw.Text(
            valeurLTR ? valeur : ar(valeur),
            textDirection: valeurLTR ? pw.TextDirection.ltr : pw.TextDirection.rtl,
            style:pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              fontSize: 9,
              font: enFrancais ? _maFontFr : _maFontAr,
            ),
          ),
        ],
      );
    }
    String dateTexte(DateTime? d) => (d == null) ? '' : '${d.day}/${d.month}/${d.year}';
    return pw.Directionality(
      textDirection: enFrancais ? pw.TextDirection.ltr : pw.TextDirection.rtl,
      child: pw.Container(
      padding: const pw.EdgeInsets.all(8),
      decoration: pw.BoxDecoration(
        color: fond,
        border: pw.Border.all(width: 0.5),
      ),
      child: pw.Column(
        mainAxisSize: pw.MainAxisSize.min,
        crossAxisAlignment: enFrancais ? pw.CrossAxisAlignment.start : pw.CrossAxisAlignment.end,
        children: [
          pw.Center(
            child: enFrancais
                ? pw.Text(
                    'VÉHICULE $lettre',
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 11,
                      font: _maFontFr,
                    ),
                  )
                : pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.center,
                    mainAxisSize: pw.MainAxisSize.min,
                    children: [
                      pw.Text(
                        (lettre == 'أ') ? ar('المركبة أ') : ar('المركبة ب'),
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 11,
                          font: _maFontAr,
                        ),
                      ),
                    ],
                ),
          ),
          pw.SizedBox(height: enFrancais ? 4 : 2),
          pw.Container(
            width: double.infinity,
            alignment: enFrancais ? pw.Alignment.centerLeft : pw.Alignment.centerRight,
            child: pw.Text(
              enFrancais ? '6. Société d\'assurances' : ar('6. شركة التأمين'),
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: enFrancais ? 9 : 8,
                font: enFrancais ? _maFontFr : _maFontAr,
              ),
            ),
          ),
          pw.SizedBox(height: enFrancais ? 4 : 2),
          ligne(
              enFrancais ? 'Assureur: ' : 'المؤمن لديه: ',
              v.assurance,
          ),
          ligne(
              enFrancais ? 'N° contrat:  ' : 'رقم العقد: ',
              v.numContrat,
              valeurLTR: true,
          ),
          ligne(
              enFrancais ? 'Agence: ' : 'وكالة: ',
              v.agence,
          ),
          pw.Row(
            mainAxisAlignment: enFrancais ? pw.MainAxisAlignment.start : pw.MainAxisAlignment.end,
            children: enFrancais
             ? [
              pw.Text(
                "Valable de ",
                style: pw.TextStyle(
                  fontSize: enFrancais ? 9 : 8,
                  font: _maFontFr,
                ),
              ),
              pw.Text(
                dateTexte(v.dateDebutAttestation),
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: enFrancais ? 9 : 8,
                  font: _maFontFr,
                ),
              ),
              pw.Text(
                "au ",
                style: pw.TextStyle(
                fontSize: enFrancais ? 9 : 8,
                font: _maFontFr,
                ),
              ),
              pw.Text(
                dateTexte(v.dateFinAttestation),
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: enFrancais ? 9 : 8,
                  font: _maFontFr,
                ),
              ),
              ]
            : [
              pw.Text(
                "سارٍ اعتباراً من ",
                style: pw.TextStyle(
                  fontSize: enFrancais ? 9 : 8,
                  font: _maFontAr,
                ),
              ),
              pw.Text(
                dateTexte(v.dateDebutAttestation),
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: enFrancais ? 9 : 8,
                  font: _maFontAr,
                ),
              ),
              pw.Text(
                "إلى ",
                style: pw.TextStyle(
                  fontSize: enFrancais ? 9 : 8,
                  font: _maFontAr,
                ),
              ),
              pw.Text(
                dateTexte(v.dateFinAttestation),
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: enFrancais ? 9 : 8,
                  font: _maFontAr,
                ),
              ),
            ],
          ),
          pw.SizedBox(height: enFrancais ? 4 : 2),

          pw.Container(
            width: double.infinity,
            alignment: enFrancais ? pw.Alignment.centerLeft : pw.Alignment.centerRight,
            child: pw.Text(
              enFrancais ? '7. Identité du conducteur' : ar('7. هوية السائق'),
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: enFrancais ? 9 : 8,
                font: enFrancais ? _maFontFr : _maFontAr,
              ),
            ),
          ),
          pw.SizedBox(height: enFrancais ? 4 : 2),
          ligne(
              enFrancais ? 'Nom: ' : 'اسم السائق: ',
              v.nomConducteur,
          ),
          ligne(
              enFrancais ? 'Prénom: ' : 'لقب السائق: ',
              v.prenomConducteur,
          ),
          ligne(
              enFrancais ? 'Adresse: ' : 'عنوان السائق: ',
              v.adresseConducteur,
          ),
          ligne(
              enFrancais ? 'Permis N°: ' : 'رقم رخصة السياقة: ',
              v.numPermis,
              valeurLTR: true,
          ),
          ligne(
              enFrancais ? 'Délivré le' : 'تاريخ إصدار الرخصة',
              dateTexte(v.datePermis),
              valeurLTR: !enFrancais,
          ),
          pw.SizedBox(height: enFrancais ? 4 : 2),

          pw.Container(
            width: double.infinity,
            alignment: enFrancais ? pw.Alignment.centerLeft : pw.Alignment.centerRight,
            child: pw.Text(
              enFrancais ? '8. Assuré' : ar('8. المؤمَّن له'),
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: enFrancais ? 9 : 8,
                font: enFrancais ? _maFontFr : _maFontAr,
              ),
            ),
          ),
          pw.SizedBox(height: enFrancais ? 4 : 2),
          ligne(
              enFrancais ? 'Nom: ' : 'اسم المؤمَّن له: ',
              v.nomAssure,
          ),
          ligne(
            enFrancais ? 'Prénom: ' : 'لقب المؤمَّن له: ',
            v.prenomAssure,
          ),
          ligne(
            enFrancais ? 'Adresse: ' : 'عنوان المؤمَّن له: ',
            v.adresseAssure,
          ),
          ligne(
              enFrancais ? 'N° Tél: ' : 'رقم الهاتف: ',
              v.numTel,
              valeurLTR: true,
          ),
          pw.SizedBox(height: enFrancais ? 4 : 2),

          pw.Container(
            width: double.infinity,
            alignment: enFrancais ? pw.Alignment.centerLeft : pw.Alignment.centerRight,
            child: pw.Text(
              enFrancais ? '9. Identité du véhicule' : ar('9. هوية السيارة'),
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: enFrancais ? 9 : 8,
                font: enFrancais ? _maFontFr : _maFontAr,
              ),
            ),
          ),
          pw.SizedBox(height: enFrancais ? 4 : 2),
          ligne(
              enFrancais ? 'Marque, Type: ' : 'العلامة التجارية، نوع السيارة: ',
              '${v.marque} ${v.type}'
          ),
          ligne(
              enFrancais ? 'Sens suivi: ' : 'الاتجاه المتبع: ',
              v.sensSuivi
          ),
          ligne(
              enFrancais ? 'Venant de' : 'قادم من',
              v.venantDe
          ),
          ligne(
              enFrancais ? 'Allant à' : 'متجه إلى',
              v.allantA
          ),
          pw.SizedBox(height: enFrancais ? 4 : 2),

          if(v.imagePointChoc != null) ...[
            pw.Container(
              width: double.infinity,
              alignment: enFrancais ? pw.Alignment.centerLeft : pw.Alignment.centerRight,
              child: pw.Text(
                enFrancais ? '10. Point de choc initial' : ar('10. نقطة الاصطدام الأولية'),
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 9,
                  font: enFrancais ? _maFontFr : _maFontAr,
                ),
              ),
            ),
            pw.SizedBox(height: enFrancais ? 4 : 2),
            pw.Container(
              height: 70,
              width: double.infinity,
              alignment: pw.Alignment.center,
              child: pw.Image(
                pw.MemoryImage(v.imagePointChoc!),
                fit: pw.BoxFit.contain,
              ),
            ),
          ],
          pw.SizedBox(height: enFrancais ? 4 : 2),

          pw.Container(
            width: double.infinity,
            alignment: enFrancais ? pw.Alignment.centerLeft : pw.Alignment.centerRight,
            child: pw.Text(
              enFrancais ? '11. Dégâts apparents' : ar('11. الأضرار الظاهرة'),
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: 9,
                font: enFrancais ? _maFontFr : _maFontAr,
              ),
            ),
          ),
          pw.SizedBox(height: enFrancais ? 4 : 2),

          pw.Container(
            width: double.infinity,
            alignment: enFrancais ? pw.Alignment.centerLeft : pw.Alignment.centerRight,
            child: pw.Text(
              enFrancais ? v.degatsApparents : ar(v.degatsApparents),
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: 9,
                font: enFrancais ? _maFontFr : _maFontAr,
              ),
            ),
          ),
          pw.SizedBox(height: enFrancais ? 4 : 2),

          pw.Container(
            width: double.infinity,
            alignment: enFrancais ? pw.Alignment.centerLeft : pw.Alignment.centerRight,
            child: pw.Text(
              enFrancais ? '14. Observations' : ar('14. ملاحظات'),
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: 11,
                font: enFrancais ? _maFontFr : _maFontAr,
              ),
            ),
          ),
          pw.SizedBox(height: enFrancais ? 4 : 2),

          pw.Container(
            width: double.infinity,
            alignment: enFrancais ? pw.Alignment.centerLeft : pw.Alignment.centerRight,
            child: pw.Text(
              enFrancais ? v.observations : ar(v.observations),
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: 9,
                font: enFrancais ? _maFontFr : _maFontAr,
              ),
            ),
          ),
          pw.SizedBox(height: enFrancais ? 4 : 2),
        ],
      ),
     ),
    );
  }

  static const List<Map<String, String>> circonstances = [
    {'fr': 'En stationnement:', 'ar': 'كانت واقفة'},
    {'fr': 'Quittait un stationnement', 'ar': 'كانت تغادر موقف سيارات'},
    {'fr': 'Prenait un stationnement', 'ar': 'كانت بصدد الوقوف'},
    {'fr': "Sortait d'un parking, d'un lieu privé, d'un chemin de terre", 'ar': 'كانت خارجة من موقف أو مكان خاص أو طريق ترابي'},
    {'fr': "S'engageait dans un parking, un lieu privé, un chemin de terre", 'ar': 'كانت داخلة إلى موقف أو مكان خاص أو طريق ترابي'},
    {'fr': "Arrêt de circulation", 'ar': 'كانت متوقفة بسبب الحركة المرورية'},
    {'fr': 'Frottement sans changement de file', 'ar': 'احتكاك دون تغيير المسار'},
    {'fr': "Heurtait à l'arrière, en roulant dans le même sens et sur la même file", 'ar': 'اصطدمت من الخلف في نفس الاتجاه والمسار'},
    {'fr': 'Roulait dans le même sens et sur une file différente', 'ar': 'كانت تسير في نفس الاتجاه على مسار مختلف'},
    {'fr': 'Changeait de file', 'ar': 'كانت تغير المسار'},
    {'fr': 'Doublait', 'ar': 'كانت بصدد تجاوز'},
    {'fr': 'Virait à droite', 'ar': 'كانت تنعطف يمينًا'},
    {'fr': 'Virait à gauche', 'ar': 'كانت تنعطف يسارًا'},
    {'fr': 'Reculait', 'ar': 'كانت تتراجع'},
    {'fr': "Empiétait sur la partie de chaussée réservée à la circulation en sens inverse", 'ar': 'تجاوزت إلى الجزء المخصص للاتجاه المعاكس'},
    {'fr': 'Venait de droite (dans un carrefour)', 'ar': 'قادمة من اليمين (في تقاطع)'},
    {'fr': "N'avait pas observé le signal de priorité", 'ar': 'لم تحترم إشارة الأولوية'},
  ];
  static _colonneCirconstances(ConstatModel constat, bool enFrancais){
    return pw.Directionality(
        textDirection: enFrancais ? pw.TextDirection.ltr : pw.TextDirection.rtl,
        child: pw.Container(
          padding: const pw.EdgeInsets.all(6),
          decoration: pw.BoxDecoration(
            border: pw.Border.all(width: 0.5),
          ),
          child: pw.Column(
            mainAxisSize: pw.MainAxisSize.min,
            children: [
              pw.Center(
                child: enFrancais
                    ? pw.Text(
                  '12. Circonstances',
                  style: pw.TextStyle(
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 11,
                    font: _maFontFr,
                  ),
                )
                    : pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  mainAxisSize: pw.MainAxisSize.min,
                  children: [
                    pw.Text(
                      ar('12. الظروف'),
                      style: pw.TextStyle(
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 11,
                        font: _maFontAr,
                      ),
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 6),
              for(int i = 0; i < circonstances.length; i++)
                pw.Padding(
                  padding: const pw.EdgeInsets.only(bottom: 6),
                  child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: enFrancais ? [
                      //Case à gauche pour véhicule A
                      pw.Container(
                        width: 12,
                        height: 12,
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(width: 0.5),
                        ),
                        child: (constat.circonstancesA[i])
                            ? pw.Center(
                          child: pw.Text(
                            'X',
                            style: pw.TextStyle(
                              color: PdfColor.fromInt(0xFFFF5252),
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 7,
                              font: _maFontFr,
                            ),
                          ),
                        )
                            : null,
                      ),
                      pw.SizedBox(width: 4),
                      pw.Expanded(
                        child: pw.Container(
                          alignment: enFrancais ? pw.Alignment.centerLeft : pw
                              .Alignment.centerRight,
                          child: pw.Center(
                            child: pw.Text(
                              '${i + 1}. ${circonstances[i]['fr']!}',
                              textDirection: enFrancais
                                  ? pw.TextDirection.ltr
                                  : pw.TextDirection.rtl,
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 7,
                                font: _maFontFr,
                              ),
                            ),
                          )
                        ),
                      ),
                      pw.SizedBox(width: 4),

                      //Case à droite pour véhicule B
                      pw.Container(
                        width: 12,
                        height: 12,
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(width: 0.5),
                        ),
                        child: (constat.circonstancesB[i])
                            ? pw.Center(
                          child: pw.Text(
                            'X',
                            style: pw.TextStyle(
                              color: PdfColor.fromInt(0xFFFF5252),
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 8,
                              font: _maFontFr,
                            ),
                          ),
                        )
                            : null,
                      ),
                    ]
                        : [
                      //En arabe: Case à gauche pour véhicule B
                      pw.Container(
                        width: 12,
                        height: 12,
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(width: 0.5),
                        ),
                        child: (constat.circonstancesB[i])
                            ? pw.Center(
                          child: pw.Text(
                            'X',
                            style: pw.TextStyle(
                              color: PdfColor.fromInt(0xFFFF5252),
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 7,
                              font: _maFontFr,
                            ),
                          ),
                        )
                            : null,
                      ),
                      pw.SizedBox(width: 4),
                      pw.Expanded(
                        child: pw.Container(
                          alignment: enFrancais ? pw.Alignment.centerLeft : pw
                              .Alignment.centerRight,
                          child: pw.Center(
                            child: pw.Text(
                              '${i + 1}.  ${circonstances[i]['ar']!}',
                              textDirection: enFrancais
                                  ? pw.TextDirection.ltr
                                  : pw.TextDirection.rtl,
                              style: pw.TextStyle(
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 7,
                                font: _maFontAr,
                              ),
                            ),
                          ),
                        ),
                      ),
                      pw.SizedBox(width: 4),

                      //En arabe, Case à droite pour véhicule A
                      pw.Container(
                        width: 12,
                        height: 12,
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(width: 0.5),
                        ),
                        child: (constat.circonstancesB[i])
                            ? pw.Center(
                          child: pw.Text(
                            'X',
                            style: pw.TextStyle(
                              color: PdfColor.fromInt(0xFFFF5252),
                              fontWeight: pw.FontWeight.bold,
                              fontSize: 8,
                              font: _maFontFr,
                            ),
                          ),
                        )
                            : null,
                      ),
                    ],
                  ),
                ),
              pw.SizedBox(height: 4),
              pw.Text(
                enFrancais ? 'Total A : ${constat.circonstancesA
                    .where((v) => v)
                    .length}   Total B : ${constat.circonstancesB
                    .where((v) => v)
                    .length}'
                    : '${constat.circonstancesB
                    .where((v) => v)
                    .length} : B مجموع   ${constat.circonstancesA
                    .where((v) => v)
                    .length} : A مجموع',
                textDirection: enFrancais ? pw.TextDirection.ltr : pw
                    .TextDirection.rtl,
                style: pw.TextStyle(
                  fontSize: 8,
                  fontWeight: pw.FontWeight.bold,
                  font: enFrancais ? _maFontFr : _maFontAr,
                ),
              ),
            ],
          ),
        ),
    );
  }

  static _sectionCroquis(ConstatModel constat, bool enFrancais) {
    return pw.Directionality(
      textDirection: enFrancais ? pw.TextDirection.ltr : pw.TextDirection.rtl,

      child: pw.Container(
        decoration: pw.BoxDecoration(
          border: pw.Border.all(width: 0.5),
        ),
        padding: const pw.EdgeInsets.all(6),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Center(
              child: enFrancais
                  ? pw.Text(
                '13. Croquis de l\'accident',
                style: pw.TextStyle(
                  fontWeight: pw.FontWeight.bold,
                  fontSize: 11,
                  font: _maFontFr,
                ),
              )
                  : pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                mainAxisSize: pw.MainAxisSize.min,
                children: [
                  pw.Text(
                    ar('13. رسم تخطيطي للحادث'),
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 11,
                      font: _maFontAr,
                    ),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 4),
            pw.Container(
              height: 100,
              width: double.infinity,
              child: (constat.croquis != null)
                  ? pw.Image(
                pw.MemoryImage(constat.croquis!),
                fit: pw.BoxFit.contain,
              )
                  : pw.Center(
                child: pw.Text(
                  enFrancais ? '(Aucun croquis fourni)' : ar('(لم يتم تقديم أي رسم تخطيطي)'),
                  style: pw.TextStyle(
                    fontSize: 8,
                    fontWeight: pw.FontWeight.bold,
                    font: enFrancais ? _maFontFr : _maFontAr,
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