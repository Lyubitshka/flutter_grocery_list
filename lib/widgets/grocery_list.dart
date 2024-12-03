import 'package:flutter/material.dart';
import 'package:shopping_list_app_8_forms/data/categories.dart';
import 'package:shopping_list_app_8_forms/models/category.dart';
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
  List<GroceryItem> _items = [];
  String _searchQuery = '';
  Category? _selectedFilterCategory;
  bool _isAscending = true;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  // Funkcja do załadowania elementów
  void _loadItems() {
    setState(() {
      _loadedItems = _menager.getItems().then((items) {
        _items = items;
        _applyFilters();
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
        _filteredItems = _items.where((item) {
          final matchesQuery = item.name.toLowerCase().contains(_searchQuery) ||
              item.category.title.toLowerCase().contains(_searchQuery);
          final matchesCategory = _selectedFilterCategory == null ||
              item.category == _selectedFilterCategory;
          return matchesQuery && matchesCategory;
        }).toList();
      }
    });
  }

  void _filterByCategory(Category? category) {
    setState(() {
      _selectedFilterCategory = category;

      if (_selectedFilterCategory == null) {
        // Jeśli wybrano "All Categories", zresetuj filtr
        _filteredItems = _items.where((item) {
          final matchesQuery = _searchQuery.isEmpty ||
              item.name.toLowerCase().contains(_searchQuery) ||
              item.category.title.toLowerCase().contains(_searchQuery);
          return matchesQuery;
        }).toList();
      } else {
        // Filtruj według wybranej kategorii
        _filteredItems = _items.where((item) {
          final matchesCategory = item.category == _selectedFilterCategory;
          final matchesQuery = _searchQuery.isEmpty ||
              item.name.toLowerCase().contains(_searchQuery) ||
              item.category.title.toLowerCase().contains(_searchQuery);
          return matchesCategory && matchesQuery;
        }).toList();
      }
    });
  }

  void _applyFilters() {
    setState(() {
      _filteredItems = _items.where((item) {
        final matchesQuery = _searchQuery.isEmpty ||
            item.name.toLowerCase().contains(_searchQuery) ||
            item.category.title.toLowerCase().contains(_searchQuery);
        final matchesCategory = _selectedFilterCategory == null ||
            item.category == _selectedFilterCategory;
        return matchesQuery && matchesCategory;
      }).toList();
    });
  }

  void _sortByCategory() {
    setState(() {
      _filteredItems.sort((a, b) {
        return _isAscending
            ? a.category.title.compareTo(b.category.title)
            : b.category.title.compareTo(a.category.title);
      });
      _isAscending = !_isAscending;
    });
  }

  Future<void> _addItem(GroceryItem item) async {
    await _menager.addItem(item);
    _loadItems();
  }

  Future<void> _updateItem(String id, GroceryItem updatedItem) async {
    await _menager.updateItem(id, updatedItem);
    _loadItems();
  }

  Future<void> _removeItem(GroceryItem item) async {
    await _menager.removeItem(item.id);
    _loadItems();
    _applyFilters();
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
          IconButton(
            icon: const Icon(Icons.sort),
            onPressed: _sortByCategory,
            tooltip: 'Sort by category',
          ),
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
            iconAlignment: IconAlignment.end,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search items...',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _filterItems('');
                          _filterByCategory(null); // Resetuj filtr
                        },
                      ),
                    ),
                    onChanged: _filterItems,
                  ),
                ),
              ),
              // const SizedBox(width: 8),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12),
                child: DropdownButton<Category?>(
                  value: _selectedFilterCategory,
                  hint: const Text('Category'),
                  items: [
                    const DropdownMenuItem<Category?>(
                      value: null,
                      child: Text('All Categories'),
                    ),
                    ...categories.values.map((category) {
                      return DropdownMenuItem<Category>(
                        value: category,
                        child: Row(
                          children: [
                            Container(
                              width: 16,
                              height: 16,
                              color: category.categoryColor,
                            ),
                            const SizedBox(width: 6),
                            Text(category.title),
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                  onChanged: _filterByCategory,
                ),
              ),
            ],
          ),
        ),
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
          final items = _filteredItems;
          if (items.isEmpty) {
            return const Center(
              child: Text('No items added to your grocery list.'),
            );
          }
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (ctx, idx) => Dismissible(
              background: Container(
                color: Colors.red,
                child: const Icon(Icons.cancel),
              ),
              // secondaryBackground: Container(
              //   color: Colors.lightBlueAccent,
              //   child: const Icon(Icons.edit),
              // ),
              onDismissed: (direction) {
                _removeItem(items[idx]);
              },
              key: ValueKey(items[idx].id),
              child: ListTile(
                title: Text(
                  items[idx].name,
                  style: const TextStyle(fontSize: 18),
                ),
                leading: Container(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: items[idx].category.categoryColor),
                  width: 24,
                  height: 24,
                  // color: items[idx].category.categoryColor,
                ),
                trailing: Text(
                  items[idx].quantity.toString(),
                  style: const TextStyle(fontSize: 22),
                ),
                mouseCursor: MouseCursor.defer,
                onTap: () async {
                  final updatedItem =
                      await Navigator.of(context).push<GroceryItem>(
                    MaterialPageRoute(
                      builder: (ctx) => NewItem(existingItem: items[idx]),
                    ),
                  );
                  if (updatedItem != null) {
                    await _updateItem(items[idx].id, updatedItem);
                    _loadItems();
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
