import 'package:flutter/material.dart';
import '../../widgets/custom_buttom.dart';

class IntroScreen extends StatelessWidget {
  final String lightImage;
  final String darkImage;
  final String title;
  final String description;
  final String buttonText;

  const IntroScreen({
    required this.lightImage,
    required this.darkImage,
    required this.title,
    required this.description,
    required this.buttonText,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    String image = isDarkMode ? darkImage : lightImage;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(image, height: 70),
          const SizedBox(height: 20),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            description,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 20),
          CustomButton(
            text: buttonText,
            color: Colors.white,
            borderRadius: 8,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            textColor: Colors.white,
            fontSize: 12.0,
            //fontFamily: 'Arial',
            showBorder: true,  // Affiche le contour
            showBackground: false,  // Affiche le fond
            route: '/LoginPage',
            context: context,
          ),
        ],
      ),
    );
  }
}
