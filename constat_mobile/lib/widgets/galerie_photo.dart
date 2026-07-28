import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../theme/couleurs.dart';
import '../utils/selecteur_image.dart';

//Gérer une liste de plusieurs photos sous forme de grille dynamique
class GaleriePhotos extends StatelessWidget {
  final List<Uint8List> photos;
  final ValueChanged<List<Uint8List>> changed;
  final bool enFrancais;

  const GaleriePhotos({
    super.key,
    required this.photos,
    required this.changed,
    required this.enFrancais,
  });

  Future<void> _ajouterPhoto(BuildContext context) async {
    final image = await capturerOuChoisirImage(context, enFrancais);
    if (image != null) {
      changed([...photos, image]);
    }
  }

  void _supprimerPhoto(int index) {
    final nouvellesPhotos = [...photos]..removeAt(index);
    changed(nouvellesPhotos);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (int i = 0; i < photos.length; i++)
              Stack(
                clipBehavior: Clip.none,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.memory(
                      photos[i],
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    top: -8,
                    right: -8,
                    child: GestureDetector(
                      onTap: () => _supprimerPhoto(i),
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: const BoxDecoration(
                            color: CouleursApp.texteSecondaire,
                            shape: BoxShape.circle,
                        ),
                        child: const Icon(
                            Icons.close_rounded,
                            size: 16,
                            color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            GestureDetector(
              onTap: () => _ajouterPhoto(context),
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: CouleursApp.champ,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: CouleursApp.bordure2, width: 1.5),
                ),
                child: const Icon(Icons.add_a_photo_outlined, color: CouleursApp.texte),
              ),
            ),
          ],
        ),
      ],
    );
  }
}