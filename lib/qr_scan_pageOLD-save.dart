import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:http/http.dart' as http; // Ajouté
import 'dart:convert'; // Ajouté

class QRScanPage extends StatefulWidget {
  @override
  _QRScanPageState createState() => _QRScanPageState();
}

class _QRScanPageState extends State<QRScanPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scanner le QR Code'),
        actions: [
          IconButton(
            icon: Icon(Icons.flash_on),
            onPressed: () {
              controller?.toggleFlash();
            },
          ),
        ],
      ),
      body: QRView(
        key: qrKey,
        onQRViewCreated: _onQRViewCreated,
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      // Appelle l'API pour enregistrer le scan
      _sendScanResult(scanData.code);
    });
  }

  Future<void> _sendScanResult(String? code) async {
    final response = await http.post(
      Uri.parse('URL_DE_VOTRE_API/scan'),
      body: {'code': code},
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data['success']) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text('Scan réussi'),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          content: Text('Échec du scan'),
        ),
      );
    }
  }
}
