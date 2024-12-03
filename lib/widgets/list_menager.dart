// Klasa zarządzająca listą zakupów
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopping_list_app_8_forms/models/grocery_item.dart';

class GroceryListManager {
  static const String _key = 'grocery_list';

  // Dodawanie elementu do listy
  Future<void> addItem(GroceryItem item) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> jsonList = prefs.getStringList(_key) ?? [];
    jsonList.add(json.encode(item.toMap()));
    await prefs.setStringList(_key, jsonList);
  }

  // Pobieranie listy zakupów
  Future<List<GroceryItem>> getItems() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> jsonList = prefs.getStringList(_key) ?? [];
    return jsonList
        .map((jsonStr) => GroceryItem.fromMap(json.decode(jsonStr)))
        .toList();
  }

  // Usuwanie elementu z listy
  Future<void> removeItem(String id) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> jsonList = prefs.getStringList(_key) ?? [];
    jsonList.removeWhere((jsonStr) {
      final item = GroceryItem.fromMap(json.decode(jsonStr));
      return item.id == id;
    });
    await prefs.setStringList(_key, jsonList);
  }

  // Czyszczenie całej listy
  Future<void> clearList() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
