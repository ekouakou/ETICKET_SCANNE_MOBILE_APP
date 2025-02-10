import 'package:flutter/material.dart';

class AppSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;

  const AppSearchBar({
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 0,
      //shadowColor: Colors.black.withOpacity(0.2),
      borderRadius: BorderRadius.circular(16.0),
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Rechercher',
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(20.0),
              borderSide: BorderSide.none,
            ),
          ),
          onChanged: onChanged, // Appel de la méthode de filtrage
        ),
      ),
    );
  }
}




