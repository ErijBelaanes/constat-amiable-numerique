const express = require("express");
const router = express.Router();  //Crée un sous-modèle de routage
const Constat = require("../models/Constat");
const upload = require("../middlewares/upload");

//Uploader le PDF généré par l'app mobile
router.post("/:id/pdf", upload.single("pdf"), async (req, res) => {
  try {
    const constat = await Constat.findById(req.params.id);
    if (!constat) {
      return res.status(404).json({ message: "Constat introuvable" });
    }
    if (!req.file) {
      return res.status(400).json({ message: "Aucun fichier PDF envoyé" });
    }

    // Supprimer l'ancien PDF s'il existe (remplacement)
    if (constat.pdfPath && fs.existsSync(constat.pdfPath)) {
      fs.unlinkSync(constat.pdfPath);
    }
    constat.pdfPath = req.file.buffer;
    constat.pdfContentType = req.file.mimetype;
    await constat.save();
    res.status(201).json({ message: "PDF enregistré avec succès" });
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});

//Récupérer/afficher le PDF
router.get("/:id/pdf", async (req, res) => {
  try {
    const constat = await Constat.findById(req.params.id);
    if (!constat || !constat.pdfData) {
      return res.status(404).json({ message: "PDF introuvable" });
    }
    if (!fs.existsSync(constat.pdfData)) {
      return res.status(404).json({ message: "Fichier PDF manquant sur le serveur" });
    }
    res.setHeader("Content-Type", constat.pdfContentType || "application/pdf");
    res.setHeader(
      "Content-Disposition",
      `inline; filename=constat-${constat._id}.pdf`
    );
    res.send(constat.pdfData);
  } catch (error) {
    res.status(500).json({ message: error.message });
  }
});
module.exports = router;

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

//Modifier un constat
router.put("/:id", async(req, res) => {
    try{
        const constat = await Constat.findByIdAndUpdate(
            req.params.id,
            req.body,
            {
                new: true,  //Retourner le document mis à jour
                runValidators: true  //Vérifier les données
            }
        );
        if(!constat){
            return res.status(404).json({
                message: "Constat introuvable"
            });
        }
        res.json(constat);
    }catch(error){
        res.status(500).json({
            message: error.message
        });
    }
});

//Supprimer un constat
router.delete("/:id", async(req, res) => {
    try{
        const constat = await Constat.findByIdAndDelete(req.params.id);
        if(!constat){
            return res.status(404).json({
                message: "Constat introuvable"
            });
        }
        res.json({
            message: "Constat supprimé avec succès"
        });
    }catch(error){
        res.status(500).json({
            message: error.message
        });
    }
});


module.exports = router;  //Rend ces routes disponibles pour être importé et utilisé dans le fichier principale