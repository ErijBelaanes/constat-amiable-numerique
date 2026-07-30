# Backend Constat

## Description
**Backend Constat** représente le backend du projet **Constat Amiable Numérique**, développé avec Node.js, Express et MongoDB. Il fournit les API REST utilisées par l'application mobile et l'interface d'administration.

## Sommaire
1.  [Fonctionnalités](#1-fonctionnalites)
2.  [Technologies utilisées](#2-technologies-utilisees)
3.  [Organistation du code](#3-organisation-du-code)
4.  [Configuration](#4-configuration)

### 1. Fonctionnalités
- Gestion des constats
- Stockage des PDF
- API REST
- Connexion à MongoDB

### 2. Technologies utilisées:
- Node.js
- Express 
- MongoDB
- Mongoose
- Multer

### 3. Organistation du code:
```text
  src/
│
├── middlewares/
│   └── upload.js
│
├── models/
│   └── Constat.js
│
├── node_modules/
│   ├── @mongodb-js/
│   │      └── ...
│   └── ...
│
├── routes/
│   └── constats.js
│ 
├── uploads/
│   └── pdfs/ 
│        └── ...
│
├── .env
├── package.json
├── package-lock.json
└── server.js
```

### 4. Configuration:
La documentation complète du projet est disponible dans le fichier README principal situé à la racine du projet: ```Constat/README.md```
