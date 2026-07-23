import 'package:flutter/services.dart' show rootBundle;
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../models/constat_model.dart';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:arabic_reshaper/arabic_reshaper.dart';


class GenerateurPDF {

  //Variables globales pour stocker les polices
  static pw.Font? _maFontFr;
  static pw.Font? _maFontAr;
  static Future<void> _chargerPolices() async {
    if ((_maFontFr != null) && (_maFontAr != null)) return; // Déjà chargées

    final fontDataFr = await rootBundle.load("fonts/PlayfairDisplay-VariableFont_wght.ttf");
    final fontDataAr = await rootBundle.load("fonts/NotoNaskhArabic-VariableFont_wght.ttf");

    _maFontFr = pw.Font.ttf(fontDataFr);
    _maFontAr = pw.Font.ttf(fontDataAr);
  }

  static Future<pw.MemoryImage> _chargerImageDeFond() async {
    final pdfBytes = (await rootBundle.load('assets/images/constat-fr.pdf')).buffer.asUint8List();

    final page = await Printing.raster(pdfBytes, dpi: 200).first;
    final imageBytes = await page.toPng();

    return pw.MemoryImage(imageBytes);
  }

  static final ArabicReshaper _reshaper = ArabicReshaper();

  static String _formaterTexte(String texte, bool enFrancais) {
    if (enFrancais || texte.isEmpty) return texte;
    return _reshaper.reshape(texte);
  }



  static pw.Widget _texteSurModele(
      bool enFrancais,
      String texte,
      pw.Font ? font, {
        required double x,
        required double y,
        double largeurMax = 160,
      }) {
    return pw.Positioned(
      left: x,
      top: y,
      child: pw.SizedBox(
        width: largeurMax,
        child: pw.Text(
          _formaterTexte(texte, enFrancais),
          textDirection: enFrancais ? pw.TextDirection.ltr : pw.TextDirection.rtl,
          textAlign: enFrancais ? pw.TextAlign.left : pw.TextAlign.right,
          style: pw.TextStyle(
            fontWeight: pw.FontWeight.bold,
            fontSize: enFrancais ? 9 : 8,
            font: font,
          ),
        ),
      ),
    );
  }

  static pw.Widget _image(
      Uint8List bytes,
      double largeur,
      double hauteur, {
        required double x,
        required double y,
      }) {
    return pw.Positioned(
      left: x,
      top: y,
      child: pw.Container(
        width: largeur,
        height: hauteur,
        child: pw.Image(
          pw.MemoryImage(bytes),
          fit: pw.BoxFit.contain,
        ),
      ),
    );
  }

  static String _fmtDate(DateTime? d) => (d == null) ? '' : '${d.day}/${d.month}/${d.year}';

  static String _fmtHeure(DateTime? d) => (d == null) ? '' : '${d.hour}:${d.minute.toString().padLeft(2, '0')}';

  static String _texteTemoins(ConstatModel c) {
    if (!c.temoins || c.listeTemoins.isEmpty) return '';
    return c.listeTemoins
        .map((t) => '${t.nom} ${t.prenom} (${t.numTel})').join('\n');
  }
  static final double _largeurPage = PdfPageFormat.a4.width;
  static final double _hauteurPage = PdfPageFormat.a4.height;

  // --- Bandeau du haut ---
  static const _posDate = Offset(25, 95);
  static const _posHeure = Offset(150, 95);
  static const _posLieu = Offset(200, 95);
  static const _posBlessesOui = Offset(500, 93);
  static const _posBlessesNon = Offset(455, 93);
  static const _posDegatsOui = Offset(115, 137);
  static const _posDegatsNon = Offset(60, 137);
  static const _posTemoins = Offset(200, 125);   //Zone libre pour la liste des témoins

  //Véhicule A (colonne gauche)
  // static const _ax = 80.0;  // abscisse commune à tous les champs du véhicule A
  static const _posA_assurance = Offset(125, 200);
  static const _posA_numContrat = Offset(150, 215);
  static const _posA_agence = Offset(65, 234);
  static const _posA_attestationDebut = Offset(46, 270);
  static const _posA_attestationFin = Offset(150, 270);

  static const _posA_nomConducteur = Offset(80, 304);
  static const _posA_prenomConducteur = Offset(80, 323);
  static const _posA_adresseConducteur = Offset(57, 339);
  static const _posA_numPermis = Offset(150, 357);
  static const _posA_datePermis = Offset(80, 374);

  static const _posA_nomAssure = Offset(80, 410);
  static const _posA_prenomAssure = Offset(80, 426);
  static const _posA_adresseAssure = Offset(57, 443);
  static const _posA_numTel = Offset(150, 461);

  static const _posA_marqueType = Offset(110, 496);
  // static const _posA_numImmatriculation = Offset(150, 514);
  static const _posA_sensSuivi = Offset(100, 530);
  static const _posA_venantDe = Offset(100, 547);
  static const _posA_allantA = Offset(100, 565);
  static const _posA_pointChoc = Offset(25, 616);  //Zone image, ~90x70

  static const _posA_degatsApparents = Offset(20, 717);
  static const _posA_observations = Offset(20, 750);

  //Véhicule B (colonne droite)
  static const _posB_assurance = Offset(490, 200);
  static const _posB_numContrat = Offset(515, 215);
  static const _posB_agence = Offset(440, 234);
  static const _posB_attestationDebut = Offset(420, 269);
  static const _posB_attestationFin = Offset(500, 269);

  static const _posB_nomConducteur = Offset(440, 304);
  static const _posB_prenomConducteur = Offset(440, 323);
  static const _posB_adresseConducteur = Offset(440, 339);
  static const _posB_numPermis = Offset(515, 356);
  static const _posB_datePermis = Offset(450, 374);

  static const _posB_nomAssure = Offset(440, 410);
  static const _posB_prenomAssure = Offset(460, 426);
  static const _posB_adresseAssure = Offset(440, 444);
  static const _posB_numTel = Offset(515, 460);

  static const _posB_marqueType = Offset(470, 496);
  // static const _posB_numImmatriculation = Offset(440, 514);
  static const _posB_sensSuivi = Offset(470, 530);
  static const _posB_venantDe = Offset(470, 547);
  static const _posB_allantA = Offset(470, 565);
  static const _posB_pointChoc = Offset(460, 616);

  static const _posB_degatsApparents = Offset(440, 717);
  static const _posB_observations = Offset(340, 753);

  //Circonstances (colonne centrale) : une case A et une case B par ligne
  static const double _circY0 = 210; // hauteur de la 1ère ligne
  static const double _circEspacement = 20; // espacement vertical entre 2 lignes
  static const double _circXCaseA = 205;
  static const double _circXCaseB = 375;

  //Croquis (zone centrale, sous les circonstances) ---
  static const _posCroquis = Offset(250, 616);
  static const double _croquisLargeur = 350;
  static const double _croquisHauteur = 100;

  //Signature
  static const _posSignatureA = Offset(30, 780);
  static const _posSignatureB = Offset(500, 780);
  static const double _signatureLargeur = 140;
  static const double _signatureHauteur = 40;

  static Future<Uint8List> genererConstatSurModele(ConstatModel constat, VehiculeInfo vehiculeA, VehiculeInfo vehiculeB, bool enFrancais) async {
    await _chargerPolices();
    final imageFond = await _chargerImageDeFond();
    final doc = pw.Document();
    final font = enFrancais ? _maFontFr : _maFontAr;

    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.zero,
        build: (context) {
          return pw.Stack(
            children: [
              //Le fond == l'image du formulaire papier original
              pw.Positioned.fill(
                child: pw.Image(imageFond, fit: pw.BoxFit.fill),
              ),

              //Informations Communes
              _texteSurModele(
                enFrancais,
                (constat.dateAccident != null) ? '${constat.dateAccident!.day}/${constat.dateAccident!.month}/${constat.dateAccident!.year}'
                                               : '' ,
                font,
                x: _posDate.dx,
                y: _posDate.dy,
              ),
              _texteSurModele(
                enFrancais,
                _fmtHeure(constat.dateAccident),
                font,
                x: _posHeure.dx,
                y: _posHeure.dy,
              ),
              _texteSurModele(enFrancais, constat.lieuAccident, font, x: _posLieu.dx, y: _posLieu.dy),
              _texteSurModele(
                enFrancais,
                'X',
                font,
                x: (constat.blesses ? _posBlessesOui : _posBlessesNon).dx,
                y: (constat.blesses ? _posBlessesOui : _posBlessesNon).dy,
              ),
              _texteSurModele(
                enFrancais,
                'X',
                font,
                x: (constat.degatsMat ? _posDegatsOui : _posDegatsNon).dx,
                y: (constat.degatsMat ? _posDegatsOui : _posDegatsNon).dy,
              ),
              _texteSurModele(
                enFrancais,
                _texteTemoins(constat),
                font,
                x: _posTemoins.dx, y: _posTemoins.dy,
                largeurMax: 260,
              ),

              //Véhicule A
              _texteSurModele(
                enFrancais,
                vehiculeA.assurance,
                font,
                x: _posA_assurance.dx,
                y: _posA_assurance.dy,
              ),
              _texteSurModele(
                enFrancais,
                vehiculeA.numContrat,
                font,
                x: _posA_numContrat.dx,
                y: _posA_numContrat.dy,
              ),
              _texteSurModele(
                enFrancais,
                vehiculeA.agence,
                font,
                x: _posA_agence.dx,
                y: _posA_agence.dy,
              ),
              _texteSurModele(
                enFrancais,
                vehiculeA.assurance,
                font,
                x: _posA_assurance.dx,
                y: _posA_assurance.dy,
              ),
              _texteSurModele(
                enFrancais,
                _fmtDate(vehiculeA.dateDebutAttestation),
                font,
                x: _posA_attestationDebut.dx,
                y: _posA_attestationDebut.dy,
              ),
              _texteSurModele(
                enFrancais,
                _fmtDate(vehiculeA.dateFinAttestation),
                font,
                x: _posA_attestationFin.dx,
                y: _posA_attestationFin.dy,
              ),
              _texteSurModele(
                enFrancais,
                vehiculeA.nomConducteur,
                font,
                x: _posA_nomConducteur.dx,
                y: _posA_nomConducteur.dy,
              ),
              _texteSurModele(
                enFrancais,
                vehiculeA.prenomConducteur,
                font,
                x: _posA_prenomConducteur.dx,
                y: _posA_prenomConducteur.dy,
              ),
              _texteSurModele(
                enFrancais,
                vehiculeA.adresseConducteur,
                font,
                x: _posA_adresseConducteur.dx,
                y: _posA_adresseConducteur.dy,
              ),
              _texteSurModele(
                enFrancais,
                vehiculeA.numPermis,
                font,
                x: _posA_numPermis.dx,
                y: _posA_numPermis.dy,
              ),
              _texteSurModele(
                enFrancais,
                _fmtDate(vehiculeA.datePermis),
                font,
                x: _posA_datePermis.dx,
                y: _posA_datePermis.dy,
              ),
              _texteSurModele(
                enFrancais,
                vehiculeA.nomAssure,
                font,
                x: _posA_nomAssure.dx,
                y: _posA_nomAssure.dy,
              ),
              _texteSurModele(
                enFrancais,
                vehiculeA.prenomAssure,
                font,
                x: _posA_prenomAssure.dx,
                y: _posA_prenomAssure.dy,
              ),
              _texteSurModele(
                enFrancais,
                vehiculeA.adresseAssure,
                font,
                x: _posA_adresseAssure.dx,
                y: _posA_adresseAssure.dy,
              ),
              _texteSurModele(
                enFrancais,
                vehiculeA.numTel,
                font,
                x: _posA_numTel.dx,
                y: _posA_numTel.dy,
              ),
              _texteSurModele(
                enFrancais,
                '${vehiculeA.marque} ${vehiculeA.type}',
                font,
                x: _posA_marqueType.dx,
                y: _posA_marqueType.dy,
              ),
              _texteSurModele(
                enFrancais,
                vehiculeA.sensSuivi,
                font,
                x: _posA_sensSuivi.dx,
                y: _posA_sensSuivi.dy,
              ),
              _texteSurModele(
                enFrancais,
                vehiculeA.venantDe,
                font,
                x: _posA_venantDe.dx,
                y: _posA_venantDe.dy,
              ),
              _texteSurModele(
                enFrancais,
                vehiculeA.allantA,
                font,
                x: _posA_allantA.dx,
                y: _posA_allantA.dy,
              ),
              if(vehiculeA.pointChoc != null)
                _image(
                  vehiculeA.imagePointChoc!,
                  110,
                  130,
                  x: _posA_pointChoc.dx,
                  y: _posA_pointChoc.dy,
                ),
              _texteSurModele(
                enFrancais,
                vehiculeA.degatsApparents,
                font,
                x: _posA_degatsApparents.dx,
                y: _posA_degatsApparents.dy,
              ),
              _texteSurModele(
                enFrancais,
                vehiculeA.observations,
                font,
                x: _posA_observations.dx,
                y: _posA_observations.dy,
              ),

              //Véhicule B
              _texteSurModele(
                enFrancais,
                vehiculeB.assurance,
                font,
                x: _posB_assurance.dx,
                y: _posB_assurance.dy,
              ),
              _texteSurModele(
                enFrancais,
                vehiculeB.numContrat,
                font,
                x: _posB_numContrat.dx,
                y: _posB_numContrat.dy,
              ),
              _texteSurModele(
                enFrancais,
                vehiculeB.agence,
                font,
                x: _posB_agence.dx,
                y: _posB_agence.dy,
              ),
              _texteSurModele(
                enFrancais,
                vehiculeB.assurance,
                font,
                x: _posB_assurance.dx,
                y: _posB_assurance.dy,
              ),
              _texteSurModele(
                enFrancais,
                _fmtDate(vehiculeB.dateDebutAttestation),
                font,
                x: _posB_attestationDebut.dx,
                y: _posB_attestationDebut.dy,
              ),
              _texteSurModele(
                enFrancais,
                _fmtDate(vehiculeB.dateFinAttestation),
                font,
                x: _posB_attestationFin.dx,
                y: _posB_attestationFin.dy,
              ),
              _texteSurModele(
                enFrancais,
                vehiculeB.nomConducteur,
                font,
                x: _posB_nomConducteur.dx,
                y: _posB_nomConducteur.dy,
              ),
              _texteSurModele(
                enFrancais,
                vehiculeB.prenomConducteur,
                font,
                x: _posB_prenomConducteur.dx,
                y: _posB_prenomConducteur.dy,
              ),
              _texteSurModele(
                enFrancais,
                vehiculeB.adresseConducteur,
                font,
                x: _posB_adresseConducteur.dx,
                y: _posB_adresseConducteur.dy,
              ),
              _texteSurModele(
                enFrancais,
                vehiculeB.numPermis,
                font,
                x: _posB_numPermis.dx,
                y: _posB_numPermis.dy,
              ),
              _texteSurModele(
                enFrancais,
                _fmtDate(vehiculeB.datePermis),
                font,
                x: _posB_datePermis.dx,
                y: _posB_datePermis.dy,
              ),
              _texteSurModele(
                enFrancais,
                vehiculeB.nomAssure,
                font,
                x: _posB_nomAssure.dx,
                y: _posB_nomAssure.dy,
              ),
              _texteSurModele(
                enFrancais,
                vehiculeB.prenomAssure,
                font,
                x: _posB_prenomAssure.dx,
                y: _posB_prenomAssure.dy,
              ),
              _texteSurModele(
                enFrancais,
                vehiculeB.adresseAssure,
                font,
                x: _posB_adresseAssure.dx,
                y: _posB_adresseAssure.dy,
              ),
              _texteSurModele(
                enFrancais,
                vehiculeB.numTel,
                font,
                x: _posB_numTel.dx,
                y: _posB_numTel.dy,
              ),
              _texteSurModele(
                enFrancais,
                '${vehiculeB.marque} ${vehiculeB.type}',
                font,
                x: _posB_marqueType.dx,
                y: _posB_marqueType.dy,
              ),
              _texteSurModele(
                enFrancais,
                vehiculeB.sensSuivi,
                font,
                x: _posB_sensSuivi.dx,
                y: _posB_sensSuivi.dy,
              ),
              _texteSurModele(
                enFrancais,
                vehiculeB.venantDe,
                font,
                x: _posB_venantDe.dx,
                y: _posB_venantDe.dy,
              ),
              _texteSurModele(
                enFrancais,
                vehiculeB.allantA,
                font,
                x: _posB_allantA.dx,
                y: _posB_allantA.dy,
              ),
              if(vehiculeB.pointChoc != null)
                _image(
                  vehiculeB.imagePointChoc!,
                  110,
                  130,
                  x: _posB_pointChoc.dx,
                  y: _posB_pointChoc.dy,
                ),
              _texteSurModele(
                enFrancais,
                vehiculeB.degatsApparents,
                font,
                x: _posB_degatsApparents.dx,
                y: _posB_degatsApparents.dy,
              ),
              _texteSurModele(
                enFrancais,
                vehiculeB.observations,
                font,
                x: _posB_observations.dx,
                y: _posB_observations.dy,
              ),

              //Circonstances
              for(int i = 0; i < 17; i++) ...[
                if(constat.circonstancesA[i])
                  _texteSurModele(
                    enFrancais,
                    'X',
                    font,
                    x: _circXCaseA,
                    y: _circY0 + i * _circEspacement,
                    largeurMax: 20,
                  ),
                if(constat.circonstancesB[i])
                  _texteSurModele(
                    enFrancais,
                    'X',
                    font,
                    x: _circXCaseB,
                    y: _circY0 + i * _circEspacement,
                    largeurMax: 20,
                  ),
              ],

              //Croquis
              if(constat.croquis != null)
                _image(
                  constat.croquis!,
                  _croquisLargeur,
                  _croquisHauteur,
                  x: _posCroquis.dx,
                  y: _posCroquis.dy,
                ),

              //Signatures
              if(constat.signatureA != null)
                _image(
                  constat.signatureA!,
                  _signatureLargeur,
                  _signatureHauteur,
                  x: _posSignatureA.dx,
                  y: _posSignatureA.dy,
                ),
              if(constat.signatureB != null)
                _image(
                  constat.signatureB!,
                  _signatureLargeur,
                  _signatureHauteur,
                  x: _posSignatureB.dx,
                  y: _posSignatureB.dy,
                ),
            ],
          );
        },
      ),
    );
    return doc.save();
  }


}