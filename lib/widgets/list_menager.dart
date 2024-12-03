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
    jsonList.add(json.encode(item.toJson()));
    await prefs.setStringList(_key, jsonList);
  }

  // Pobieranie listy zakupów
  Future<List<GroceryItem>> getItems() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> jsonList = prefs.getStringList(_key) ?? [];
    return jsonList
        .map((jsonStr) => GroceryItem.fromJson(json.decode(jsonStr)))
        .toList();
  }

  Future<void> updateItem(String id, GroceryItem updatedItem) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> jsonList = prefs.getStringList(_key) ?? [];
    for (int i = 0; i < jsonList.length; i++) {
      final item = GroceryItem.fromJson(json.decode(jsonList[i]));
      if (item.id == id) {
        jsonList[i] = json.encode(updatedItem.toJson());
        break;
      }
    }
    await prefs.setStringList(
        _key, jsonList); // Zapisujemy zaktualizowaną listę
  }

  // Usuwanie elementu z listy
  Future<void> removeItem(String id) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> jsonList = prefs.getStringList(_key) ?? [];
    jsonList.removeWhere((jsonStr) {
      final item = GroceryItem.fromJson(json.decode(jsonStr));
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
