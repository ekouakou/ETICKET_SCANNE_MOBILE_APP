import 'package:eticketappmobile/screen/scanner/history_page.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import '../home/home_page.dart';
import '../../utils/theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/api_service.dart';
import '../../../utils/colors.dart';
import '/widgets/custom_text_field.dart';
import '../../widgets/custom_buttom.dart';
import '../../utils/constants.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _login() async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(child: CircularProgressIndicator());
        },
      );

      final response = await ApiService.post(
        AppConstants.loginEndpoint,
        {
          'mode': AppConstants.loginMode,
          'STR_UTILOGIN': _usernameController.text,
          'STR_UTIPASSWORD': _passwordController.text,
        },
      );

      Navigator.pop(context);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("Données décodées: $data");

        if (data['code_statut'] == '1') {
          SharedPreferences prefs = await SharedPreferences.getInstance();

          // Notez les clés STR_ ajoutées pour correspondre à la réponse API
          await prefs.setString('UTIFIRSTLASTNAME', data['STR_UTIFIRSTLASTNAME']?.toString() ?? '');
          await prefs.setString('UTIPHONE', data['STR_UTIPHONE']?.toString() ?? '');
          await prefs.setString('UTIMAIL', data['STR_UTIMAIL']?.toString() ?? '');
          await prefs.setString('UTILOGIN', data['STR_UTILOGIN']?.toString() ?? '');
          await prefs.setString('UTIPIC', data['STR_UTIPIC']?.toString() ?? '');
          await prefs.setString('UTITOKEN', data['STR_UTITOKEN']?.toString() ?? '');
          await prefs.setString('PRODESCRIPTION', data['STR_PRODESCRIPTION']?.toString() ?? '');
          await prefs.setString('PROTYPE', data['STR_PROTYPE']?.toString() ?? '');
          await prefs.setString('SOCNAME', data['STR_SOCNAME']?.toString() ?? '');
          await prefs.setString('SOCDESCRIPTION', data['STR_SOCDESCRIPTION']?.toString() ?? '');
          await prefs.setString('SOCLOGO', data['STR_SOCLOGO']?.toString() ?? '');

          // Pour SOCID, qui a un préfixe LG_
          if (data['LG_SOCID'] != null) {
            try {
              int socId = int.parse(data['LG_SOCID'].toString());
              await prefs.setInt('SOCID', socId);
            } catch (e) {
              print("Erreur lors de la conversion de SOCID: $e");
              await prefs.setInt('SOCID', 0);
            }
          }

          String? storedToken = prefs.getString('UTITOKEN');
          print("Token stocké: $storedToken");

          if (storedToken != null && storedToken.isNotEmpty) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => HistoryPage())
                //MaterialPageRoute(builder: (context) => HomePage())
            );
          } else {
            _showErrorDialog(context, 'Erreur lors du stockage des données utilisateur');
          }
        } else {
          _showErrorDialog(context, data['desc_statut'] ?? 'Erreur de connexion');
        }
      } else {
        _showErrorDialog(context, 'Erreur de serveur: ${response.statusCode}');
      }
    } catch (e) {
      print("Erreur lors de la connexion: $e");
      Navigator.pop(context);
      _showErrorDialog(context, 'Erreur: $e');
    }
  }


  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Erreur'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.isDarkMode;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppColors.getGradient(context),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: AppConstants.spaceMedium),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  isDarkMode ? AppConstants.darkModeLogo : AppConstants.lightModeLogo,
                  height: 50,
                ),
                SizedBox(height: AppConstants.spaceLarge),
                Text(
                  AppConstants.welcomeMessage,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontSize: 60,
                    fontFamily: 'Rosellinda',
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  AppConstants.appDescription,
                  style: TextStyle(
                    color: isDarkMode ? Colors.white70 : Colors.black54,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: AppConstants.spaceMedium),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      CustomTextField(
                        labelText: AppConstants.loginLabel,
                        controller: _usernameController,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppConstants.loginError;
                          }
                          return null;
                        },
                        requiredIndicator: true,
                      ),
                      SizedBox(height: AppConstants.spaceLarge),
                      CustomTextField(
                        labelText: AppConstants.passwordLabel,
                        controller: _passwordController,
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppConstants.passwordError;
                          }
                          return null;
                        },
                        requiredIndicator: true,
                      ),
                      SizedBox(height: AppConstants.spaceMedium),
                      CustomButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _login();
                          }
                        },
                        text: 'Connexion',
                        color: AppConstants.primaryColor,
                        textColor: Colors.white,
                      ),

                      /*CustomButton(
                        text: 'Aller à la Home',
                        color: Colors.green,
                        textColor: Colors.white,
                        route: '/QRScanPage', // Navigation vers la page Home
                        context: context, // Contexte pour la navigation
                      ),*/
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
