import 'package:flutter/material.dart';
import 'custom_text_field.dart';  // Assurez-vous d'importer votre CustomTextField si nécessaire
import '../utils/colors.dart'; // Importez le fichier contenant les couleurs

Widget GenreQuestion({
  required List<String> options,
  required int? selectedOption,
  required ValueChanged<int?> onChanged,
  bool showTextField = false,
  TextEditingController? controller,
  String? labelText,
  required Color mycolor,
}) {
  return Container(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const SizedBox(width: 8.0),
            Container(
              padding: const EdgeInsets.only(right: 10.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: options.asMap().entries.map((entry) {
                  int index = entry.key;
                  String option = entry.value;
                  return GestureDetector(
                    onTap: () {
                      onChanged(index);
                    },
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          margin: const EdgeInsets.all(0.0),
                          child: Transform.scale(
                            scale: 0.6,
                            child: Radio<int>(
                              value: index,
                              groupValue: selectedOption,
                              onChanged: onChanged,
                              activeColor: mycolor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 0.0),
                        Text(
                          option,
                          style: TextStyle(
                            fontSize: 15.0,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (showTextField) ...[
          const SizedBox(height: 10),
          CustomTextField(
            labelText: labelText ?? '',
            controller: controller ?? TextEditingController(),
          ),
        ],
      ],
    ),
  );
}
