import 'package:flutter/material.dart';
import '../utils/colors.dart'; // Importez le fichier contenant les couleurs

class CustomDropdownFormField extends StatefulWidget {
  final String labelText;
  final List<String> items;
  final String? value;
  final ValueChanged<String?>? onChanged;
  final FormFieldValidator<String>? validator;
  final EdgeInsetsGeometry contentPadding;
  final TextStyle? labelStyle;
  final bool isRequired;
  final Color? backgroundColor;

  const CustomDropdownFormField({
    Key? key,
    required this.labelText,
    required this.items,
    this.value,
    this.onChanged,
    this.validator,
    this.contentPadding = const EdgeInsets.symmetric(vertical: 0.0, horizontal: 12.0),
    this.labelStyle,
    this.isRequired = false,
    this.backgroundColor = const Color(0xFFFFFFFF),
  }) : super(key: key);

  @override
  _CustomDropdownFormFieldState createState() => _CustomDropdownFormFieldState();
}

class _CustomDropdownFormFieldState extends State<CustomDropdownFormField> {
  late String? _selectedValue;

  @override
  void initState() {
    super.initState();
    _selectedValue = widget.value;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentTextColor = theme.textTheme.bodyLarge?.color ?? Colors.black;
    final borderColor = theme.colorScheme.onBackground?.withOpacity(0.5) ?? Colors.grey;

    return DropdownButtonFormField<String>(
      value: _selectedValue,
      items: widget.items.map((String item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(item, style: TextStyle(color: currentTextColor)),
        );
      }).toList(),
      onChanged: (value) {
        setState(() {
          _selectedValue = value;
        });
        widget.onChanged?.call(value);
      },
      decoration: InputDecoration(
        filled: true,
        fillColor: widget.backgroundColor ?? theme.colorScheme.background,
        labelText: widget.isRequired
            ? widget.labelText + ' *'
            : widget.labelText,
        labelStyle: widget.labelStyle?.copyWith(
          color: currentTextColor, // Utilisation de la couleur du texte du thème
        ),
        contentPadding: widget.contentPadding,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: borderColor, width: 0.50),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: borderColor, width: 0.50),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: theme.colorScheme.secondary, width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: theme.colorScheme.error, width: 2.0),
        ),
      ),
      validator: widget.validator ?? (value) {
        if (widget.isRequired && (value == null || value.isEmpty)) {
          return 'Ce champ est obligatoire';
        }
        return null;
      },
      isExpanded: true,
    );
  }
}
