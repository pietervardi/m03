import 'package:flutter/material.dart';
import 'package:minggu_03/history_list.dart';
import 'package:minggu_03/shopping_list.dart';

class ListProductProvider extends ChangeNotifier {
  List<ShoppingList> _shoppingList = [];
  List<ShoppingList> get getShoppingList => _shoppingList;
  set setShoppingList(value) {
    _shoppingList = value;
    notifyListeners();
  }

  void deleteById(ShoppingList) {
    _shoppingList.remove(ShoppingList);
    notifyListeners();
  }

  List<HistoryList> _historyList = [];
  List<HistoryList> get getHistoryList => _historyList;
  set setHistoryList(value) {
    _historyList = value;
    notifyListeners();
  }
}