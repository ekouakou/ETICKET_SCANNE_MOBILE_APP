import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/user_provider.dart';
import 'utils/theme_provider.dart';
import 'networkListener/network_provider.dart';
import 'networkListener/network_listener.dart';
import 'utils/app_theme.dart'; // Import the new theme utility
import 'appRoutes/app_rootes.dart';
import 'screen/intro/intro_page.dart';

void main() async {

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => NetworkProvider()),
        ChangeNotifierProvider(create: (context) => UserProvider()..loadUserData()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Flutter Firebase Auth ',
          theme: AppTheme.getLightTheme(context),
          darkTheme: AppTheme.getDarkTheme(context),
          themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: NetworkListener(child: IntroPage()),
          routes: AppRoutes.getRoutes(), // Utilisation des routes centralisées

        );
      },
    );
  }
}