import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../utils/colors.dart';

class CustomDatePicker extends StatefulWidget {
  final TextEditingController controller;
  final String labelText;
  final FormFieldValidator<String>? validator;
  final bool requiredIndicator;
  final int initialYear;

  const CustomDatePicker({
    Key? key,
    required this.controller,
    required this.labelText,
    this.validator,
    this.requiredIndicator = false,
    this.initialYear = 1900,
  }) : super(key: key);

  @override
  _CustomDatePickerState createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<CustomDatePicker> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      readOnly: true,
      validator: widget.validator,
      decoration: InputDecoration(
        labelText: null,
        label: RichText(
          text: TextSpan(
            text: widget.labelText,
            style: TextStyle(
                fontSize: 12.0,
                color: AppColors.getTextColor(context)
            ),
            children: widget.requiredIndicator
                ? [
              TextSpan(
                text: ' *',
                style: TextStyle(
                    color: AppColors.getTextColor(context),
                    fontSize: 14.0
                ),
              ),
            ]
                : [],
          ),
        ),
        prefixIcon: Icon(
          Icons.calendar_today,
          size: 20.0,
          color: Theme.of(context).iconTheme.color ?? Colors.grey,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
              color: AppColors.getSecondaryColor(context).withOpacity(0.5),
              width: 0.50
          ),
        ),
        isDense: true,
        contentPadding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
              color: AppColors.getAccentColor(context),
              width: 2.0
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
              color: AppColors.getErrorColor(context),
              width: 2.0
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide(
              color: AppColors.getSecondaryColor(context).withOpacity(0.5),
              width: 0.50
          ),
        ),
      ),
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(widget.initialYear),
          lastDate: DateTime(2101),
          builder: (BuildContext context, Widget? child) {
            return Theme(
              data: ThemeData.light().copyWith(
                primaryColor: AppColors.getAccentColor(context),
                colorScheme: ColorScheme.light(
                  primary: AppColors.getAccentColor(context),
                  onSurface: AppColors.getTextColor(context),
                ),
                buttonTheme: ButtonThemeData(
                  textTheme: ButtonTextTheme.primary,
                ),
              ),
              child: child!,
            );
          },
        );

        if (pickedDate != null) {
          String formattedDate = DateFormat('dd/MM/yyyy').format(pickedDate);
          setState(() {
            widget.controller.text = formattedDate;
          });
        }
      },
    );
  }
}