import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../utils/colors.dart';
import '../../utils/constants.dart';
import '../../utils/theme_provider.dart';
import '../../services/api_service.dart';
import '../../services/user_service.dart'; // Import du service utilisateur


class QRScanPage extends StatefulWidget {
  @override
  _QRScanPageState createState() => _QRScanPageState();
}

class _QRScanPageState extends State<QRScanPage> with SingleTickerProviderStateMixin {
  //final String _baseUrl = 'http://192.168.0.146/';

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  Map<String, String> userInfo = {};
  bool _isDialogOpen = false;
  bool _isScanningPaused = false;

  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();

    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0, end: 1).animate(_animationController);
  }

  Future<void> _loadUserInfo() async {
    userInfo = await UserService.getUserInfo();
    setState(() {}); // Mettre à jour l'interface après le chargement des données
  }

  @override
  void dispose() {
    _animationController.dispose();
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    final backgroundColor = isDarkMode ? Colors.black : Colors.white;
    final appBarColor = isDarkMode ? Colors.grey[850] : Colors.blue;
    final textColor = isDarkMode ? Colors.white : Colors.black;
    final borderColor = isDarkMode ? Colors.blueGrey : Colors.blue;

    return Scaffold(
     backgroundColor: backgroundColor,
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
              'Scanner le QR Code',
              style: TextStyle(color: textColor, fontSize: 20, fontWeight: FontWeight.bold),
            ),
            centerTitle: true,
            iconTheme: IconThemeData(
              color: isDarkMode ? Colors.white : Colors.black, // Change la couleur de l'icône du drawer
            ),
            actions: [
              IconButton(
                icon: Icon(Icons.flash_on, color: textColor),
                onPressed: () {
                  controller?.toggleFlash();
                },
              ),
            ],
          ),
        ),
      ),

      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: AppColors.getTreeGradient(context,begin: Alignment.bottomCenter,
                end: Alignment.topCenter,), // Dégradé dynamique depuis la méthode AppColors
            ),
          ),
          Center(
            child: Container(
              width: 300,
              height: 300,
              margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: borderColor, width: 4),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    QRView(
                      key: qrKey,
                      onQRViewCreated: _onQRViewCreated,
                    ),
                    AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        return Positioned(
                          top: _animation.value * (300 - 4),
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 4,
                            color: Colors.red,
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 30,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: Text(
                  'Scanner',
                  style: TextStyle(color: textColor, fontSize: 18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      if (!_isDialogOpen && !_isScanningPaused) {
        controller.pauseCamera();
        await _sendScanResult(scanData.code);
        _animationController.stop();
        _isScanningPaused = true;
      }
    });
  }

  Future<void> _sendScanResult(String? code) async {
    if (code == null) return;

    List<String> parts = code.split('#');

    final response = await ApiService.post(
      AppConstants.ticketManagerEndpoint,
      {
        'LG_TICID': parts[0],
        'STR_TICNAME': parts[1],
        'mode': AppConstants.verifyTicketMode,
        'STR_UTITOKEN': userInfo['UTITOKEN'] ?? '',
      },
    );

    final data = jsonDecode(response.body);

    Fluttertoast.showToast(
      msg: "Objet JSON: ${data}",
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.black,
      textColor: Colors.white,
      fontSize: 16.0,
    );

    if (response.statusCode == 200) {
      _isDialogOpen = true;

      if (data['code_statut'] == '0') {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Notification'),
            content: Text(data['desc_statut']),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    _isDialogOpen = false;
                  });
                  controller?.resumeCamera();
                  _animationController.repeat(reverse: true);
                  _isScanningPaused = false;
                },
                child: Text('Fermer'),
              ),
            ],
          ),
        );
      } else if (data['code_statut'] == '1') {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Notification'),
            content: Text(data['desc_statut']),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    _isDialogOpen = false;
                  });
                  controller?.resumeCamera();
                  _animationController.repeat(reverse: true);
                  _isScanningPaused = false;
                },
                child: Text('Fermer'),
              ),
            ],
          ),
        );
      } else if (data['code_statut'] == '2') {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Notification'),
            content: Text(data['desc_statut']),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    _isDialogOpen = false;
                  });
                  controller?.resumeCamera();
                  _animationController.repeat(reverse: true);
                  _isScanningPaused = false;
                },
                child: Text('Fermer'),
              ),
            ],
          ),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  data['code_statut'] == '1' ? Icons.check_circle : Icons.error,
                  color: data['code_statut'] == '1' ? Colors.green : Colors.red,
                  size: 50,
                ),
                SizedBox(height: 10),
                Text(data['desc_statut']),
                SizedBox(height: 20),
                // Affichage des données de l'événement
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Image.network(
                    ApiService.getImageBaseUrl(), //_baseUrl + "backoffice/"+data['STR_EVEPIC'],
                    width: 300,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  data['STR_EVENAME'],
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 10),
                Text(
                  data['STR_EVEDESCRIPTION'].length > 100
                      ? data['STR_EVEDESCRIPTION'].substring(0, 100) + '...'
                      : data['STR_EVEDESCRIPTION'],
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Icon(Icons.calendar_today, size: 16),
                    SizedBox(width: 5),
                    Text(data['DT_TCIVALIDATED']),
                    SizedBox(width: 10),
                    Icon(Icons.access_time, size: 16),
                    SizedBox(width: 5),
                    Text(data['DT_TCICREATED'].split(' ')[1]),
                  ],
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    setState(() {
                      _isDialogOpen = false;
                    });
                    controller?.resumeCamera();
                    _animationController.repeat(reverse: true);
                    _isScanningPaused = false;
                  },
                  child: Text('Fermer'),
                ),
              ],
            ),
          ),
        );
      }
    } else {
      _isDialogOpen = true;
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.error,
                color: Colors.red,
                size: 50,
              ),
              SizedBox(height: 10),
              Text('Échec du scan'),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    _isDialogOpen = false;
                  });
                  controller?.resumeCamera();
                  _animationController.repeat(reverse: true);
                  _isScanningPaused = false;
                },
                child: Text('Fermer'),
              ),
            ],
          ),
        ),
      );
    }
  }



  /*Future<void> _getUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userInfo = {
        'UTIFIRSTLASTNAME': prefs.getString('UTIFIRSTLASTNAME') ?? '',
        'UTIPHONE': prefs.getString('UTIPHONE') ?? '',
        'UTIMAIL': prefs.getString('UTIMAIL') ?? '',
        'UTILOGIN': prefs.getString('UTILOGIN') ?? '',
        'UTIPIC': prefs.getString('UTIPIC') ?? '',
        'UTITOKEN': prefs.getString('UTITOKEN') ?? '',
        'PRODESCRIPTION': prefs.getString('PRODESCRIPTION') ?? '',
        'TICID': prefs.getString('TICID') ?? '',
        'SITNAME': prefs.getString('SITNAME') ?? '',
      };
    });
  }*/

}
