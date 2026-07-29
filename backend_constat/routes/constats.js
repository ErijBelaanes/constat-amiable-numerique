const express = require("express");
const router = express.Router();  //Crée un sous-modèle de routage
const Constat = require("../models/Constat");

//Ajouter un constat
router.post("/", async(req,res)=>{
    try {
        const nouveauConstat = new Constat(req.body);
        const sauvegarde = await nouveauConstat.save();
        res.status(201).json(sauvegarde);  //Renvoie le code 201 si tout se passe bien
    } catch(error){
        res.status(500).json({
            message:error.message
        });
    }
});

//Récupérer tous les constats
router.get("/", async(req,res)=>{
    try{
        const constats = await Constat.find();
        res.json(constats);  //Renvoie le tableau contenant tous les constats trouvés au client
    }catch(error){
        res.status(500).json({
            message:error.message
        });
    }
});

//Récupérer un constat par ID
router.get("/:id", async(req,res)=>{
    try{
        const constat = await Constat.findById(req.params.id);
        if(!constat){
            return res.status(404).json({
                message: "Constat introuvable"
            });
        }
        res.json(constat);  //Renvoie le constat trouvé
    }catch(error){
        res.status(500).json({
            message:error.message
        });
    }
});
module.exports = router;  //Rend ces routes disponibles pour être importé et utilisé dans le fichier principale