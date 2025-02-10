import 'package:flutter/material.dart';
import 'custom_text_field.dart'; // Importez votre widget CustomTextField
import '../utils/colors.dart'; // Importez le fichier contenant les couleurs

Widget buildDocumentQuestion({
  required int questionNumber,
  required String questionText,
  required TextEditingController controller,
  required String labelText,
  required Color mycolor,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: mycolor,
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Text(
              '$questionNumber',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              questionText,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
      const SizedBox(height: 10),
      CustomTextField(
        labelText: labelText,
        controller: controller,
      ),
    ],
  );
}
