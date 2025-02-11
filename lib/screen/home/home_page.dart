import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:google_fonts/google_fonts.dart' as google_fonts;
import 'dart:async';
import '../../searchBar/search_action_button.dart';
import '../../searchBar/search_bar.dart';
import '../../utils/constants.dart';
import '../../services/event_service.dart';
import '../../services/user_provider.dart';
import '../scanner/qr_scan_page.dart';
import '../event_detail_page.dart';
import '../../utils/theme_provider.dart';
import '../../appDrawer/app_drawer.dart';
import '../../BottomNavigationBar/custom_bottom_navigation.dart';
import '../../services/api_service.dart';

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
  List<Map<String, dynamic>> _filteredCategories = [];
  bool _isSearchBarVisible = false;
  TextEditingController _searchController = TextEditingController();
  String _utiToken = "";

  final EventService _eventService = EventService(); // Instance du service
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
    _loadData();
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

  Future<void> _loadData() async {
    try {
      // Charger les données utilisateur depuis le service
      final userData = await _eventService.loadUserData();

      setState(() {
        _utiToken = userData['utiToken']!;
      });

      // Récupérer les événements et les données du carousel
      categories = await _eventService.fetchEvents(_utiToken);
      _carouselItems = await _eventService.fetchCarouselData();

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      print('Erreur lors du chargement des données: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _filterEvents(String query) {
    setState(() {
      _isSearching = query.isNotEmpty;

      if (_isSearching) {
        _filteredCategories = categories.map((category) {
          var filteredCategory = Map<String, dynamic>.from(category);

          filteredCategory['evenements'] = category['evenements'].where((event) {
            return event['STR_EVENAME']
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase());
          }).toList();

          return filteredCategory;
        }).toList();

        _filteredCategories = _filteredCategories
            .where((category) =>
        category['evenements'] != null &&
            category['evenements'].isNotEmpty)
            .toList();
      } else {
        _filteredCategories = List.from(categories);
      }
    });
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
    final textColor = isDarkMode ? Colors.white : Colors.black;
    var userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: Text('Accueil'),
        backgroundColor: isDarkMode ? Colors.black54 : Colors.white,
        titleTextStyle: TextStyle(
          color: isDarkMode ? Colors.white : Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(
          color: isDarkMode ? Colors.white : Colors.black,
        ),
        actions: [
          SearchActionButton(
            isSearchBarVisible: _isSearchBarVisible,
            onSearchIconPressed: () {
              setState(() {
                _isSearchBarVisible = !_isSearchBarVisible;
              });
            },
          ),
        ],
      ),
      drawer: AppDrawer(userName: userProvider.fullName, userEmail : userProvider.email),
      body: Column(
        children: [
          AnimatedContainer(
            duration: Duration(milliseconds: 300),
            height: _isSearchBarVisible ? 60.0 : 0.0,
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: _isSearchBarVisible
                ? AppSearchBar(
              controller: _searchController,
              onChanged: _filterEvents,
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
                        ? ApiService.getImageBaseUrl() + item['STR_BANPATH']
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
                for (var category in (_isSearching ? _filteredCategories : categories))
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
                                  ? ApiService.getImageBaseUrl() + event['STR_EVEPIC']
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

      //bottomNavigationBar: CustomBottomNavBar(currentIndex: 0),
    );
  }
}
