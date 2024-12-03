import 'package:flutter/material.dart';
import 'package:shopping_list_app_8_forms/widgets/grocery_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Groceries',
      theme: ThemeData.dark().copyWith(
        appBarTheme: const AppBarTheme(
          toolbarHeight: 100,
          iconTheme: IconThemeData(
            size: 28,
          ),
          titleTextStyle: TextStyle(
            fontSize: 28,
          ),
        ),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 46, 30, 77),
          brightness: Brightness.dark,
          surface: const Color.fromARGB(255, 63, 38, 109),
        ),
        scaffoldBackgroundColor: const Color.fromARGB(255, 27, 15, 48),
      ),
      home: const GroceryList(),
      debugShowCheckedModeBanner: false,
    );
  }
}
