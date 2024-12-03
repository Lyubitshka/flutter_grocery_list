import 'dart:convert';
import 'package:shopping_list_app_8_forms/data/categories.dart';
import 'package:shopping_list_app_8_forms/models/category.dart';

class GroceryItem {
  GroceryItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.category,
  });
  final String id;
  final String name;
  final int quantity;
  final Category category;

  // // Convert to Map for JSON serialization
  // Map<String, dynamic> toMap() {
  //   return {
  //     'id': id,
  //     'name': name,
  //     'quantity': quantity,
  //     'category': category.toMap(),
  //   };
  // }

  // // Convert from Map (JSON deserialization)
  // factory GroceryItem.fromMap(Map<String, dynamic> map) {
  //   return GroceryItem(
  //     id: map['id'],
  //     name: map['name'],
  //     quantity: map['quantity'],
  //     category: Category.fromMap(map['category']),
  //   );
  // }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'category': category.title, // Zapisujemy tylko tytuł kategorii
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
    );
  }
  // // Convert to JSON
  // String toJson() => json.encode(toMap());

  // // Convert from JSON
  // factory GroceryItem.fromJson(String source) =>
  //     GroceryItem.fromMap(json.decode(source));
}
