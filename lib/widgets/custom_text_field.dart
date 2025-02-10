import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String labelText;
  final TextEditingController controller;
  final FormFieldValidator<String>? validator;
  final bool obscureText;
  final TextInputType keyboardType;
  final Color? fillColor;
  final EdgeInsetsGeometry contentPadding;
  final TextStyle? labelStyle;
  final bool requiredIndicator;
  final Widget? suffixIcon; // Ajout d'une icône personnalisable

  const CustomTextField({
    Key? key,
    required this.labelText,
    required this.controller,
    this.validator,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.fillColor,
    this.contentPadding = const EdgeInsets.symmetric(vertical: 0.0, horizontal: 12.0),
    this.labelStyle,
    this.requiredIndicator = false,
    this.suffixIcon,
  }) : super(key: key);

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _obscureText = true;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentTextColor = theme.textTheme.bodyLarge?.color ?? Colors.black;
    final borderColor = theme.colorScheme.onBackground?.withOpacity(0.5) ?? Colors.grey;

    return TextFormField(
      controller: widget.controller,
      obscureText: _obscureText,
      keyboardType: widget.keyboardType,
      validator: widget.validator,
      decoration: InputDecoration(
        label: RichText(
          text: TextSpan(
            text: widget.labelText,
            style: widget.labelStyle ?? TextStyle(fontSize: 12.0, color: currentTextColor),
            children: widget.requiredIndicator
                ? [
              TextSpan(
                text: ' *',
                style: TextStyle(color: Colors.red, fontSize: 14.0),
              ),
            ]
                : [],
          ),
        ),
        filled: false,
        fillColor: widget.fillColor ?? theme.colorScheme.background,
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
          borderSide: BorderSide(color: theme.colorScheme.secondary, width: 0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: theme.colorScheme.error, width: 2.0),
        ),
        // ✅ Ajout du suffixIcon pour gérer le mot de passe
        suffixIcon: widget.obscureText
            ? IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        )
            : widget.suffixIcon, // Utilisation d'un icône personnalisé si fourni
      ),
    );
  }
}
