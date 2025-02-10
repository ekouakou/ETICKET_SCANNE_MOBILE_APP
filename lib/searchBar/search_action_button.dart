import 'package:flutter/material.dart';

class SearchActionButton extends StatelessWidget {
  final bool isSearchBarVisible;
  final Function onSearchIconPressed;

  const SearchActionButton({
    required this.isSearchBarVisible,
    required this.onSearchIconPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        Icons.search,
        //color: isSearchBarVisible ? Colors.black : Colors.white,
      ),
      onPressed: () {
        onSearchIconPressed(); // Callback pour basculer l'état de la barre de recherche
      },
    );
  }
}



