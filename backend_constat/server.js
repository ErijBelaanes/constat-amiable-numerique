const express = require("express");  //express == le framework qui permet de créer facilement l'application web et de gérer les routes
const mongoose = require("mongoose");  //mongoose == outil qui facilite l'interaction et la modélisation des données avec la BD MongoDB
const cors = require("cors");  //cors == un middleware qui autorise ou bloque les requêtes provenant d'autres domaines
require("dotenv").config();

const app = express();

app.use(cors({
    origin: "*",
    methods: ["GET", "POST", "PUT", "DELETE"],
}));
app.use(express.json());

//Connexion à la base de données MongoDB
mongoose.connect(process.env.MONGO_URI)
.then(() => {
    console.log("MongoDB connecté");
})
.catch((err) => {
    console.log(err);
});

//Création des routes
app.get("/", (req, res) => {
    res.send("API Constat fonctionne");
});

const constatRoutes = require("./routes/constats");
app.use("/api/constats", constatRoutes);

//Démarrage du serveur
const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
    console.log(`Serveur lancé sur le port ${PORT}`);
});