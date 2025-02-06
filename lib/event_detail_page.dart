import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:palette_generator/palette_generator.dart';
import 'qr_scan_page.dart';
import 'package:cached_network_image/cached_network_image.dart';

class EventDetailPage extends StatelessWidget {
  final String eventId;
  //192.168.1.5
  //127.0.0.1
  //final String _baseUrl = 'http://192.168.1.5/guineeticketbackend/public/';
  final String _baseUrl = 'http://192.168.1.6/';


  EventDetailPage({required this.eventId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white,
      appBar: AppBar(
        title: Text('Détail de l\'événement'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: fetchEventDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erreur de chargement'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('Aucun détail disponible'));
          } else {
            var event = snapshot.data!;
            return EventDetailContent(event: event, baseUrl: _baseUrl);
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => QRScanPage()),
          );
        },
        child: Icon(Icons.qr_code_scanner),
      ),
    );
  }

  Future<Map<String, dynamic>> fetchEventDetails() async {
    final response = await http.post(
      Uri.parse('${_baseUrl}backoffice/webservices/TicketManager.php'),
      headers: <String, String>{
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'mode': 'getEvenement',
        'STR_UTITOKEN': 'AfsvjcsLCHJ68PVdF9ZF',
        'LG_EVEID': eventId,
      },
    );

    if (response.statusCode == 200) {
      print('Réponse brute : ${response.body}');
      try {
        final responseBody = response.body.trim();
        if (responseBody.startsWith('{') || responseBody.startsWith('[')) {
          final jsonResponse = jsonDecode(responseBody);

          if (jsonResponse is Map<String, dynamic> && jsonResponse.containsKey('data')) {
            final List<dynamic> data = jsonResponse['data'];
            if (data.isNotEmpty) {
              return data[0] as Map<String, dynamic>; // Retourne le premier événement
            } else {
              throw Exception('Aucun événement trouvé');
            }
          } else {
            print('La réponse n\'est pas au format attendu : $responseBody');
            throw Exception('La réponse du serveur n\'est pas au format attendu');
          }
        } else {
          print('La réponse n\'est pas en JSON valide : $responseBody');
          throw Exception('La réponse du serveur n\'est pas en JSON valide');
        }
      } catch (e) {
        print('Erreur lors du décodage JSON : $e');
        throw Exception('Erreur lors du décodage JSON');
      }
    } else {
      print('Échec de la requête : ${response.reasonPhrase}');
      throw Exception('Échec de la requête');
    }
  }
}

class EventDetailContent extends StatefulWidget {
  final Map<String, dynamic> event;
  final String baseUrl;

  EventDetailContent({required this.event, required this.baseUrl});

  @override
  _EventDetailContentState createState() => _EventDetailContentState();
}

class _EventDetailContentState extends State<EventDetailContent> {
  Color? dominantColor;

  @override
  void initState() {
    super.initState();
    _calculateDominantColor();
  }

  Future<void> _calculateDominantColor() async {
    final PaletteGenerator paletteGenerator =
    await PaletteGenerator.fromImageProvider(
      NetworkImage('${widget.baseUrl}${widget.event['STR_EVEBANNER']}'),
    );
    setState(() {
      dominantColor = paletteGenerator.dominantColor?.color ?? Colors.black;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).brightness == Brightness.dark ? Colors.black : Colors.white,
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CachedNetworkImage(
                  imageUrl: '${widget.baseUrl}${widget.event['STR_EVEPIC']}',
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.cover,
                  placeholder: (context, url) => Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.event['STR_EVENAME'],
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 8),
                      Text(widget.event['STR_EVEDESCRIPTION']),
                      SizedBox(height: 16),
                      Text('Date: ${widget.event['DT_EVEBEGIN']}'),
                      SizedBox(height: 8),
                      Text('Heure: ${widget.event['HR_EVEBEGIN']} - ${widget.event['HR_EVEEND']}'),
                      SizedBox(height: 16),
                      Text('Annonceur: ${widget.event['STR_EVEANNONCEUR']}'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          /*if (dominantColor != null)
            Container(
              height: 300,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [dominantColor!, Colors.transparent],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),*/
        ],
      ),
    );
  }
}
