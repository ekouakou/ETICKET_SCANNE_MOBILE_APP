import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier {
  String _fullName = 'Chargement...';
  String _email = 'Chargement...';
  String _phone = 'Chargement...';
  String _profilePic = '';
  String _proDescription = '';
  String _proType = '';
  String _socName = '';
  String _socDescription = '';
  String _socLogo = '';
  String _utiLogin = '';
  String _utiToken = '';

  String get fullName => _fullName;
  String get email => _email;
  String get phone => _phone;
  String get profilePic => _profilePic;
  String get proDescription => _proDescription;
  String get proType => _proType;
  String get socName => _socName;
  String get socDescription => _socDescription;
  String get socLogo => _socLogo;
  String get utiLogin => _utiLogin;
  String get utiToken => _utiToken;

  Future<void> loadUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    _fullName = prefs.getString('UTIFIRSTLASTNAME') ?? 'Nom inconnu';
    _email = prefs.getString('UTIMAIL') ?? 'Email inconnu';
    _phone = prefs.getString('UTIPHONE') ?? 'Téléphone inconnu';
    _profilePic = prefs.getString('UTIPIC') ?? '';
    _utiLogin = prefs.getString('UTILOGIN') ?? '';
    _utiToken = prefs.getString('UTITOKEN') ?? '';
    _proDescription = prefs.getString('PRODESCRIPTION') ?? '';
    _proType = prefs.getString('PROTYPE') ?? '';
    _socName = prefs.getString('SOCNAME') ?? '';
    _socDescription = prefs.getString('SOCDESCRIPTION') ?? '';
    _socLogo = prefs.getString('SOCLOGO') ?? '';

    notifyListeners();
  }

  Future<void> saveUserData({
    required String fullName,
    required String email,
    required String phone,
    required String profilePic,
    required String utiLogin,
    required String utiToken,
    required String proDescription,
    required String proType,
    required String socName,
    required String socDescription,
    required String socLogo,
  }) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString('UTIFIRSTLASTNAME', fullName);
    await prefs.setString('UTIMAIL', email);
    await prefs.setString('UTIPHONE', phone);
    await prefs.setString('UTIPIC', profilePic);
    await prefs.setString('UTILOGIN', utiLogin);
    await prefs.setString('UTITOKEN', utiToken);
    await prefs.setString('PRODESCRIPTION', proDescription);
    await prefs.setString('PROTYPE', proType);
    await prefs.setString('SOCNAME', socName);
    await prefs.setString('SOCDESCRIPTION', socDescription);
    await prefs.setString('SOCLOGO', socLogo);

    _fullName = fullName;
    _email = email;
    _phone = phone;
    _profilePic = profilePic;
    _utiLogin = utiLogin;
    _utiToken = utiToken;
    _proDescription = proDescription;
    _proType = proType;
    _socName = socName;
    _socDescription = socDescription;
    _socLogo = socLogo;

    notifyListeners();
  }

  Future<void> clearUserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.remove('UTIFIRSTLASTNAME');
    await prefs.remove('UTIMAIL');
    await prefs.remove('UTIPHONE');
    await prefs.remove('UTIPIC');
    await prefs.remove('UTILOGIN');
    await prefs.remove('UTITOKEN');
    await prefs.remove('PRODESCRIPTION');
    await prefs.remove('PROTYPE');
    await prefs.remove('SOCNAME');
    await prefs.remove('SOCDESCRIPTION');
    await prefs.remove('SOCLOGO');

    _fullName = 'Nom inconnu';
    _email = 'Email inconnu';
    _phone = 'Téléphone inconnu';
    _profilePic = '';
    _utiLogin = '';
    _utiToken = '';
    _proDescription = '';
    _proType = '';
    _socName = '';
    _socDescription = '';
    _socLogo = '';

    notifyListeners();
  }
}
