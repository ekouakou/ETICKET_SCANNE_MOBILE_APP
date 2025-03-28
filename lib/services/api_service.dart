import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class ApiService {
  // Configuration de l'URL de base
  static const String _baseUrl = 'https://guineeticket.com/eticketbackend/backoffice/webservices/';
  //static const String _baseUrl = 'http://192.168.0.146:8181/fonctionnaire/login';
  static const String _imagebaseUrl = 'https://guineeticket.com/eticketbackend/backoffice/';

  // Timeout par défaut pour les requêtes
  static const Duration timeoutDuration = Duration(seconds: 30);

  // Headers par défaut
  static Map<String, String> get _defaultHeaders => {
    'Content-Type': 'application/x-www-form-urlencoded',
    'Accept': 'application/json',
    // A DECOMMENTER POUR EBULLETIN
    //'Content-Type': 'application/json',
    //'Accept': '*/*',
  };

  // Méthode pour obtenir l'URL de base
  static String getBaseUrl() {
    return _baseUrl;
  }

  static String getImageBaseUrl() {
    return _imagebaseUrl;
  }

  // Méthode POST générique
  static Future<http.Response> post(String endpoint, Map<String, String> body) async {
    final url = '$_baseUrl$endpoint';

    // Logging de la requête
    print('🌐 Requête POST vers : $url');
    print('📦 Body : $body');

    try {
      final response = await http
          .post(
        Uri.parse(url),
        headers: _defaultHeaders,
        body: body,
        //body: jsonEncode(body), // A DECOMMENTER POUR EBULLETIN
      )
          .timeout(timeoutDuration);

      // Logging de la réponse
      print('📥 Status code : ${response.statusCode}');
      print('📄 Response body : ${response.body}');

      return response;
    } on SocketException catch (e) {
      print('❌ Erreur réseau : $e');
      throw Exception(
          'Impossible de se connecter au serveur. Veuillez vérifier votre connexion Internet.'
      );
    } on TimeoutException catch (e) {
      print('⏱️ Timeout : $e');
      throw Exception(
          'La requête a pris trop de temps. Veuillez réessayer.'
      );
    } on FormatException catch (e) {
      print('📋 Erreur de format : $e');
      throw Exception(
          'Erreur lors du traitement de la réponse du serveur.'
      );
    } catch (e) {
      print('💥 Erreur inattendue : $e');
      throw Exception('Une erreur inattendue est survenue : $e');
    }
  }

  // Fonction pour obtenir la date de début et de fin
  static Map<String, String> getDateRange(int weeksBefore, int weeksAfter, String dateFormat) {
    // Récupère la date actuelle
    DateTime now = DateTime.now();

    // Calcul de la date de début en soustrayant les semaines (multiplié par 7 pour obtenir le nombre de jours)
    DateTime startDate = now.subtract(Duration(days: weeksBefore * 7));

    // Calcul de la date de fin en ajoutant les semaines (multiplié par 7 pour obtenir le nombre de jours)
    DateTime endDate = now.add(Duration(days: weeksAfter * 7));

    // Formatage des dates selon le format spécifié
    DateFormat formatter = DateFormat(dateFormat);
    String formattedStartDate = formatter.format(startDate);
    String formattedEndDate = formatter.format(endDate);

    // Retourne un map avec les dates formatées
    return {
      'startDate': formattedStartDate,
      'endDate': formattedEndDate,
    };
  }

  // Méthode GET générique
  static Future<http.Response> get(String endpoint) async {
    final url = '$_baseUrl$endpoint';

    // Logging de la requête
    print('🌐 Requête GET vers : $url');

    try {
      final response = await http
          .get(
        Uri.parse(url),
        headers: _defaultHeaders,
      )
          .timeout(timeoutDuration);

      // Logging de la réponse
      print('📥 Status code : ${response.statusCode}');
      print('📄 Response body : ${response.body}');

      return response;
    } on SocketException catch (e) {
      print('❌ Erreur réseau : $e');
      throw Exception(
          'Impossible de se connecter au serveur. Veuillez vérifier votre connexion Internet.'
      );
    } on TimeoutException catch (e) {
      print('⏱️ Timeout : $e');
      throw Exception(
          'La requête a pris trop de temps. Veuillez réessayer.'
      );
    } on FormatException catch (e) {
      print('📋 Erreur de format : $e');
      throw Exception(
          'Erreur lors du traitement de la réponse du serveur.'
      );
    } catch (e) {
      print('💥 Erreur inattendue : $e');
      throw Exception('Une erreur inattendue est survenue : $e');
    }
  }

  // Méthode utilitaire pour vérifier la connexion Internet
  static Future<bool> checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  // Méthode pour construire l'URL complète
  static String buildUrl(String endpoint) {
    return '$_baseUrl$endpoint';
  }
}


