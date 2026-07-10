import 'package:flutter/material.dart';
class SelecteurLangue extends StatelessWidget{
  final bool estFrancais;
  final VoidCallback click;

  const SelecteurLangue({
    super.key,
    required this.estFrancais,
    required this.click,
  });

  @override
  Widget build (BuildContext context){
    return GestureDetector(
      onTap: click,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 6),
        decoration: BoxDecoration(
          color: const Color.fromRGBO(230, 238, 156, 1),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color.fromRGBO(198, 97, 63, 1),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [

            //FR en 1ere position
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: estFrancais
                    ? const Color.fromRGBO(198, 97, 63, 1)  //actif
                    : const Color.fromRGBO(230, 238, 156, 1),  //inactif
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'FR',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ),

            //AR en 2ème position
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: !estFrancais
                    ? const Color.fromRGBO(198, 97, 63, 1)  //actif
                    : const Color.fromRGBO(230, 238, 156, 1),  //inactif
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'AR',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}