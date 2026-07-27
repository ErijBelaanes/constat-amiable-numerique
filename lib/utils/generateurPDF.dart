import 'package:flutter/services.dart' show rootBundle;
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../models/constat_model.dart';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';

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

  static pw.Widget _texteSurModele(
      bool enFrancais,
      String texte,
      pw.Font ? font, {
        required double x,
        required double y,
        double largeurMax = 200,
      }) {
    return pw.Positioned(
      left: x,
      top: y,
      child: pw.SizedBox(
        width: largeurMax,
        child: pw.Text(
          texte,
          textDirection: enFrancais ? pw.TextDirection.ltr : pw.TextDirection.rtl,
          textAlign: enFrancais ? pw.TextAlign.left : pw.TextAlign.right,
          style: pw.TextStyle(
            fontWeight: pw.FontWeight.bold,
            fontSize: 11,
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

  static String _fmtDate(DateTime? d) => (d == null) ? '' : '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';

  static String _fmtHeure(DateTime? d) => (d == null) ? '' : '${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}';

  static pw.Widget _texteTemoins(ConstatModel c, bool enFrancais) {
    if (!c.temoins || c.listeTemoins.isEmpty) return pw.SizedBox();
    final texte = c.listeTemoins
        .map((t) => enFrancais
            ? '${t.nom} ${t.prenom} ( N° tel: ${t.numTel} / Adresse: ${t.adresse})'
            : '${t.nom} ${t.prenom} ( رقم الهاتف: ${t.numTel} / العنوان: ${t.adresse})'
        ).join('\n');

    return pw.FittedBox(
      child: pw.Text(
        texte,
        textDirection: enFrancais ? pw.TextDirection.ltr : pw.TextDirection.rtl,
        textAlign: enFrancais ? pw.TextAlign.left : pw.TextAlign.right,
        style: pw.TextStyle(
          fontWeight: pw.FontWeight.bold,
          fontSize: 11,
          font: enFrancais ? _maFontFr : _maFontAr,
        ),
      ),
    );
  }

  //Croquis (zone centrale, sous les circonstances) ---
  static const posCroquis = Offset(250, 616);
  static const double croquisLargeur = 350;
  static const double croquisHauteur = 100;

  //Signature
  static const posSignatureA = Offset(30, 780);
  static const posSignatureB = Offset(500, 780);
  static const double signatureLargeur = 140;
  static const double signatureHauteur = 40;


  static const positionsFR = Positions(
     // --- Bandeau du haut ---
    posDate: Offset(25, 95),
    posHeure: Offset(150, 95),
    posLieu: Offset(200, 95),
    posBlessesOui: Offset(500, 93),
    posBlessesNon: Offset(455, 93),
    posDegatsOui: Offset(113, 137),
    posDegatsNon: Offset(60, 135),
    posTemoins: Offset(200, 125),  //Zone libre pour la liste des témoins

     //Véhicule A (colonne gauche)
     posA_assurance: Offset(127, 197),
     posA_numContrat: Offset(147, 215),
     posA_agence: Offset(65, 232),
     posA_attestationDebut: Offset(46, 266),
     posA_attestationFin: Offset(138, 266),

     posA_nomConducteur: Offset(80, 302),
     posA_prenomConducteur: Offset(80, 321),
     posA_adresseConducteur: Offset(57, 336),
     posA_numPermis: Offset(150, 355),
     posA_datePermis: Offset(80, 372),

     posA_nomAssure: Offset(80, 406),
     posA_prenomAssure: Offset(80, 424),
     posA_adresseAssure: Offset(57, 441),
     posA_numTel: Offset(145, 458),

     posA_marqueType: Offset(105, 493),
     posA_numImmatriculation: Offset(140, 512),
     posA_sensSuivi: Offset(100, 530),
     posA_venantDe: Offset(100, 547),
     posA_allantA: Offset(100, 565),
     posA_pointChoc: Offset(27, 616),  //Zone image, ~90x70

     posA_degatsApparents: Offset(20, 717),
     posA_observations: Offset(20, 750),

     //Véhicule B (colonne droite)
     posB_assurance: Offset(490, 195),
     posB_numContrat: Offset(515, 215),
     posB_agence: Offset(440, 234),
     posB_attestationDebut: Offset(420, 269),
     posB_attestationFin: Offset(500, 269),

     posB_nomConducteur: Offset(440, 302),
     posB_prenomConducteur: Offset(440, 320),
     posB_adresseConducteur: Offset(440, 336),
     posB_numPermis: Offset(515, 356),
     posB_datePermis: Offset(450, 372),

     posB_nomAssure: Offset(440, 406),
     posB_prenomAssure: Offset(460, 424),
     posB_adresseAssure: Offset(440, 440),
     posB_numTel: Offset(515, 457),

     posB_marqueType: Offset(470, 493),
     posB_numImmatriculation: Offset(500, 512),
     posB_sensSuivi: Offset(470, 528),
     posB_venantDe: Offset(470, 547),
     posB_allantA: Offset(470, 565),
     posB_pointChoc: Offset(460, 612),

     posB_degatsApparents: Offset(440, 717),
     posB_observations: Offset(335, 753),

     circY0: 213,
     circEspacement: 20,
     circXCaseA: 205,
     circXCaseB: 375,
  );

  static const positionsAR = Positions(
    // --- Bandeau du haut ---
    posDate: Offset(-100, 95),
    posHeure: Offset(-5, 95),
    posLieu: Offset(225, 90),
    posBlessesOui: Offset(349, 93),
    posBlessesNon: Offset(280, 93),
    posDegatsOui: Offset(-46, 135),
    posDegatsNon: Offset(-115, 135),
    posTemoins: Offset(290, 125), //Zone libre pour la liste des témoins

    //Véhicule A (colonne gauche)
    posA_assurance: Offset(5, 195),
    posA_numContrat: Offset(12, 215),
    posA_agence: Offset(5, 233),
    posA_attestationDebut: Offset(-90, 266),
    posA_attestationFin: Offset(10, 266),

    posA_nomConducteur: Offset(-5, 302),
    posA_prenomConducteur: Offset(-5, 320),
    posA_adresseConducteur: Offset(25, 336),
    posA_numPermis: Offset(10, 355),
    posA_datePermis: Offset(-25, 371),

    posA_nomAssure: Offset(-5, 407),
    posA_prenomAssure: Offset(-5, 424),
    posA_adresseAssure: Offset(12, 440),
    posA_numTel: Offset(15, 459),

    posA_marqueType: Offset(5, 494),
    posA_numImmatriculation: Offset(8, 512),
    posA_sensSuivi: Offset(10, 528),
    posA_venantDe: Offset(10, 545),
    posA_allantA: Offset(10, 563),
    posA_pointChoc: Offset(25, 614),  //Zone image, ~90x70

    posA_degatsApparents: Offset(25, 717),
    posA_observations: Offset(90, 750),

    //Véhicule B (colonne droite)
    posB_assurance: Offset(390, 200),
    posB_numContrat: Offset(390, 215),
    posB_agence: Offset(390, 234),
    posB_attestationDebut: Offset(288, 269),
    posB_attestationFin: Offset(385, 269),

    posB_nomConducteur: Offset(360, 304),
    posB_prenomConducteur: Offset(360, 320),
    posB_adresseConducteur: Offset(390, 339),
    posB_numPermis: Offset(385, 356),
    posB_datePermis: Offset(340, 374),

    posB_nomAssure: Offset(360, 408),
    posB_prenomAssure: Offset(360, 426),
    posB_adresseAssure: Offset(390, 442),
    posB_numTel: Offset(340, 460),

    posB_marqueType: Offset(380, 493),
    posB_numImmatriculation: Offset(380, 511),
    posB_sensSuivi: Offset(380, 530),
    posB_venantDe: Offset(380, 547),
    posB_allantA: Offset(380, 565),
    posB_pointChoc: Offset(460, 614),

    posB_degatsApparents: Offset(392, 717),
    posB_observations: Offset(390, 753),

    circY0: 207,
    circEspacement: 22,
    circXCaseA: 193,
    circXCaseB: 363,
  );

  static List<pw.Widget> _dessinerVehicule({
    required bool enFrancais,
    required VehiculeInfo vehicule,
    required pw.Font? font,

    required Offset posAssurance,
    required Offset posNumContrat,
    required Offset posAgence,
    required Offset posAttestationDebut,
    required Offset posAttestationFin,

    required Offset posNomConducteur,
    required Offset posPrenomConducteur,
    required Offset posAdresseConducteur,
    required Offset posNumPermis,
    required Offset posDatePermis,

    required Offset posNomAssure,
    required Offset posPrenomAssure,
    required Offset posAdresseAssure,
    required Offset posNumTel,

    required Offset posMarqueType,
    required Offset posNumImmatriculation,
    required Offset posSensSuivi,
    required Offset posVenantDe,
    required Offset posAllantA,

    required Offset posPointChoc,
    required Offset posDegatsApparents,
    required Offset posObservations,
  }) {
    return [
      _texteSurModele(
        enFrancais,
        vehicule.assurance,
        font,
        x: posAssurance.dx,
        y: posAssurance.dy,
      ),

      _texteSurModele(
        enFrancais,
        vehicule.numContrat,
        font,
        x: posNumContrat.dx,
        y: posNumContrat.dy,
      ),

      _texteSurModele(
        enFrancais,
        vehicule.agence,
        font,
        x: posAgence.dx,
        y: posAgence.dy,
      ),

      _texteSurModele(
        enFrancais,
        _fmtDate(vehicule.dateDebutAttestation),
        font,
        x: posAttestationDebut.dx,
        y: posAttestationDebut.dy,
      ),

      _texteSurModele(
        enFrancais,
        _fmtDate(vehicule.dateFinAttestation),
        font,
        x: posAttestationFin.dx,
        y: posAttestationFin.dy,
      ),

      _texteSurModele(
        enFrancais,
        vehicule.nomConducteur,
        font,
        x: posNomConducteur.dx,
        y: posNomConducteur.dy,
      ),

      _texteSurModele(
        enFrancais,
        vehicule.prenomConducteur,
        font,
        x: posPrenomConducteur.dx,
        y: posPrenomConducteur.dy,
      ),

      _texteSurModele(
        enFrancais,
        vehicule.adresseConducteur,
        font,
        x: posAdresseConducteur.dx,
        y: posAdresseConducteur.dy,
      ),

      _texteSurModele(
        enFrancais,
        vehicule.numPermis,
        font,
        x: posNumPermis.dx,
        y: posNumPermis.dy,
      ),

      _texteSurModele(
        enFrancais,
        _fmtDate(vehicule.datePermis),
        font,
        x: posDatePermis.dx,
        y: posDatePermis.dy,
      ),

      _texteSurModele(
        enFrancais,
        vehicule.nomAssure,
        font,
        x: posNomAssure.dx,
        y: posNomAssure.dy,
      ),

      _texteSurModele(
        enFrancais,
        vehicule.prenomAssure,
        font,
        x: posPrenomAssure.dx,
        y: posPrenomAssure.dy,
      ),

      _texteSurModele(
        enFrancais,
        vehicule.adresseAssure,
        font,
        x: posAdresseAssure.dx,
        y: posAdresseAssure.dy,
      ),

      _texteSurModele(
        enFrancais,
        vehicule.numTel,
        font,
        x: posNumTel.dx,
        y: posNumTel.dy,
      ),

      _texteSurModele(
        enFrancais,
        '${vehicule.marque} ${vehicule.type}',
        font,
        x: posMarqueType.dx,
        y: posMarqueType.dy,
      ),

      _texteSurModele(
        enFrancais,
        vehicule.numImmatriculation,
        font,
        x: posNumImmatriculation.dx,
        y: posNumImmatriculation.dy,
      ),

      _texteSurModele(
        enFrancais,
        vehicule.sensSuivi,
        font,
        x: posSensSuivi.dx,
        y: posSensSuivi.dy,
      ),

      _texteSurModele(
        enFrancais,
        vehicule.venantDe,
        font,
        x: posVenantDe.dx,
        y: posVenantDe.dy,
      ),

      _texteSurModele(
        enFrancais,
        vehicule.allantA,
        font,
        x: posAllantA.dx,
        y: posAllantA.dy,
      ),

      if (vehicule.imagePointChoc != null)
        _image(
          vehicule.imagePointChoc!,
          110,
          130,
          x: posPointChoc.dx,
          y: posPointChoc.dy,
        ),

      _texteSurModele(
        enFrancais,
        vehicule.degatsApparents,
        font,
        x: posDegatsApparents.dx,
        y: posDegatsApparents.dy,
      ),

      _texteSurModele(
        enFrancais,
        vehicule.observations,
        font,
        x: posObservations.dx,
        y: posObservations.dy,
      ),
    ];
  }
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
                x: enFrancais ? positionsFR.posDate.dx : positionsAR.posDate.dx,
                y: enFrancais ? positionsFR.posDate.dy : positionsAR.posDate.dy,
              ),
              _texteSurModele(
                enFrancais,
                _fmtHeure(constat.dateAccident),
                font,
                x: enFrancais ? positionsFR.posHeure.dx : positionsAR.posHeure.dx,
                y: enFrancais ? positionsFR.posHeure.dy : positionsAR.posHeure.dy,
              ),
              _texteSurModele(
                enFrancais,
                  constat.lieuAccident,
                  font,
                  x: enFrancais ? positionsFR.posLieu.dx : positionsAR.posLieu.dx,
                  y: enFrancais ? positionsFR.posLieu.dy : positionsAR.posLieu.dy,
              ),
              _texteSurModele(
                enFrancais,
                'X',
                font,
                x: (constat.blesses ? (enFrancais ? positionsFR.posBlessesOui : positionsAR.posBlessesOui)
                                    : (enFrancais ? positionsFR.posBlessesNon : positionsAR.posBlessesNon)
                  ).dx,
                y: (constat.blesses ? (enFrancais ? positionsFR.posBlessesOui : positionsAR.posBlessesOui)
                                    : (enFrancais ? positionsFR.posBlessesNon : positionsAR.posBlessesNon)
                  ).dy,
              ),
              _texteSurModele(
                enFrancais,
                'X',
                font,
                x: (constat.degatsMat ? (enFrancais ? positionsFR.posDegatsOui : positionsAR.posDegatsOui)
                                      : (enFrancais ? positionsFR.posDegatsNon : positionsAR.posDegatsNon)
                  ).dx,
                y: (constat.degatsMat ? (enFrancais ? positionsFR.posDegatsOui : positionsAR.posDegatsOui)
                                      : (enFrancais ? positionsFR.posDegatsNon : positionsAR.posDegatsNon)
                  ).dy,
              ),
              pw.Positioned(
                left: enFrancais ? positionsFR.posTemoins.dx : positionsAR.posTemoins.dx,
                top: enFrancais ? positionsFR.posTemoins.dy : positionsAR.posTemoins.dy,
                child: _texteTemoins(constat, enFrancais),
              ),

              //Véhicule A
              ..._dessinerVehicule(
                  enFrancais: enFrancais,
                  vehicule: vehiculeA,
                  font: font,
                  posAssurance: enFrancais ? positionsFR.posA_assurance : positionsAR.posA_assurance,
                  posNumContrat: enFrancais ? positionsFR.posA_numContrat : positionsAR.posA_numContrat,
                  posAgence: enFrancais ? positionsFR.posA_agence : positionsAR.posA_agence,
                  posAttestationDebut: enFrancais ? positionsFR.posA_attestationDebut : positionsAR.posA_attestationDebut,
                  posAttestationFin: enFrancais ? positionsFR.posA_attestationFin : positionsAR.posA_attestationFin,
                  posNomConducteur: enFrancais ? positionsFR.posA_nomConducteur : positionsAR.posA_nomConducteur,
                  posPrenomConducteur: enFrancais ? positionsFR.posA_prenomConducteur : positionsAR.posA_prenomConducteur,
                  posAdresseConducteur: enFrancais ? positionsFR.posA_adresseConducteur : positionsAR.posA_adresseConducteur,
                  posNumPermis: enFrancais ? positionsFR.posA_numPermis : positionsAR.posA_numPermis,
                  posDatePermis: enFrancais ? positionsFR.posA_datePermis : positionsAR.posA_datePermis,
                  posNomAssure: enFrancais ? positionsFR.posA_nomAssure : positionsAR.posA_nomAssure,
                  posPrenomAssure: enFrancais ? positionsFR.posA_prenomAssure : positionsAR.posA_prenomAssure,
                  posAdresseAssure: enFrancais ? positionsFR.posA_adresseAssure : positionsAR.posA_adresseAssure,
                  posNumTel: enFrancais ? positionsFR.posA_numTel : positionsAR.posA_numTel,
                  posMarqueType: enFrancais ? positionsFR.posA_marqueType : positionsAR.posA_marqueType,
                  posNumImmatriculation: enFrancais ? positionsFR.posA_numImmatriculation : positionsAR.posA_numImmatriculation,
                  posSensSuivi: enFrancais ? positionsFR.posA_sensSuivi : positionsAR.posA_sensSuivi,
                  posVenantDe: enFrancais ? positionsFR.posA_venantDe : positionsAR.posA_venantDe,
                  posAllantA: enFrancais ? positionsFR.posA_allantA : positionsAR.posA_allantA,
                  posPointChoc: enFrancais ? positionsFR.posA_pointChoc : positionsAR.posA_pointChoc,
                  posDegatsApparents: enFrancais ? positionsFR.posA_degatsApparents : positionsAR.posA_degatsApparents,
                  posObservations: enFrancais ? positionsFR.posA_observations : positionsAR.posA_observations,
              ),

              //Véhicule B
              ..._dessinerVehicule(
                enFrancais: enFrancais,
                vehicule: vehiculeB,
                font: font,
                posAssurance: enFrancais ? positionsFR.posB_assurance : positionsAR.posB_assurance,
                posNumContrat: enFrancais ? positionsFR.posB_numContrat : positionsAR.posB_numContrat,
                posAgence: enFrancais ? positionsFR.posB_agence : positionsAR.posB_agence,
                posAttestationDebut: enFrancais ? positionsFR.posB_attestationDebut : positionsAR.posB_attestationDebut,
                posAttestationFin: enFrancais ? positionsFR.posB_attestationFin : positionsAR.posB_attestationFin,
                posNomConducteur: enFrancais ? positionsFR.posB_nomConducteur : positionsAR.posB_nomConducteur,
                posPrenomConducteur: enFrancais ? positionsFR.posB_prenomConducteur : positionsAR.posB_prenomConducteur,
                posAdresseConducteur: enFrancais ? positionsFR.posB_adresseConducteur : positionsAR.posB_adresseConducteur,
                posNumPermis: enFrancais ? positionsFR.posB_numPermis : positionsAR.posB_numPermis,
                posDatePermis: enFrancais ? positionsFR.posB_datePermis : positionsAR.posB_datePermis,
                posNomAssure: enFrancais ? positionsFR.posB_nomAssure : positionsAR.posB_nomAssure,
                posPrenomAssure: enFrancais ? positionsFR.posB_prenomAssure : positionsAR.posB_prenomAssure,
                posAdresseAssure: enFrancais ? positionsFR.posB_adresseAssure : positionsAR.posB_adresseAssure,
                posNumTel: enFrancais ? positionsFR.posB_numTel : positionsAR.posB_numTel,
                posMarqueType: enFrancais ? positionsFR.posB_marqueType : positionsAR.posB_marqueType,
                posNumImmatriculation: enFrancais ? positionsFR.posB_numImmatriculation : positionsAR.posB_numImmatriculation,
                posSensSuivi: enFrancais ? positionsFR.posB_sensSuivi : positionsAR.posB_sensSuivi,
                posVenantDe: enFrancais ? positionsFR.posB_venantDe : positionsAR.posB_venantDe,
                posAllantA: enFrancais ? positionsFR.posB_allantA : positionsAR.posB_allantA,
                posPointChoc: enFrancais ? positionsFR.posB_pointChoc : positionsAR.posB_pointChoc,
                posDegatsApparents: enFrancais ? positionsFR.posB_degatsApparents : positionsAR.posB_degatsApparents,
                posObservations: enFrancais ? positionsFR.posB_observations : positionsAR.posB_observations,
              ),
              //Circonstances
              for(int i = 0; i < 17; i++) ...[
                if(constat.circonstancesA[i])
                  _texteSurModele(
                    enFrancais,
                    'X',
                    font,
                    x: enFrancais ? positionsFR.circXCaseA : positionsAR.circXCaseA,
                    y: enFrancais ? (positionsFR.circY0 + i * positionsFR.circEspacement)
                                  : (positionsAR.circY0 + i * positionsAR.circEspacement),
                    largeurMax: 20,
                  ),
                if(constat.circonstancesB[i])
                  _texteSurModele(
                    enFrancais,
                    'X',
                    font,
                    x: enFrancais ? positionsFR.circXCaseB : positionsAR.circXCaseB,
                    y: enFrancais ? (positionsFR.circY0 + i * positionsFR.circEspacement)
                                  : (positionsAR.circY0 + i * positionsAR.circEspacement),
                    largeurMax: 20,
                  ),
              ],

              //Croquis
              if(constat.croquis != null)
                _image(
                  constat.croquis!,
                  croquisLargeur,
                  croquisHauteur,
                  x: posCroquis.dx,
                  y: posCroquis.dy,
                ),

              //Signatures
              if(constat.signatureA != null)
                _image(
                  constat.signatureA!,
                  signatureLargeur,
                  signatureHauteur,
                  x: posSignatureA.dx,
                  y: posSignatureA.dy,
                ),
              if(constat.signatureB != null)
                _image(
                  constat.signatureB!,
                  signatureLargeur,
                  signatureHauteur,
                  x: posSignatureB.dx,
                  y: posSignatureB.dy,
                ),
            ],
          );
        },
      ),
    );

    //Photos de la scène et des dégâts, si au moins une photo existe
    final toutesLesPhotos = <_PhotoAvecLegende> [
      ...constat.photosScene.map((p) => _PhotoAvecLegende(
        bytes: p,
        legendeFr: 'Scène de l\'accident',
        legendeAr: 'مكان الحادث',
      )),

      ...vehiculeA.photosDegatsApparents.map((p) => _PhotoAvecLegende(
        bytes: p,
        legendeFr: 'Dégâts - Véhicule A',
        legendeAr: 'أضرار - المركبة أ',
      )),

      ...vehiculeB.photosDegatsApparents.map((p) => _PhotoAvecLegende(
        bytes: p,
        legendeFr: 'Dégâts - Véhicule B',
        legendeAr: 'أضرار - المركبة ب',
      )),
    ];
    if(toutesLesPhotos.isNotEmpty){
      doc.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(24),
          build: (context) {
            return [
              pw.Text(
                enFrancais ? 'Photos jointes' : 'الصور المرفقة',
                textDirection: enFrancais ? pw.TextDirection.ltr : pw.TextDirection.rtl,
                style: pw.TextStyle(
                  font: font,
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.SizedBox(height: 16),
              pw.Wrap(
                spacing: 12,
                runSpacing: 16,
                children: toutesLesPhotos.map((photo) {
                  return pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.center,
                    children: [
                      pw.Container(
                        width: 240,
                        height: 180,
                        decoration: pw.BoxDecoration(
                          border: pw.Border.all(width: 1),
                        ),
                        child: pw.Image(
                          pw.MemoryImage(photo.bytes),
                          fit: pw.BoxFit.cover,
                        ),
                      ),
                      pw.SizedBox(height: 4),
                      pw.Text(
                        enFrancais ? photo.legendeFr : photo.legendeAr,
                        textDirection: enFrancais ? pw.TextDirection.ltr : pw.TextDirection.rtl,
                        style: pw.TextStyle(
                          font: font,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  );
                }).toList(),
              ),
            ];
          },
        ),
      );
    }
    return doc.save();
  }
}

class Positions{
  final Offset posDate;
  final Offset posHeure;
  final Offset posLieu;
  final Offset posBlessesOui;
  final Offset posBlessesNon;
  final Offset posDegatsOui;
  final Offset posDegatsNon;
  final Offset posTemoins;

  final Offset posA_assurance;
  final Offset posA_numContrat;
  final Offset posA_agence;
  final Offset posA_attestationDebut;
  final Offset posA_attestationFin;

  final Offset posA_nomConducteur;
  final Offset posA_prenomConducteur;
  final Offset posA_adresseConducteur;
  final Offset posA_numPermis;
  final Offset posA_datePermis;

  final Offset posA_nomAssure;
  final Offset posA_prenomAssure;
  final Offset posA_adresseAssure;
  final Offset posA_numTel;

  final Offset posA_marqueType;
  final Offset posA_numImmatriculation;
  final Offset posA_sensSuivi;
  final Offset posA_venantDe;
  final Offset posA_allantA;
  final Offset posA_pointChoc;
  final Offset posA_degatsApparents;
  final Offset posA_observations;

  final Offset posB_assurance;
  final Offset posB_numContrat;
  final Offset posB_agence;
  final Offset posB_attestationDebut;
  final Offset posB_attestationFin;

  final Offset posB_nomConducteur;
  final Offset posB_prenomConducteur;
  final Offset posB_adresseConducteur;
  final Offset posB_numPermis;
  final Offset posB_datePermis;

  final Offset posB_nomAssure;
  final Offset posB_prenomAssure;
  final Offset posB_adresseAssure;
  final Offset posB_numTel;

  final Offset posB_marqueType;
  final Offset posB_numImmatriculation;
  final Offset posB_sensSuivi;
  final Offset posB_venantDe;
  final Offset posB_allantA;
  final Offset posB_pointChoc;
  final Offset posB_degatsApparents;
  final Offset posB_observations;

  final double circY0;
  final double circEspacement;
  final double circXCaseA;
  final double circXCaseB;

  const Positions({
    required this.posDate,
    required this.posHeure,
    required this.posLieu,
    required this.posBlessesOui,
    required this.posBlessesNon,
    required this.posDegatsOui,
    required this.posDegatsNon,
    required this.posTemoins,

    required this.posA_assurance,
    required this.posA_numContrat,
    required this.posA_agence,
    required this.posA_attestationDebut,
    required this.posA_attestationFin,

    required this.posA_nomConducteur,
    required this.posA_prenomConducteur,
    required this.posA_adresseConducteur,
    required this.posA_numPermis,
    required this.posA_datePermis,

    required this.posA_nomAssure,
    required this.posA_prenomAssure,
    required this.posA_adresseAssure,
    required this.posA_numTel,

    required this.posA_marqueType,
    required this.posA_numImmatriculation,
    required this.posA_sensSuivi,
    required this.posA_venantDe,
    required this.posA_allantA,
    required this.posA_pointChoc,
    required this.posA_degatsApparents,
    required this.posA_observations,

    required this.posB_assurance,
    required this.posB_numContrat,
    required this.posB_agence,
    required this.posB_attestationDebut,
    required this.posB_attestationFin,

    required this.posB_nomConducteur,
    required this.posB_prenomConducteur,
    required this.posB_adresseConducteur,
    required this.posB_numPermis,
    required this.posB_datePermis,

    required this.posB_nomAssure,
    required this.posB_prenomAssure,
    required this.posB_adresseAssure,
    required this.posB_numTel,

    required this.posB_marqueType,
    required this.posB_numImmatriculation,
    required this.posB_sensSuivi,
    required this.posB_venantDe,
    required this.posB_allantA,
    required this.posB_pointChoc,
    required this.posB_degatsApparents,
    required this.posB_observations,

    required this.circY0,
    required this.circEspacement,
    required this.circXCaseA,
    required this.circXCaseB,
  });

}

class _PhotoAvecLegende {
  final Uint8List bytes;
  final String legendeFr;
  final String legendeAr;

  const _PhotoAvecLegende({
    required this.bytes,
    required this.legendeFr,
    required this.legendeAr,
  });
}