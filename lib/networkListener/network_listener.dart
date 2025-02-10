import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'network_provider.dart';

class NetworkListener extends StatefulWidget {
  final Widget child;
  NetworkListener({required this.child});

  @override
  _NetworkListenerState createState() => _NetworkListenerState();
}

class _NetworkListenerState extends State<NetworkListener> {
  bool? _previousConnectionStatus;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<NetworkProvider>(
        builder: (context, networkProvider, child) {
          // Vérifiez si le statut de connexion a changé
          if (_previousConnectionStatus != null &&
              networkProvider.isConnected != _previousConnectionStatus) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    networkProvider.isConnected ? 'Connexion rétablie' : 'Connexion perdue',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  backgroundColor: networkProvider.isConnected ? Colors.green : Colors.red,
                  duration: Duration(seconds: 3),
                ),
              );
            });
          }

          // Mettez à jour le statut de connexion précédent
          _previousConnectionStatus = networkProvider.isConnected;

          return widget.child;
        },
      ),
    );
  }
}