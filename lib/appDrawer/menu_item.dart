import 'package:flutter/material.dart';

class MenuItem {
  final String id;
  final String title;
  final IconData icon;
  final String? route;
  final List<MenuItem>? children;

  MenuItem({
    required this.id,
    required this.title,
    required this.icon,
    this.route,
    this.children,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'],
      title: json['title'],
      icon: json['icon'],//IconData(json['icon'], fontFamily: 'MaterialIcons'),
      route: json['route'],
      children: json['children'] != null
          ? (json['children'] as List)
          .map((child) => MenuItem.fromJson(child))
          .toList()
          : null,
    );
  }
}