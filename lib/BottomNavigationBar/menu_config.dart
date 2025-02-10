// lib/config/menu_config.dart
import 'package:flutter/material.dart';
import '../BottomNavigationBar/menu_item.dart';

const MENU_ITEMS = [
  {
    "id": "Accueil",
    "title": "Accueil",
    "icon": Icons.dashboard,
    "route": "/HomePage"
  },
  {
    "id": "QRScanPage",
    "title": "Scanner QR Code",
    "icon": Icons.qr_code_scanner,
    "route": "/QRScanPage"
  },
  {
    "id": "Historique",
    "title": "Historique",
    "icon": Icons.list,
    "route": "/Historique"
  },
  {
    "id": "theme_toggle",
    "title": "Thème",
    "icon": Icons.brightness_6
  },
  {
    "id": "logout",
    "title": "Déconnexion",
    "icon": Icons.logout
  }
];

Future<List<MenuItem>> loadMenuItems() async {
  // Simuler un chargement asynchrone
  return Future.value(
    MENU_ITEMS.map((item) => MenuItem.fromJson(item)).toList(),
  );
}
