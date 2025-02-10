// lib/models/menu_item.dart
import 'package:flutter/material.dart';

class MenuItem {
  final String id;
  final String title;
  final IconData icon;
  final String? route;

  MenuItem({
    required this.id,
    required this.title,
    required this.icon,
    this.route,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'] as String,
      title: json['title'] as String,
      icon: json['icon'] as IconData,
      route: json['route'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'icon': icon,
      'route': route,
    };
  }
}