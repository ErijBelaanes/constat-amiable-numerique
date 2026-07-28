import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class ServiceGeolocalisation {
  static Future<String> obtenirAdresseActuelle() async{
    //Vérification du disponibilité du service géolocalisation
    final serviceActif = await Geolocator.isLocationServiceEnabled();
    if(!serviceActif){
      throw Exception('Le GPS est désactivé sur cet appareil');
    }

    //Demande de permission
    LocationPermission permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied){
      permission = await Geolocator.requestPermission();
      if(permission == LocationPermission.denied){
        throw Exception('Permission de localisation refusée');
      }
    }

    if(permission == LocationPermission.deniedForever){
      throw Exception('Permission refusée définitivement. Active-la dans les règles du téléphone');
    }

    //Obtention des coordonnées GPS actuelles
    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
      ),
    );

    //Convertir les coordonnées en adresse lisible
    final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
    );
    if(placemarks.isEmpty){
      throw Exception('Adresse introuvable pour cette position');
    }
    final lieu = placemarks.first;
    final morceauxLieu = [
      lieu.street,
      lieu.locality,
      lieu.administrativeArea,
    ].where((element) => element != null && element.isNotEmpty);
    return morceauxLieu.join(', ');
  }
}