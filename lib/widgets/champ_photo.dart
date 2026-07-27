import 'dart:typed_data';
import 'package:flutter/material.dart';
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
  final picker = ImagePicker();
  final fichier = await picker.pickImage(source: source, imageQuality: 80);
  if (fichier == null) return null;

  return fichier.readAsBytes();
}