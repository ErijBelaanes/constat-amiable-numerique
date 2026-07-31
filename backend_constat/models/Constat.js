const mongoose = require("mongoose");

const temoinSchema = new mongoose.Schema({
    nom: String,
    prenom: String,
    adresse: String,
    numTel: String,
});

const vehiculeSchema = new mongoose.Schema({
    //Société d'assurances
    assurance: String,
    numContrat: String,
    agence: String,
    dateDebutAttestation: Date,
    dateFinAttestation: Date,

    //Identité du conducteur
    nomConducteur: String,
    prenomConducteur: String,
    adresseConducteur: String,
    numPermis: String,
    datePermis: Date,

    //Assure
    nomAssure: String,
    prenomAssure: String,
    adresseAssure: String,
    numTel: String,

    //Identite du vehicule
    marque: String,
    type: String,
    numImmatriculation: String,
    sensSuivi: String,
    venantDe: String,
    allantA: String,

    //Point de choc
    pointChoc: {
      x: Number,
      y: Number,
    },
    imagePointChoc: String,

    //Dégâts apparents
    degatsApparents: String,
    photosDegatsApparents: [String],
    
    //Observations
    observations: String,
});

const constatSchema = new mongoose.Schema({
    dateAccident: Date,
    lieuAccident: String,
    degatsMateriels: Boolean,
    blesses: Boolean,
    temoins: Boolean, 
    listeTemoins: [temoinSchema],
    vehiculeA: vehiculeSchema,
    vehiculeB: vehiculeSchema,
    circonstancesA: [Boolean],
    circonstancesB: [Boolean],
    croquis: String,
    signatureA: String,
    signatureB: String,
    photosScene: [String],
    photosDegatsApparents: [String],

    pdfData: {
      type: Buffer,
      default: null,
    },
    pdfContentType: {
      type: String,
      default: "application/pdf"
    }
},
  {
    timestamps: true,
  }
);

module.exports = mongoose.model(
    "Constat",
    constatSchema
);