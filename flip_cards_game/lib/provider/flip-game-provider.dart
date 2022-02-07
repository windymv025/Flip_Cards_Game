import 'package:flutter/cupertino.dart';

class FlipGameProvider with ChangeNotifier {
  final prizeList = [
    '🍎',
    '🍊',
    '🍇',
    '🍒',
    '🍋',
    '🍉',
    '🍊',
    '🍇',
    '🍒',
  ];

  void reloadData() {
    prizeList.shuffle();
    notifyListeners();
  }
}
