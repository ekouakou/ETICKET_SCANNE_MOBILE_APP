import 'package:flutter/material.dart';

import '../custom_buttom.dart';

class CustomDialog extends StatelessWidget {
  final String message;
  final VoidCallback onClose;
  final IconData? icon;
  final Color? iconColor;

  const CustomDialog({
    Key? key,
    required this.message,
    required this.onClose,
    this.icon,
    this.iconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              color: iconColor ?? Colors.black,
              size: 50,
            ),
            const SizedBox(height: 10),
          ],
          Text(
            message,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          CustomButton(
              text: "Fermer",
              color: Colors.blue,
              borderRadius: 8,
              fontSize: 12.0,
              //fontFamily: 'Arial',
              showBorder: true,  // Affiche le contour
              showBackground: false,  // Affiche le fond
              padding: const EdgeInsets.symmetric(horizontal: 10),
              textColor: Colors.blue,
              onPressed: () {
                Navigator.of(context).pop();
                onClose();
              }
          )
        ],
      ),
    );
  }
}
