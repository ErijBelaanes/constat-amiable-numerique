import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/constat_provider.dart';
import 'ecrans/ecran_accueil.dart';
import 'ecrans/ecran_accident.dart';
import 'ecrans/ecran_vehicule.dart';
import 'ecrans/ecran_logo.dart';
import 'ecrans/ecran_avertissement.dart';
import 'ecrans/ecran_circonstances.dart';
import 'ecrans/ecran_croquis.dart';
import 'ecrans/ecran_signatures.dart';
import 'ecrans/ecran_recapitulatif.dart';

void main(){
  runApp(const ConstatApp());
}

class ConstatApp extends StatelessWidget{
  const ConstatApp({super.key});
  @override
  Widget build(BuildContext context){  //Méthode pour décrire ce qui doit s'afficher à l'écran
    return ChangeNotifierProvider(
      create: (context) => ConstatProvider(),
      child: MaterialApp(
        title: 'Constat',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const EcranLogo(),
          '/accueil': (context) => const EcranAccueil(),
          '/avertissement': (context) => const EcranAvertissement(),
          '/accident': (context) => const EcranAccident(),
          '/vehiculeA': (context) => const EcranVehicule(nomVehicule: 'A'),
          '/vehiculeB': (context) => const EcranVehicule(nomVehicule: 'B'),
          '/circonstances': (context) => const EcranCirconstances(),
          '/croquis': (context) => const EcranCroquis(),
          '/signatures': (context) => const EcranSignatures(),
          // '/recapitulation': (context) => const EcranReaupitulatif(),
        },
      ),
    );
  }
}