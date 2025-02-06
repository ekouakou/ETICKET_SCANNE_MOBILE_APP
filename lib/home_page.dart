import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart' as google_fonts;
import 'dart:async';
import 'dart:convert';
import 'login_page.dart';
import 'qr_scan_page.dart';
import 'history_page.dart';
import 'event_detail_page.dart';
import 'theme_provider.dart';
import 'api_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer;
  List<Map<String, dynamic>> categories = [];
  List<Map<String, dynamic>> _carouselItems = [];
  bool _isLoading = true;
  final String _baseUrl = 'http://192.168.0.146/backoffice/';

  bool _isSearchBarVisible = false;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
    _fetchData();
    _fetchCarouselData();
  }

  void _startAutoSlide() {
    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (_pageController.hasClients && _carouselItems.isNotEmpty) {
        _currentPage = (_currentPage + 1) % _carouselItems.length;
        _pageController.animateToPage(
          _currentPage,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );
      }
    });
  }

  Future<void> _fetchData() async {
    try {
      final response = await ApiService.post('TicketManager.php', {
        'mode': 'listEvenementFront',
        'DT_BEGIN': '2024-01-01',
        'DT_END': '2024-08-30',
        'STR_UTITOKEN': 'AfsvjcsLCHJ68PVdF9ZF',
      });

      final responseBody = response.body.trim();

      if (responseBody.startsWith('{') || responseBody.startsWith('[')) {
        final jsonResponse = jsonDecode(responseBody);
        if (jsonResponse is Map<String, dynamic> && jsonResponse.containsKey('data')) {
          setState(() {
            categories = List<Map<String, dynamic>>.from(jsonResponse['data']);
            _isLoading = false;
          });
        } else {
          throw Exception('La réponse du serveur n\'est pas au format attendu');
        }
      } else {
        throw Exception('La réponse du serveur n\'est pas en JSON valide');
      }
    } catch (e) {
      print('Erreur lors de la récupération des données: $e');
    }
  }

  Future<void> _fetchCarouselData() async {
    try {
      final response = await ApiService.post('ConfigurationManager.php', {
        'mode': 'listBanniere',
        'DT_BEGIN': '2024-01-01',
        'DT_END': '2024-08-30',
      });

      final responseBody = response.body.trim();

      if (responseBody.startsWith('{') || responseBody.startsWith('[')) {
        final jsonResponse = jsonDecode(responseBody);
        if (jsonResponse is Map<String, dynamic> && jsonResponse.containsKey('data')) {
          setState(() {
            _carouselItems = List<Map<String, dynamic>>.from(jsonResponse['data']);
          });
        } else {
          throw Exception('La réponse du serveur n\'est pas au format attendu');
        }
      } else {
        throw Exception('La réponse du serveur n\'est pas en JSON valide');
      }
    } catch (e) {
      print('Erreur lors de la récupération des données du carousel: $e');
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    final backgroundColor = isDarkMode ? Colors.black : Colors.white;
    final drawerHeaderColor = isDarkMode ? Colors.white70 : Colors.black54;//isDarkMode ? Colors.grey[850] : Colors.blue;
    final drawerIconColor = isDarkMode ? Colors.white : Colors.red;
    final drawertextColor = isDarkMode ? Colors.white : Colors.white;
    final textColor = isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('Accueil'),
        backgroundColor: isDarkMode ? Colors.black54 : Colors.white,//drawerHeaderColor,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              setState(() {
                _isSearchBarVisible = !_isSearchBarVisible;
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            height: _isSearchBarVisible ? 60.0 : 0.0,
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: _isSearchBarVisible
                ? Material(
              elevation: 4,
              shadowColor: Colors.black.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16.0),
              child: Padding(
                padding: const EdgeInsets.all(0.0),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Rechercher',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (value) {
                    // Fonction de recherche
                  },
                ),
              ),
            )
                : null,
          ),
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : ListView(
              children: [
                SizedBox(height: 20),
                // Slider d'événements
                CarouselSlider(
                  items: _carouselItems.map((item) {
                    final imageUrl = item['STR_BANPATH'] != null
                        ? _baseUrl + item['STR_BANPATH']
                        : '';
                    final title = item['title'] ?? 'Titre non disponible';
                    final description = item['description'] ?? 'Description non disponible';
                    final price = item['price'] ?? 'Buy Now';

                    return Container(
                      margin: EdgeInsets.symmetric(horizontal: 2.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: NetworkImage(imageUrl),
                          fit: BoxFit.cover,
                        ),
                      ),
                      /*child: Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: google_fonts.GoogleFonts.poppins(fontSize: 20, color: Colors.white),
                              ),
                              Text(
                                description,
                                style: google_fonts.GoogleFonts.poppins(fontSize: 16, color: Colors.white),
                              ),
                              ElevatedButton(
                                onPressed: () {},
                                child: Text(price),
                              ),
                            ],
                          ),
                        ),
                      ),*/
                    );
                  }).toList(),
                  options: CarouselOptions(
                    height: 200,
                    autoPlay: true,
                    enlargeCenterPage: false,
                    viewportFraction: 1.0,
                  ),
                ),
                SizedBox(height: 20),
                // Affichage des catégories et des événements
                for (var category in categories)
                  if (category['evenements'] != null && category['evenements'].isNotEmpty)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            category['STR_LSTDESCRIPTION'] ?? 'Description non disponible',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: textColor),
                          ),
                        ),
                        Container(
                          height: 140,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: category['evenements'].length,
                            itemBuilder: (context, index) {
                              var event = category['evenements'][index];
                              final imageUrl = event['STR_EVEPIC'] != null
                                  ? _baseUrl + event['STR_EVEPIC']
                                  : '';
                              final eventName = event['STR_EVENAME'] ?? 'Nom non disponible';

                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => EventDetailPage(
                                          eventId: event['LG_EVEID'] ?? ''),
                                    ),
                                  );
                                },
                                child: Container(
                                  margin: EdgeInsets.all(8.0),
                                  width: 150,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(10.0),
                                        child: CachedNetworkImage(
                                          imageUrl: imageUrl,
                                          height: 80,
                                          width: 150,
                                          fit: BoxFit.cover,
                                          placeholder: (context, url) =>
                                              Center(child: CircularProgressIndicator()),
                                          errorWidget: (context, url, error) =>
                                              Icon(Icons.error),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          eventName,
                                          style: TextStyle(
                                              fontSize: 10, color: textColor),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => QRScanPage()));
        },
        child: Icon(Icons.qr_code_scanner, color: Colors.black),
        backgroundColor:  isDarkMode ? Colors.yellow : Colors.yellow,
      ),




      drawer: Drawer(
        child: Container(
          width: 100,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isDarkMode
                  ? [Color(0xFF022358), Color(0xFF000000)!]
                  : [Colors.grey[900]!, Colors.black],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            children: <Widget>[
              const DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: NetworkImage('https://via.placeholder.com/150'),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Nom de l\'utilisateur',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                  ],
                ),
              ),

              ListTile(
                leading: Icon(Icons.home, color: drawerIconColor),
                title: Text('Accueil', style: TextStyle(color: drawertextColor)),
                onTap: () {
                  Navigator.pushReplacementNamed(context, '/');
                },
              ),
              ListTile(
                leading: Icon(Icons.qr_code_scanner, color: drawerIconColor),
                title: Text('Scanner QR Code', style: TextStyle(color: drawertextColor)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => QRScanPage()),
                  );
                },
              ),
              ListTile(
                leading: Icon(Icons.history, color: drawerIconColor),
                title: Text('Historique', style: TextStyle(color: drawertextColor)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => HistoryPage()),
                  );
                },
              ),

              ListTile(
                leading: Icon(Icons.brightness_6, color: drawerIconColor),
                title: Text('Mode Clair/Sombre', style: TextStyle(color: drawertextColor)),
                onTap: () {
                  Provider.of<ThemeProvider>(context, listen: false)
                      .toggleTheme();
                },
              ),


              Spacer(),
              ListTile(
                leading: Icon(Icons.exit_to_app, color: drawerIconColor),
                title: Text('Se déconnecter', style: TextStyle(color: drawertextColor)),
                onTap: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  await prefs.clear();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
      /*bottomNavigationBar: BottomNavigationBar(
        backgroundColor: isDarkMode ? Colors.black54 : Colors.white,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        currentIndex: _currentPage,
        onTap: (index) {
          setState(() {
            _currentPage = index;
          });
          _pageController.jumpToPage(index);
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.qr_code_scanner),
            label: 'Scanner QR Code',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Historique',
          ),
        ],
      ),*/
    );
  }
}
