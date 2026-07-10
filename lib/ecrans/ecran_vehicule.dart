import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/constat_provider.dart';
import '../models/constat_model.dart';

class EcranVehicule extends StatefulWidget{
  final String nomVehicule;
  const EcranVehicule({super.key, required this.nomVehicule});

  @override
  State <EcranVehicule> createState() => _EcranVehiculeState();
}
class _EcranVehiculeState extends State <EcranVehicule>{
  @override
  Widget build(BuildContext context) {

    final couleur = (widget.nomVehicule == 'A') ? Colors.amber : Colors.blue;
    return Scaffold(
      appBar: AppBar(
        title: Text('Véhicule ${widget.nomVehicule}'),
        backgroundColor: couleur,
      ),
      body: Container(),
    );
  }
}