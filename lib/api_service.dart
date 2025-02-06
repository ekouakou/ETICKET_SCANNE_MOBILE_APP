import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;

class ApiService {
  // Configuration de l'URL de base
  static const String _baseUrl = 'http://guineeticket.com/eticketbackend/backoffice/webservices/';

  // Timeout par défaut pour les requêtes
  static const Duration timeoutDuration = Duration(seconds: 30);

  // Headers par défaut
  static Map<String, String> get _defaultHeaders => {
    'Content-Type': 'application/x-www-form-urlencoded',
    'Accept': 'application/json',
  };

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