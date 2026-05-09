import 'package:flutter/foundation.dart';
import '../core/constants.dart';
import '../models/product.dart';

class ProductProvider extends ChangeNotifier {
  String _selectedCategory = 'All';
  String _searchQuery = '';

  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;

  void selectCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  List<Product> get filteredProducts {
    return AppConstants.products.where((p) {
      final matchesCategory =
          _selectedCategory == 'All' || p.category == _selectedCategory;
      final matchesSearch = _searchQuery.isEmpty ||
          p.name.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }
}
