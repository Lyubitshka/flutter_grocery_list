import 'package:flutter/material.dart';
import 'package:shopping_list_app_8_forms/data/categories.dart';

enum Categories {
  vegetables,
  fruit,
  meat,
  dairy,
  carbs,
  sweets,
  spices,
  convenience,
  hygiene,
  other,
}

class Category {
  Category(
    this.title,
    this.categoryColor,
  );

  final String title;
  final Color categoryColor;

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'categotyColor': categoryColor.value,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      map['title'],
      Color(map['categoryColor']),
    );
  }
  factory Category.fromJson(String catKey) {
    final category = Categories.values.firstWhere(
      (e) => e.name == catKey,
      orElse: () => Categories.other,
    );
    return categories[category]!;
  }

  String toJson() {
    return categories.entries
        .firstWhere((entry) => entry.value.title == title)
        .key
        .name;
  }
}
