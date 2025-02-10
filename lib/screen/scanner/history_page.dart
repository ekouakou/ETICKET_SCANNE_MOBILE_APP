
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import '../../services/api_service.dart';
import '../../utils/theme_provider.dart'; // Assurez-vous que le chemin est correct

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Map<String, dynamic>> _history = [];
  List<Map<String, dynamic>> _filteredHistory = [];
  bool _isSearchVisible = false;
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _fetchHistory();
    _searchController.addListener(_filterHistory);
  }

  Future<void> _fetchHistory() async {
    try {
      final response = await ApiService.post('TicketManager.php', {
        'mode': 'listTicket',
        'DT_BEGIN': '2024-01-01',
        'DT_END': '2024-08-30',
        'LG_AGEREQUESTID':'1',
        'LG_EVEID':'7WH3SbUfJOE5PaS7iD0WQ9LEmk3y10mjCiP3gm2y',
        'STR_UTITOKEN': 'omBDojlKb4713QY4JDqR',
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body.trim());

        if (data is Map<String, dynamic> && data.containsKey('data')) {
          setState(() {
            _history = List<Map<String, dynamic>>.from(data['data']);
            _filteredHistory = _history;
          });
        } else {
          throw Exception('Erreur lors du parsing des données');
        }
      } else {
        throw Exception('Erreur lors de la requête : ${response.statusCode}');
      }
    } catch (e) {
      print('Erreur: $e');
    }
  }

  void _filterHistory() {
    setState(() {
      _filteredHistory = _history
          .where((item) => item['STR_TICNAME']
          .toLowerCase()
          .contains(_searchController.text.toLowerCase()))
          .toList();
    });
  }

  void _toggleSearch() {
    setState(() {
      _isSearchVisible = !_isSearchVisible;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    final backgroundColor = isDarkMode ? Colors.black : Colors.white;
    final appBarColor = isDarkMode ? Colors.grey[850] : Colors.blue;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final borderColor = isDarkMode ? Colors.blueGrey : Colors.blue;
    return Scaffold(
      /*appBar: AppBar(
        title: Text('Historique des tickets scannés'),
        backgroundColor: theme.primaryColor,
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: _toggleSearch,
          ),
        ],
      ),*/

      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight), // Hauteur de l'AppBar
        child: Container(
          /*decoration: BoxDecoration(
            gradient:AppColors.getGradient(
              context,
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ), // Dégradé dynamique depuis la méthode AppColors
          ),*/
          child: AppBar(
            backgroundColor: Colors.transparent, // Fond transparent pour laisser voir le dégradé
            elevation: 0, // Pas d'ombre
            title: Text(
              'Historique des tickets scannés',
              style: TextStyle(color: textColor, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            iconTheme: IconThemeData(
              color: isDarkMode ? Colors.white : Colors.black, // Change la couleur de l'icône du drawer
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.search),
                onPressed: _toggleSearch,
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            height: 0,
            color: theme.primaryColor,
          ),
          Column(
            children: [
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                height: _isSearchVisible ? 60.0 : 0.0,
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: _isSearchVisible
                    ? Material(
                  //elevation: 4,
                  //shadowColor: Colors.black.withOpacity(0.2),
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
                        filled: true,
                        fillColor: theme.inputDecorationTheme.fillColor,
                      ),
                    ),
                  ),
                )
                    : null,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: ListView.builder(
                    padding: EdgeInsets.all(16.0),
                    itemCount: _filteredHistory.length,
                    itemBuilder: (context, index) {
                      var item = _filteredHistory[index];
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8.0),
                        elevation: 4,
                        shadowColor: Colors.black.withOpacity(0.2),
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              'http://192.168.1.5/backoffice/' + item['STR_TICBARECODE'],
                              fit: BoxFit.cover,
                              width: 50.0,
                              height: 50.0,
                            ),
                          ),
                          title: Text(item['STR_TICNAME']),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item['STR_TICPHONE']),
                              Text('Validé le: ' + item['DT_TCIVALIDATED']),
                              Text('Événement: ' + item['STR_EVENAME']),
                            ],
                          ),
                          trailing: Icon(Icons.more_vert),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
