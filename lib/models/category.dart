import 'package:flutter/material.dart';

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
}
