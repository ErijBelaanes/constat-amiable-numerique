import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../theme/couleurs.dart';

//Affiche un menu "Caméra / Galerie" et renvoie les bytes de l'image choisie
Future<Uint8List?> capturerOuChoisirImage(BuildContext context, bool enFrancais) async {
  final source = await showModalBottomSheet<ImageSource>(
    context: context,
    backgroundColor: CouleursApp.fond,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (ctx) {
      return SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_camera_outlined, color: CouleursApp.texte),
              title: Text(
                enFrancais ? 'Prendre une photo' : 'التقط صورة',
                style: const TextStyle(color: CouleursApp.texte),
              ),
              onTap: () => Navigator.pop(ctx, ImageSource.camera),
            ),
            ListTile(
              leading: const Icon(Icons.photo_library_outlined, color: CouleursApp.texte),
              title: Text(
                enFrancais ? 'Choisir depuis la galerie' : 'اختر من المعرض',
                style: const TextStyle(color: CouleursApp.texte),
              ),
              onTap: () => Navigator.pop(ctx, ImageSource.gallery),
            ),
          ],
        ),
      );
    },
  );

  if (source == null) return null;
  try {
    print("Source choisie : $source");
    final fichier = await ImagePicker().pickImage(
      source: source,
      imageQuality: 80,
    );
    print("Fichier : $fichier");
    if (fichier == null) return null;

    return await fichier.readAsBytes();
  } on PlatformException catch (erreur) {
    // L'utilisateur doit être informé si une autorisation est refusée ou si
    // l'appareil ne propose pas la source demandée.
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            enFrancais
                ? 'Impossible d’ouvrir ${source == ImageSource.camera ? 'la caméra' : 'la galerie'} : ${erreur.message ?? 'vérifiez les autorisations'}.'
                : 'تعذر فتح ${source == ImageSource.camera ? 'الكاميرا' : 'المعرض'}.',
          ),
        ),
      );
    }
    return null;
  }
}
