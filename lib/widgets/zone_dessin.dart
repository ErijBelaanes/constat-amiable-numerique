import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '../theme/couleurs.dart';

class ZoneDessin extends StatefulWidget{
  final VoidCallback? change;  //Pour prévenir le parent d'un changement (utiles pour les boutons)
  final List<List<Offset>>? valeurInitiale;

  const ZoneDessin({
    super.key,
    this.change,
    this.valeurInitiale,
  });

  @override
  State<ZoneDessin> createState() => ZoneDessinState();
}

class ZoneDessinState extends State<ZoneDessin>{
  final GlobalKey _cleCapture = GlobalKey();
  late final List<List<Offset>> traits;  //Liste de plusieurs traits/Un trait = liste de points
  List<Offset>? traitEnCours;  //Une fois le doigt est levé, traitEnCours = null
  bool get aDesTraits => traits.isNotEmpty;

  get validerCroquis => null;  //Getter pour savoir s'il y a des traits à annuler/effacer

  @override
  void initState(){
    super.initState();
    traits = (widget.valeurInitiale != null)
        ? widget.valeurInitiale!.map((trait) => List<Offset>.from(trait)).toList()
        : [];
  }
  //Méthode appelée une fois le doigt touche l'écran
  void commmencerTrait(DragStartDetails details){
    setState(() {
      traitEnCours = [details.localPosition];
      traits.add(traitEnCours!);
    });
    widget.change?.call();
  }

  //Méthode appelée pour enregistrer chaque déplacement du doigt
  void continuerTrait(DragUpdateDetails details){
    setState(() {
      traitEnCours?.add(details.localPosition);
    });
    widget.change?.call();
  }

  //Méthode appelée une fois le doigt est levé
  void terminerTrait(DragEndDetails details){
    setState(() {
      traitEnCours = null;
    });
    widget.change?.call();
  }

  //Méthode pour effacer un trait
  void effacerTrait(){
    setState(() {
      traits.clear();
    });
    widget.change?.call();
  }

  //Méthode pour annuler le dernier trait
  void annulerTrait() {
    if (traits.isNotEmpty) {
      setState(() {
        traits.removeLast();
      });
    }
  }

  Future<Uint8List?> capturerImageDessin() async {
    //Capture de l'image actuelle, appelée plus tard au moment de générer le PDF
    final boundary = _cleCapture.currentContext?.findRenderObject() as RenderRepaintBoundary?;
    if (boundary == null) return null;
    final image = await boundary.toImage(pixelRatio: 2.0);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    return byteData?.buffer.asUint8List(); //Retourne les bytes utilisables pour créer un PDF
  }

  @override
  Widget build(BuildContext context){
    return RepaintBoundary(
      key: _cleCapture,
      child: Container(
        decoration: BoxDecoration(
          color: CouleursApp.champ,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: CouleursApp.bordure2,
            width: 1.5,
          ),
        ),
        padding: const EdgeInsets.all(16),
        clipBehavior: Clip.antiAlias,
        child: GestureDetector(
          onPanStart: commmencerTrait,
          onPanUpdate: continuerTrait,
          onPanEnd: terminerTrait,
          child: AspectRatio(
            aspectRatio: 1.4,
            child: CustomPaint(
              painter: PeintreCroquis(traits),
              size: Size.infinite,
            ),
        ),
      ),
     ),
    );
  }
}

//PeintreCroquis est une classe qui sait comment dessiner les traits sur le canvas.
class PeintreCroquis extends CustomPainter{
  final List<List<Offset>> traits;
  const PeintreCroquis(this.traits);

  @override
  void paint(Canvas canvas, Size size){
    final peinture = Paint()
        ..color = Colors.black
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;

    for(final t in traits){
      for(int i = 0; i<t.length -1; i++){
        canvas.drawLine(t[i], t[i+1], peinture);
      }
    }
  }

  //Méthode qui permet la modification des traits après leurs création/redessiner
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}