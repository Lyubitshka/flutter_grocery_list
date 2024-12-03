import 'dart:convert';

import 'package:shopping_list_app_8_forms/data/categories.dart';
import 'package:shopping_list_app_8_forms/models/category.dart';

class GroceryItem {
  GroceryItem(
      {required this.id,
      required this.name,
      required this.quantity,
      required this.category,
      this.isChecked = false});
  final String id;
  final String name;
  final int quantity;
  final Category category;
  bool isChecked;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'category': category.title,
      'isChexked': isChecked // Zapisujemy tylko tytuł kategorii
    };
  }

  static GroceryItem fromMap(Map<String, dynamic> map) {
    final category = categories.entries
        .firstWhere((entry) => entry.value.title == map['category'])
        .value; // Odtwarzamy kategorię na podstawie tytułu

    return GroceryItem(
      id: map['id'],
      name: map['name'],
      quantity: map['quantity'],
      category: category,
      isChecked: map['isChecked'] ?? false,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      "name": name,
      'quantity': quantity,
      'category': category.toJson(),
      'isChecked': isChecked,
    };
  }

  factory GroceryItem.fromJson(Map<String, dynamic> json) {
    return GroceryItem(
      id: json['id'],
      name: json['name'],
      quantity: json['quantity'],
      category: Category.fromJson(json['category']),
      isChecked: json['isChecked'] ?? false,
    );
  }

  // Convert from JSON
  // factory GroceryItem.fromJson(String source) =>
  //     GroceryItem.fromMap(json.decode(source));
}
