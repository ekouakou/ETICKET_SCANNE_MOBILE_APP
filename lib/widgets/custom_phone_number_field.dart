import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../utils/colors.dart'; // Importez le fichier contenant les couleurs

class CustomPhoneNumberField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final FormFieldValidator<String>? validator;
  final bool requiredIndicator;

  const CustomPhoneNumberField({
    Key? key,
    required this.controller,
    required this.labelText,
    this.validator,
    this.requiredIndicator = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentTextColor = theme.textTheme.bodyLarge?.color ?? Colors.black;
    final borderColor = theme.colorScheme.onBackground?.withOpacity(0.5) ?? Colors.grey;
    final focusColor = theme.colorScheme.secondary;

    return TextFormField(
      controller: controller,
      validator: validator,
      readOnly: true,
      decoration: InputDecoration(
        labelText: null,
        label: RichText(
          text: TextSpan(
            text: labelText,
            style: TextStyle(fontSize: 12.0, color: currentTextColor),
            children: requiredIndicator
                ? [
              TextSpan(
                text: ' *',
                style: TextStyle(color: currentTextColor),
              ),
            ]
                : [],
          ),
        ),
        prefixIcon: Icon(
          Icons.phone,
          size: 20.0,
          color: theme.iconTheme.color ?? Colors.grey,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        isDense: true,
        contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: focusColor, width: 2.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: theme.colorScheme.error, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(color: borderColor, width: 0.50),
        ),
      ),
      onTap: () async {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
              backgroundColor: theme.dialogBackgroundColor,
              child: Container(
                padding: const EdgeInsets.all(16.0),
                child: IntlPhoneField(
                  controller: controller,
                  decoration: InputDecoration(
                    labelText: labelText,
                    fillColor: theme.colorScheme.background,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(16.0),
                      borderSide: BorderSide(
                        color: focusColor,
                        width: 2.0,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide(
                        color: focusColor,
                        width: 2.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      borderSide: BorderSide(
                        color: theme.colorScheme.secondary,
                        width: 2.0,
                      ),
                    ),
                  ),
                  initialCountryCode: 'CI',
                  onChanged: (phone) {
                    // Actions à effectuer lors du changement du numéro de téléphone
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }
}
