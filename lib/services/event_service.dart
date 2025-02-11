import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/constants.dart';
import 'api_service.dart';

class EventService {
  Future<Map<String, String>> loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    return {
      'fullName': prefs.getString('UTIFIRSTLASTNAME') ?? 'Nom inconnu',
      'email': prefs.getString('UTIMAIL') ?? 'Email inconnu',
      'phone': prefs.getString('UTIPHONE') ?? 'Téléphone inconnu',
      'profilePic': prefs.getString('UTIPIC') ?? '',
      'utiToken': prefs.getString('UTITOKEN') ?? '',
    };
  }

  Future<List<Map<String, dynamic>>> fetchEvents(String utiToken) async {
    // Méthode fetchEvents existante
    try {
      Map<String, String> dateRange = ApiService.getDateRange(
          AppConstants.startDate,
          AppConstants.endDate,
          AppConstants.dateFormat
      );

      if (dateRange.containsKey('startDate') && dateRange.containsKey('endDate')) {
        final response = await ApiService.post(
            AppConstants.ticketManagerEndpoint,
            {
              'mode': AppConstants.listEvenementFrontMode,
              'DT_BEGIN': dateRange['startDate']!,
              'DT_END': dateRange['endDate']!,
              'STR_UTITOKEN': utiToken,
            }
        );

        final responseBody = response.body.trim();

        if (responseBody.startsWith('{') || responseBody.startsWith('[')) {
          final jsonResponse = jsonDecode(responseBody);
          if (jsonResponse is Map<String, dynamic> && jsonResponse.containsKey('data')) {
            return List<Map<String, dynamic>>.from(jsonResponse['data']);
          } else {
            throw Exception('La réponse du serveur n\'est pas au format attendu');
          }
        } else {
          throw Exception('La réponse du serveur n\'est pas en JSON valide');
        }
      } else {
        throw Exception('Les clés startDate ou endDate sont manquantes');
      }
    } catch (e) {
      print('Erreur lors de la récupération des événements: $e');
      return [];
    }
  }


  Future<List<Map<String, dynamic>>> fetchScanneHistory(String utiToken) async {
    // Méthode fetchEvents existante
    try {
      Map<String, String> dateRange = ApiService.getDateRange(
          AppConstants.startDate,
          AppConstants.endDate,
          AppConstants.dateFormat
      );

      if (dateRange.containsKey('startDate') && dateRange.containsKey('endDate')) {
        final response = await ApiService.post(
            AppConstants.ticketManagerEndpoint,
            {
              'mode': AppConstants.listTicketMode,
              'DT_BEGIN': dateRange['startDate']!,
              'DT_END': dateRange['endDate']!,
              'STR_UTITOKEN': utiToken,
              'LG_AGEREQUESTID':AppConstants.LG_AGEREQUESTID,
              //"LG_UTIID":AppConstants.LG_UTIID,
              "STR_TICSTATUT":AppConstants.STR_TICSTATUT,
              "LG_EVEID":"",
            }
        );

        final responseBody = jsonDecode(response.body.trim());
        if (responseBody is Map<String, dynamic> && responseBody.containsKey('data')) {
          return List<Map<String, dynamic>>.from(responseBody['data']);
        } else {
          throw Exception('Erreur lors du parsing des données');
        }
      } else {
        throw Exception('Les clés startDate ou endDate sont manquantes');
      }
    } catch (e) {
      print('Erreur lors de la récupération des événements: $e');
      return [];
    }
  }


  Future<List<Map<String, dynamic>>> fetchCarouselData() async {
    // Méthode fetchCarouselData existante
    try {
      Map<String, String> dateRange = ApiService.getDateRange(
          AppConstants.startDate,
          AppConstants.endDate,
          AppConstants.dateFormat
      );

      if (dateRange.containsKey('startDate') && dateRange.containsKey('endDate')) {
        final response = await ApiService.post(
            AppConstants.ConfigurationManagerEndpoint,
            {
              'mode': AppConstants.listBanniereMode,
              'DT_BEGIN': dateRange['startDate']!,
              'DT_END': dateRange['endDate']!,
            }
        );

        final responseBody = response.body.trim();

        if (responseBody.startsWith('{') || responseBody.startsWith('[')) {
          final jsonResponse = jsonDecode(responseBody);
          if (jsonResponse is Map<String, dynamic> && jsonResponse.containsKey('data')) {
            return List<Map<String, dynamic>>.from(jsonResponse['data']);
          } else {
            throw Exception('La réponse du serveur n\'est pas au format attendu');
          }
        } else {
          throw Exception('La réponse du serveur n\'est pas en JSON valide');
        }
      } else {
        throw Exception('Les clés startDate ou endDate sont manquantes');
      }
    } catch (e) {
      print('Erreur lors de la récupération des données du carousel: $e');
      return [];
    }
  }
}