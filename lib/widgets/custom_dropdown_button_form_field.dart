import 'package:flutter/material.dart';

class CustomDropdownButtonFormField extends StatelessWidget {
  final String? value;
  final List<String> items;
  final String? labelText;
  final void Function(String?)? onChanged;
  final String? Function(String?)? validator;

  const CustomDropdownButtonFormField({
    Key? key,
    required this.value,
    required this.items,
    this.labelText,
    this.onChanged,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;
    final borderColor = theme.colorScheme.onBackground?.withOpacity(0.5) ?? Colors.grey;
    final accentColor = theme.colorScheme.secondary;

    return DropdownButtonFormField<String>(
      value: value,
      items: items.map((item) => DropdownMenuItem<String>(
        value: item,
        child: Text(item, style: TextStyle(color: textColor)), // Le texte du dropdown utilise la couleur du texte du thème
      )).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: TextStyle(color: textColor), // Le label utilise la couleur du texte du thème
        filled: true,
        fillColor: theme.colorScheme.background, // Le fond utilise la couleur de fond du thème
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(
            color: accentColor,
            width: 2.0,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(color: accentColor, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide(
            color: borderColor,
            width: 0.50,
          ),
        ),
      ),
      dropdownColor: theme.colorScheme.background, // Le dropdown utilise la couleur de fond du thème
      validator: validator,
    );
  }
}
