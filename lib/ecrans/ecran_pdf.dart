import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';
import '../theme/couleurs.dart';
import '../widgets/bouton_retour.dart';
import '../widgets/bouton_principal.dart';

class EcranPdf extends StatefulWidget {
  final Uint8List pdfBytes;
  final bool enFrancais;

  const EcranPdf({
    super.key,
    required this.pdfBytes,
    required this.enFrancais,
  });

  @override
  State<EcranPdf> createState() => _EcranPdfState();
}

class _EcranPdfState extends State<EcranPdf> {
  bool enCoursDePartage = false;

  Future<void> _partagerPdf() async {
    setState(() => enCoursDePartage = true);
    try {
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/constat_amiable.pdf');
      await file.writeAsBytes(widget.pdfBytes);

      await SharePlus.instance.share(
        ShareParams(
          files: [XFile(file.path)],
          text: 'Constat amiable',
        ),
      );
    } catch (e) {
      debugPrint("Erreur partage PDF : $e");
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.enFrancais
                ? "Erreur lors du partage du PDF"
                : "خطأ أثناء مشاركة PDF",
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => enCoursDePartage = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: widget.enFrancais ? TextDirection.ltr : TextDirection.rtl,
      child: Scaffold(
        backgroundColor: CouleursApp.fond,
        body: SafeArea(
          child: Stack(
            fit: StackFit.expand,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20, top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Align(
                      alignment: widget.enFrancais ? Alignment.centerLeft : Alignment.centerRight,
                      child: const BoutonRetour(),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: CouleursApp.succes.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Icon(Icons.preview_rounded, color: CouleursApp.succes),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          widget.enFrancais ? "Aperçu du PDF" : "معاينة PDF",
                          textAlign: widget.enFrancais ? TextAlign.left : TextAlign.right,
                          textDirection: widget.enFrancais ? TextDirection.ltr : TextDirection.rtl,
                          style: TextStyle(
                            color: CouleursApp.succes,
                            fontWeight: FontWeight.bold,
                            fontSize: 24.0,
                            fontFamily: widget.enFrancais ? 'PlayfairDisplay' : 'NotoNaskhArabic',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: PdfPreview(
                          build: (format) async => widget.pdfBytes,
                          canChangePageFormat: false,
                          canChangeOrientation: false,
                          canDebug: false,
                          allowPrinting: false,
                          allowSharing: false,
                          scrollViewDecoration: BoxDecoration(
                            color: CouleursApp.fond,
                          ),
                          pdfPreviewPageDecoration: BoxDecoration(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    BoutonPrincipal(
                      label: enCoursDePartage
                          ? (widget.enFrancais ? 'Partage...' : 'جارٍ المشاركة...')
                          : (widget.enFrancais ? 'Partager le PDF' : 'مشاركة PDF'),
                      couleur: CouleursApp.succes,
                      click: enCoursDePartage ? null : _partagerPdf,
                      enFrancais: widget.enFrancais,
                    ),
                  ],
                ),
              ),
            ],
          )
        ),
      ),
    );
  }
}