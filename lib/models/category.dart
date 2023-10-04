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
}
