import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:shopping_list_app_8_forms/data/categories.dart';
import 'package:shopping_list_app_8_forms/models/grocery_item.dart';
import 'package:shopping_list_app_8_forms/widgets/list_menager.dart';
import 'package:shopping_list_app_8_forms/widgets/new_item.dart';

class GroceryList extends StatefulWidget {
  const GroceryList({super.key});

  @override
  State<GroceryList> createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  late Future<List<GroceryItem>> _loadedItems;
  final GroceryListManager _menager = GroceryListManager();

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  // Funkcja do załadowania elementów
  void _loadItems() {
    setState(() {
      _loadedItems = _menager.getItems();
    });
  }

  Future<void> _addItem(GroceryItem item) async {
    await _menager.addItem(item);
    _loadItems();
  }

  Future<void> _removeItem(GroceryItem item) async {
    await _menager.removeItem(item.id);
    _loadItems();
  }

  Future<void> _clearList() async {
    await _menager.clearList();
    _loadItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            final newItem = await Navigator.of(context).push<GroceryItem>(
              MaterialPageRoute(
                builder: (ctx) => const NewItem(),
              ),
            );
            if (newItem != null) {
              _addItem(newItem);
            }
          },
          label: const Text('Add Item')),
      appBar: AppBar(
          title: const Text(
            'Your Groceries',
          ),
          actions: [
            IconButton(
              onPressed: () {
                _clearList();
              },
              icon: const Icon(Icons.remove),
            ),
          ]),
      body: FutureBuilder(
        future: _loadedItems,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }
          final items = snapshot.data ?? [];
          if (items.isEmpty) {
            return const Center(
              child: Text('No items added to your grocery list.'),
            );
          }
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (ctx, idx) => Dismissible(
              onDismissed: (direction) {
                _removeItem(items[idx]);
              },
              key: ValueKey(items[idx].id),
              child: ListTile(
                title: Text(items[idx].name),
                leading: Container(
                  width: 24,
                  height: 24,
                  color: items[idx].category.categoryColor,
                ),
                trailing: Text(
                  items[idx].quantity.toString(),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
