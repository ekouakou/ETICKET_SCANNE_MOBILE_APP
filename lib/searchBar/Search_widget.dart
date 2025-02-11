// search_widget.dart
import 'package:flutter/material.dart';

class SearchWidget<T> extends StatefulWidget {
  final List<T> items;
  final List<T> filteredItems;
  final Function(String) onSearch;
  final String hintText;
  final Widget Function(BuildContext, List<T>) buildResults;

  const SearchWidget({
    Key? key,
    required this.items,
    required this.filteredItems,
    required this.onSearch,
    required this.buildResults,
    this.hintText = 'Rechercher',
  }) : super(key: key);

  @override
  SearchWidgetState<T> createState() => SearchWidgetState<T>();
}

class SearchWidgetState<T> extends State<SearchWidget<T>> {
  bool isSearchVisible = false;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    searchController.addListener(_onSearchChanged);
  }

  void _onSearchChanged() {
    widget.onSearch(searchController.text);
  }

  void toggleSearch() {
    setState(() {
      isSearchVisible = !isSearchVisible;
      if (!isSearchVisible) {
        searchController.clear();
        widget.onSearch('');
      }
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedContainer(
          duration: Duration(milliseconds: 300),
          height: isSearchVisible ? 60.0 : 0.0,
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: isSearchVisible
              ? TextField(
            controller: searchController,
            decoration: InputDecoration(
              hintText: widget.hintText,
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20.0),
              ),
            ),
          )
              : null,
        ),
        Expanded(
          child: widget.buildResults(context, widget.filteredItems),
        ),
      ],
    );
  }
}