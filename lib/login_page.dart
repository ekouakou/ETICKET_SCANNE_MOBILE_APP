import 'package:flutter/material.dart';
import 'dart:convert';
import 'home_page.dart';
import 'theme_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart'; // Import the ApiService class

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  Future<void> _login() async {
    final response = await ApiService.post(
      'Authentification.php',
      {
        'mode': 'doConnexion',
        'STR_UTILOGIN': _usernameController.text,
        'STR_UTIPASSWORD': _passwordController.text,
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      if (data['code_statut'] == '1') {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('UTIFIRSTLASTNAME', data['UTIFIRSTLASTNAME'] ?? '');
        await prefs.setString('UTIPHONE', data['UTIPHONE'] ?? '');
        await prefs.setString('UTIMAIL', data['UTIMAIL'] ?? '');
        await prefs.setString('UTILOGIN', data['UTILOGIN'] ?? '');
        await prefs.setString('UTIPIC', data['UTIPIC'] ?? '');
        await prefs.setString('UTITOKEN', data['UTITOKEN'] ?? '');
        await prefs.setString('PRODESCRIPTION', data['PRODESCRIPTION'] ?? '');
        await prefs.setString('PROTYPE', data['PROTYPE'] ?? '');
        await prefs.setString('SOCNAME', data['SOCNAME'] ?? '');
        await prefs.setString('SOCDESCRIPTION', data['SOCDESCRIPTION'] ?? '');
        await prefs.setString('SOCLOGO', data['SOCLOGO'] ?? '');

        final socId = data['SOCID'];
        if (socId != null && socId is String && socId.isNotEmpty) {
          await prefs.setInt('SOCID', int.parse(socId));
        } else {
          await prefs.setInt('SOCID', 0);
        }

        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
      } else {
        _showErrorDialog(context, data['desc_statut'] ?? 'Erreur de connexion');
      }
    } else {
      _showErrorDialog(context, 'Erreur de serveur: ${response.statusCode}');
    }
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text(message),
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
          gradient: LinearGradient(
            colors: isDarkMode ? [Color(0xFF022358), Color(0xFF000000)] : [Colors.white, Colors.grey[200]!],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(
                  isDarkMode ? 'assets/images/logo_2.png' : 'assets/images/logo_1.png', // Replace with your logos
                  height: 50,
                ),
                SizedBox(height: 20),
                Text(
                  'Bienvenue!',

                  style: TextStyle(
                    color: isDarkMode ? Colors.white : Colors.black,
                    fontSize: 60,
                    fontFamily: 'Rosellinda',
                    //fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Votre application Guinnée ticket',
                  style: TextStyle(
                    color: isDarkMode ? Colors.white70 : Colors.black54,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 32),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: isDarkMode ? Colors.grey[800]!.withOpacity(0.15) : Colors.grey[400]!.withOpacity(0.15),
                          //fillColor: isDarkMode ? Colors.grey[900] : Colors.white,
                          labelText: 'Nom d\'utilisateur',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Veuillez entrer votre nom d\'utilisateur';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          filled: true,
                          //fillColor: isDarkMode ? Colors.grey[800] : Colors.white,
                          fillColor: isDarkMode ? Colors.grey[800]!.withOpacity(0.15) : Colors.grey[400]!.withOpacity(0.15),
                          labelText: 'Mot de passe',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Veuillez entrer votre mot de passe';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _login();
                          }
                          //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: EdgeInsets.symmetric(horizontal: 100, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          'Connexion',
                          style: TextStyle(
                            color: isDarkMode ? Colors.white : Colors.white,
                            fontSize: 16,
                          ),
                        ),
                      ),
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
