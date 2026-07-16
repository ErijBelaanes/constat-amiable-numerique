import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../theme/couleurs.dart';

//Ce widget affiche le schéma d'une voiture et place une flèche sur l'endroit où l'utilisateur a touché/cliqué
//puis capture une image de ce schéma annoté pour pouvoir l'insérer plus tard dans un PDF
class ChampPointChoc extends StatefulWidget {
  final Offset? valeurInitiale;
  final Function(Offset, Uint8List?) pointChoisi;

  const ChampPointChoc({
    super.key,
    required this.valeurInitiale,
    required this.pointChoisi,
  });

  @override
  State <ChampPointChoc> createState() => _ChampPointChocState();
}

class _ChampPointChocState extends State <ChampPointChoc> {
  Offset? valeurPoint;

  final GlobalKey _cleCapture = GlobalKey();

  @override
  void initState() {
    super.initState();
    valeurPoint = widget.valeurInitiale;
  }

  Future<void> _gererTap(TapDownDetails details, BoxConstraints contraintes) async{
    setState(() {
      valeurPoint = Offset(
        details.localPosition.dx / contraintes.maxWidth, //Position horizontale
        details.localPosition.dy / contraintes.maxHeight, //Position Verticale
      );
    });
    final image = await capturerImage();
    widget.pointChoisi(valeurPoint!, image);
  }

  Future<Uint8List?> capturerImage() async {
    //Capture de l'image actuelle, appelée plus tard au moment de générer le PDF
    final boundary = _cleCapture.currentContext
        ?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) return null;
    final image = await boundary.toImage(pixelRatio: 2.0);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData?.buffer.asUint8List(); //Retourne les bytes utilisables pour créer un PDF
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        RepaintBoundary(
          key: _cleCapture,
          child: Container(
            decoration: BoxDecoration(
              color: CouleursApp.champ,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: CouleursApp.bordure2, width: 1.5),
            ),
            padding: const EdgeInsets.all(16),
            child: AspectRatio(
              aspectRatio: 1.4,
              child: LayoutBuilder(
                builder: (context, contraintes) {
                  return GestureDetector(
                    onTapDown: (details) => _gererTap(details, contraintes),
                    child: AspectRatio(
                      aspectRatio: 1.4,
                      child: LayoutBuilder(
                        builder: (context, contraintesImage) {
                          return Stack(
                            children: [
                              Image.asset(
                                'assets/images/schema_vehicule.png',
                                fit: BoxFit.contain,
                                width: double.infinity,
                                height: double.infinity,
                              ),

                              //La flèche du choc
                              if (valeurPoint != null)
                                Positioned(
                                  left: valeurPoint!.dx *
                                      contraintesImage.maxWidth - 14,
                                  //Position horizontale de la flèche
                                  top: valeurPoint!.dy *
                                      contraintesImage.maxHeight - 14,
                                  //Position verticale de la flèche
                                  child: Icon(
                                    Icons.close_rounded,
                                    color: CouleursApp.alerte,
                                    size: 28,
                                  ),
                                ),
                            ],
                          );
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}