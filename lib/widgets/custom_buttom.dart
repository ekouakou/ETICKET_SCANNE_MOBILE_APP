import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final Color color;
  final Color textColor;
  final double borderRadius;
  final EdgeInsets padding;
  final String? route; // Permet la navigation si fourni
  final BuildContext? context; // Contexte pour la navigation
  final bool showBorder; // Afficher le contour
  final bool showBackground; // Afficher le fond
  final double fontSize; // Taille de la police
  final String fontFamily; // Police du texte

  const CustomButton({
    Key? key,
    this.onPressed,
    required this.text,
    this.color = Colors.blue,
    this.textColor = Colors.white,
    this.borderRadius = 16.0,
    this.padding = const EdgeInsets.symmetric(horizontal: 100, vertical: 15),
    this.route, // Paramètre optionnel pour la navigation
    this.context,
    this.showBorder = true, // Par défaut, on affiche le contour
    this.showBackground = true, // Par défaut, on affiche le fond
    this.fontSize = 16.0, // Taille de la police par défaut
    this.fontFamily = 'Roboto', // Police par défaut
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        if (onPressed != null) {
          onPressed!(); // Exécute la fonction fournie
        } else if (route != null && this.context != null) {
          Navigator.pushNamed(this.context!, route!); // Redirection
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: showBackground ? color : Colors.transparent, // Choisir le fond ou non
        side: showBorder ? BorderSide(color: color) : BorderSide.none, // Choisir le contour ou non
        elevation: 0,
        padding: padding,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor,
          fontSize: fontSize,
          fontFamily: fontFamily, // Appliquer la police
        ),
      ),
    );
  }
}
