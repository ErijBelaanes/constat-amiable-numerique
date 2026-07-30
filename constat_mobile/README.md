# Constat Mobile

## Description:
**Constat Mobile** est une application Flutter _bilingue_ (Français / Arabe) permettant aux conducteurs de remplir un constat amiable d'accident automobile de manière numérique.

L'application guide l'utilisateur tout au long du processus de déclaration de l'accident et permet de générer un PDF officiel du constat.

## Sommaire
  - [Fonctionnalités](#1-fonctionnalites)
  - [Technologies utilisées](#2-technologies-utilisees)
  - [Organistation du code](#3-organisation-du-code)
  - [Captures d'écran](#4-captures-decran)
    - [Version Française](#a-version-francaise)
    - [Version Arabe](#b-version-arabe)
  - [Configuration](#5-configuration)

### 1. Fonctionnalités:
  a. Choix de la langue (Français / Arabe)
  b. Saisie des informations de l'accident
  c. Saisie des informations des véhicules A et B
  d. Sélection des circonstances
  e. Réalisation d'un croquis de l'accident
  f. Signature des deux conducteurs
  g. Génération du PDF du constat
  h. Partage du PDF du constat

### 2. Technologies utilisées:
  - Flutter
  - Dart 
  - Provider (Gestion d'état) 
  - CustomPaint (Gestion du croquis et signatures)
  - pdf
  - printing
  - share_plus

### 3. Organistation du code:
```text
  lib/
│
├── ecrans/
│   ├── ecran_accident.dart
│   ├── ecran_accueil.dart
│   ├── ecran_avertissement.dart
│   ├── ecran_circonstances.dart
│   ├── ecran_croquis.dart
│   ├── ecran_logo.dart
│   ├── ecran_pdf.dart
│   ├── ecran_recapitulatif.dart
│   ├── ecran_signatures.dart
│   └── ecran_vehicule.dart
│
├── models/
│   └── constat_model.dart
│
├── providers/
│   └── constat_provider.dart
│
├── services/
│   ├── service_api.dart
│   └── service_geolocalisation.dart
│ 
├── theme/
│   └── couleurs.dart
│ 
├── utils/
│   ├── arabic_reshaper.dart
│   ├── dialogues.dart
│   ├── generateur_pdf.dart
│   ├── generateurPdf.dart
│   ├── localisation.dart
│   └── selecteur_image.dart
│
├── widgets/
│   ├── bouton_principal.dart
│   ├── bouton_retour.dart
│   ├── case_circonstance.dart
│   ├── champ_bouton.dart
│   ├── champ_photo.dart
│   ├── champ_point_choc.dart
│   ├── champ_texte.dart
│   ├── entete_etape.dart
│   ├── galerie_photo.dart
│   ├── indicateur_etapes.dart
│   ├── question_oui_non.dart
│   ├── section_temoins.dart
│   ├── selecteur_langue.dart
│   ├── titre_souligne.dart
│   └── zone_dessin.dart
│
└── main.dart   
```

### 4. Captures d'écran:
#### _a. Version Française_
<p align="center">
  <img src="captures/accueil_mobileFR.png" width="220">
  <img src="captures/accident_mobileFR.png"width="220">
  <img src="captures/vehiculeA_mobileFR.png" width="220">
  <img src="captures/vehiculeB_mobileFR.png" width="220">
</p>
<p align="center">
  <img src="captures/circonstances_mobileFR.png" width="220">
  <img src="captures/croquis_mobileFR.png" width="220">
  <img src="captures/signatures_mobileFR.png" width="220">
  <img src="captures/recapitulatif_mobileFR.png" width="220">
</p>
📄[Exemple de PDF généré en FR](captures/constatFR.pdf)

#### _a. Version Arabe_

### 5. Configuration:
Pour l'installation et l'exécution de l'application, veuillez consulter le README principal situé à la racine du projet: ```Constat/README.md```
