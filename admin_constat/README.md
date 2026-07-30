# Admin Constat

## Description
**Admin Constat** est une interface web développé avec React permettant aux administrateurs de consulter et de gérer les constats d'accidents enregistrés.

## Sommaire
  - [Fonctionnalités](#1-fonctionnalites)
  - [Technologies utilisées](#2-technologies-utilisees)
  - [Organistation du code](#3-organisation-du-code)
  - [Captures d'écran](#4-captures-decran)
  - [Configuration](#5-configuration)

### 1. Fonctionnalités
 - Consultation des constats
 - Recherche et filtrage (Par lieu, ID ...)
 - Affichage des détailsd'un constat
 - Suppression d'un constat 
 - Interface responsive

### 2. Technologies utilisées:
  - React
  - Vite 
  - JavaScript
  - TailWindCss
  - Axios

### 3. Organistation du code:
```text
  src/
│
├── assets/
│
├── composents/
│   ├── AppLayout.jsx
│   ├── confirmationSuppression.jsx
│   ├── Sidebar.jsx
│   └── TableConstats.jsx
│
├── pages/
│   ├── constats.jsx
│   ├── dashboard.jsx
│   └── detailConstat.jsx
│
└── services/
   └── api.js
```

### 4. Captures d'écran:
![Dashboard](captures/dashboard_admin.png)
![Listes des constats enregistrés](captures/listeConstats_admin.png)

### 5. Configuration:
La documentation complète du projet est disponible dans le fichier README principal situé à la racine du projet: ```Constat/README.md```
