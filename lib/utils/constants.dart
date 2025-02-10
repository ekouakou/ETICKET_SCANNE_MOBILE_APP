import 'package:flutter/material.dart';

class AppConstants {
  static const String appName = "Guinée Ticket";
  static const String loginLabel = "Login";
  static const String passwordLabel = "Mot de passe";
  static const String loginError = "Veuillez renseigner votre login";
  static const String passwordError = "Veuillez entrer votre mot de passe";
  static const String welcomeMessage = "Bienvenue!";
  static const String appDescription = "Votre application Guinée Ticket";

  // API
  static const String loginEndpoint = "Authentification.php";
  static const String ticketManagerEndpoint = "TicketManager.php";
  static const String ConfigurationManagerEndpoint = "ConfigurationManager.php";

  static const String loginMode = "doConnexion";
  static const String verifyTicketMode = "verifyTicket";
  static const String listEvenementFrontMode = "listEvenementFront";
  static const String listBanniereMode = "listBanniere";

  // Spacings
  static const double spaceSmall = 8.0;
  static const double spaceMedium = 16.0;
  static const double spaceLarge = 20.0;
  static const double spaceExtraLarge = 32.0;

  static const int startDate = 2;
  static const int endDate = 10;
  static const String dateFormat = 'yyyy-MM-dd';

  // Assets
  static const String lightModeLogo = "assets/images/logo_1.png";
  static const String darkModeLogo = "assets/images/logo_2.png";

  // Colors
  static const Color primaryColor = Colors.red;
}
