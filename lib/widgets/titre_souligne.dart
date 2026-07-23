import 'package:flutter/material.dart';

enum StyleLigne { solid, dashed, wavy }

class TitreSouligne extends StatelessWidget {
  final String texte;
  final TextStyle style;
  final Color couleurLigne;
  final double epaisseurLigne;
  final double espacement;  //Ecart réglable entre le texte et la ligne
  final StyleLigne styleLigne;

  const TitreSouligne({
    super.key,
    required this.texte,
    required this.style,
    required this.couleurLigne,
    this.epaisseurLigne = 3,
    this.espacement = 6,
    this.styleLigne = StyleLigne.solid,
  });

  @override
  Widget build(BuildContext context) {
    //IntrinsicWidth force la ligne à faire exactement la largeur du texte
    return IntrinsicWidth(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(texte, style: style, textAlign: TextAlign.center),
          SizedBox(height: espacement),
          SizedBox(
            height: epaisseurLigne * 3, // espace vertical pour la vague
            child: CustomPaint(
              painter: _PeintreLigne(
                couleur: couleurLigne,
                epaisseur: epaisseurLigne,
                style: styleLigne,
              ),
              child: const SizedBox(width: double.infinity),
            ),
          ),
        ],
      ),
    );
  }
}

class _PeintreLigne extends CustomPainter {
  final Color couleur;
  final double epaisseur;
  final StyleLigne style;

  _PeintreLigne({
    required this.couleur,
    required this.epaisseur,
    required this.style,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final peinture = Paint()
      ..color = couleur
      ..strokeWidth = epaisseur
      ..strokeCap = StrokeCap.round;

    final y = size.height / 2;

    switch (style) {
      case StyleLigne.solid:
        canvas.drawLine(Offset(0, y), Offset(size.width, y), peinture);
        break;

      case StyleLigne.dashed:
        const largeurTiret = 6.0;
        const espaceTiret = 4.0;
        double x = 0;
        while (x < size.width) {
          canvas.drawLine(
            Offset(x, y),
            Offset((x + largeurTiret).clamp(0, size.width), y),
            peinture,
          );
          x += largeurTiret + espaceTiret;
        }
        break;

      case StyleLigne.wavy:
        final amplitude = epaisseur * 1.2;
        final longueurOnde = epaisseur * 4;
        final chemin = Path()..moveTo(0, y);
        double x = 0;
        bool haut = true;
        while (x < size.width) {
          final xSuivant = (x + longueurOnde).clamp(0.0, size.width);
          chemin.quadraticBezierTo(
            x + longueurOnde / 2,
            haut ? y - amplitude : y + amplitude,
            xSuivant,
            y,
          );
          x = xSuivant;
          haut = !haut;
        }
        canvas.drawPath(
          chemin,
          peinture..style = PaintingStyle.stroke,
        );
        break;
    }
  }

  @override
  bool shouldRepaint(covariant _PeintreLigne oldDelegate) {
    return oldDelegate.couleur != couleur ||
        oldDelegate.epaisseur != epaisseur ||
        oldDelegate.style != style;
  }
}