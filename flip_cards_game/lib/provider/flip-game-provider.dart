import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flip_cards_game/models/prize.dart';
import 'package:flutter/cupertino.dart';

class FlipGameProvider with ChangeNotifier {
  var random = Random();

  final prizeList = <Prize>[];

  // '🍎',
  //   '🍊',
  //   '🍇',
  //   '🍒',
  //   '🍋',
  //   '🍉',
  //   '🍊',
  //   '🍇',
  //   '🍒',
  //   '🍊',
  //   '🍇',
  //   '🍒',

  final List<Prize> _prizes = [];
  List<Prize> get prizes {
    return _prizes;
  }

  set prizes(List<Prize>? prizes) {
    _prizes.clear();
    if (prizes != null) {
      _prizes.addAll(prizes);
    }
  }

  void reloadData() {
    prizeList.shuffle();
    notifyListeners();
  }

  Future<Prize> getPrizesForGame() async {
    var ref = FirebaseDatabase.instance.ref("prizes");
    var snapshot = await ref.get();
    // ignore: avoid_print
    print(snapshot.value);
    var prizesJson = snapshot.value as Map<dynamic, dynamic>?;
    if (prizesJson != null && prizesJson.isNotEmpty) {
      var radomIndex = random.nextInt(prizesJson.keys.length);
      var key = prizesJson.keys.toList()[radomIndex];

      // ignore: avoid_print
      print("key: $key");

      await ref.child(key.toString()).remove();
      updateWinGameNumber();
      Prize prize = Prize.fromJsonObject(prizesJson[key]);
      return prize;
    } else {
      return _prizes.where((element) => element.id == '3').toList()[0];
    }
  }

  void updateWinGameNumber() {
    var ref = FirebaseDatabase.instance.ref("win_game_number");
    ref.once().then((event) {
      var winGameNumber = event.snapshot.value as int;
      ref.set(winGameNumber + 1);
    });
  }

  loadPrizes() {
    if (_prizes.length >= 12) {
      _prizes.shuffle();
      return _prizes.sublist(0, 12);
    }
    var list = <Prize>[];
    for (var p in _prizes) {
      list.add(p);
    }
    for (var i = _prizes.length - 1; i < 12; i++) {
      list.add(_prizes[random.nextInt(_prizes.length)]);
    }
    list.shuffle();
    prizeList.clear();
    prizeList.addAll(list);
  }
}
