import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';

class NetworkProvider extends ChangeNotifier {
  bool _isConnected = true;
  bool get isConnected => _isConnected;

  NetworkProvider() {
    _checkInternetConnection();
    _monitorConnection();
  }

  Future<void> _checkInternetConnection() async {
    bool connection = await _hasInternet();
    _updateConnectionStatus(connection);
  }

  void _monitorConnection() {
    Timer.periodic(Duration(seconds: 5), (timer) async {
      bool connection = await _hasInternet();
      if (connection != _isConnected) {
        _updateConnectionStatus(connection);
      }
    });
  }

  Future<bool> _hasInternet() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  void _updateConnectionStatus(bool status) {
    _isConnected = status;
    notifyListeners();
  }
}
