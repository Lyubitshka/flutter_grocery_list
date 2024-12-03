import 'package:flutter/material.dart';
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
  final TextEditingController _searchController = TextEditingController();
  List<GroceryItem> _filteredItems = [];
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  // Funkcja do załadowania elementów
  void _loadItems() {
    setState(() {
      _loadedItems = _menager.getItems().then((items) {
        _filteredItems = items;
        return items;
      });
    });
  }

  void _filterItems(String query) {
    setState(() {
      _searchQuery = query.toLowerCase();
      if (_searchQuery.isEmpty) {
        _loadedItems.then((items) {
          _filteredItems = items;
        });
      } else {
        _filteredItems = _filteredItems.where((item) {
          return item.name.toLowerCase().contains(_searchQuery) ||
              item.category.title.toLowerCase().contains(_searchQuery);
        }).toList();
      }
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
        label: const Text(
          'Add Item',
          style: TextStyle(fontSize: 22),
        ),
        icon: const Icon(Icons.add_box_rounded),
      ),
      appBar: AppBar(
        title: const Text(
          'Your Groceries',
        ),
        actions: [
          TextButton.icon(
            onPressed: () {
              _clearList();
            },
            label: const Text(
              'Clear list',
              style: TextStyle(fontSize: 16),
            ),
            icon: const Icon(
              Icons.remove_circle_outline,
            ),
          ),
        ],
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(50),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search items...',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    onPressed: () {
                      _searchController.clear();
                      _filterItems('');
                    },
                    icon: const Icon(Icons.clear),
                  ),
                ),
                onChanged: _filterItems,
              ),
            )),
      ),
      body: FutureBuilder(
        future: _loadedItems,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          }

          if (_filteredItems.isEmpty) {
            return const Center(
              child: Text('No items added to your grocery list.'),
            );
          }
          return ListView.builder(
            itemCount: _filteredItems.length,
            itemBuilder: (ctx, idx) => Dismissible(
              onDismissed: (direction) {
                _removeItem(_filteredItems[idx]);
              },
              key: ValueKey(_filteredItems[idx].id),
              child: ListTile(
                title: Text(_filteredItems[idx].name),
                leading: Container(
                  width: 24,
                  height: 24,
                  color: _filteredItems[idx].category.categoryColor,
                ),
                trailing: Text(
                  _filteredItems[idx].quantity.toString(),
                  style: const TextStyle(fontSize: 18),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
