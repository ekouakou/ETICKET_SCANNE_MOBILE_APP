import 'dart:async';
import 'package:eticketappmobile/screen/scanner/qr_scan_page.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import '../../appDrawer/app_drawer.dart';
import '../../searchBar/Search_widget.dart';
import '../../services/api_service.dart';
import '../../services/event_service.dart';
import '../../services/user_provider.dart';
import '../../utils/theme_provider.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Map<String, dynamic>> ticketScanner = [];
  List<Map<String, dynamic>> filteredTickets = [];
  bool isLoading = true;
  String utiToken = "";
  final EventService _eventService = EventService();
  final GlobalKey<SearchWidgetState> searchWidgetKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final userData = await _eventService.loadUserData();
      setState(() {
        utiToken = userData['utiToken']!;
      });

      final tickets = await _eventService.fetchScanneHistory(utiToken);
      setState(() {
        ticketScanner = tickets;
        filteredTickets = tickets;
        isLoading = false;
      });
    } catch (e) {
      print('Erreur lors du chargement des données: $e');
      /*Fluttertoast.showToast(
        msg: "Erreur lors du chargement des tickets: $e",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
      );*/
      setState(() {
        isLoading = false;
      });
    }
  }

  void _handleSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredTickets = ticketScanner;
      } else {
        filteredTickets = ticketScanner
            .where((ticket) => ticket['STR_TICNAME']
            .toString()
            .toLowerCase()
            .contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  Widget _buildTicketList(BuildContext context, List<Map<String, dynamic>> items) {
    return items.isEmpty
        ? Center(child: Text('Aucun ticket trouvé'))
        : ListView.builder(
      padding: EdgeInsets.all(16.0),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final ticket = items[index];
        return Card(
          margin: EdgeInsets.symmetric(vertical: 8.0),
          elevation: 4,
          shadowColor: Colors.black.withOpacity(0.2),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.network(
                ApiService.getImageBaseUrl() + ticket['STR_TICBARECODE'],
                fit: BoxFit.cover,
                width: 50.0,
                height: 50.0,
              ),
            ),
            title: Text(ticket['STR_TICNAME']),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(ticket['STR_TICPHONE']),
                Text('Validé le: ' + ticket['DT_TCIVALIDATED']),
              ],
            ),
            trailing: Icon(Icons.more_vert),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    var userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Text(
            'Tickets scannés',
            style: TextStyle(
                color: textColor,
                fontSize: 20,
                fontWeight: FontWeight.bold
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(Icons.search),
              color: isDarkMode ? Colors.white : Colors.black,
              onPressed: () {
                searchWidgetKey.currentState?.toggleSearch();
              },
            ),
          ],
          iconTheme: IconThemeData(
            color: isDarkMode ? Colors.white : Colors.black,
          ),
        ),
      ),

      // A COMMENTER SI JE VEUX RITIRER LE DRAWER
      drawer: AppDrawer(userName: userProvider.fullName, userEmail : userProvider.email),

      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SearchWidget<Map<String, dynamic>>(
        key: searchWidgetKey,
        items: ticketScanner,
        filteredItems: filteredTickets,
        onSearch: _handleSearch,
        hintText: 'Rechercher un ticket',
        buildResults: _buildTicketList,
      ),

      // A COMMENTER SI JE VEUX RITIRER LE FLOATING ACTION
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => QRScanPage()));
        },
        child: Icon(Icons.qr_code_scanner, color: Colors.black),
        backgroundColor:  isDarkMode ? Colors.yellow : Colors.yellow,
      ),
    );
  }
}