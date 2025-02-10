import 'package:flutter/material.dart';
import '../screen/login/login_page.dart';
import '../screen/home/home_page.dart';
import '../screen/scanner/qr_scan_page.dart';
import '../screen/scanner/history_page.dart';
import '../screen/event_detail_page.dart';
import '../screen/intro/intro_page.dart';
import '../networkListener/network_listener.dart';

class AppRoutes {
  static const String intro = '/IntroPage';
  static const String login = '/LoginPage';
  static const String home = '/HomePage';
  static const String qrScan = '/QRScanPage';
  static const String history = '/Historique';
  static const String eventDetail = '/EventDetailPage';

  static Map<String, Widget Function(BuildContext)> getRoutes() {
    return {
      login: (context) => LoginPage(),
      home: (context) => NetworkListener(child: HomePage()),
      qrScan: (context) => NetworkListener(child: QRScanPage()),
      history: (context) => NetworkListener(child: HistoryPage()),
      //eventDetail: (context) => NetworkListener(child: EventDetailPage()),
    };
  }
}
