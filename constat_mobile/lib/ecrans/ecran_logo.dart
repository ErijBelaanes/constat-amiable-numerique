import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/couleurs.dart';

class EcranLogo extends StatefulWidget{
  const EcranLogo({super.key});

  @override
  State <EcranLogo> createState() => _EcranLogoState();
}

class _EcranLogoState extends State <EcranLogo>{

  @override
  void initState() {
    super.initState();

    Timer(
      const Duration(seconds: 2),
          () {
        Navigator.pushReplacementNamed(context, '/accueil');
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CouleursApp.fond,

      body: Center(
        child: Image.asset(
          'assets/images/constat_logo-removebg-preview.png',
          width: 400,
        ),
      ),
    );
  }
}