// ignore_for_file: avoid_print

import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flip_cards_game/models/prize.dart';
import 'package:flutter/cupertino.dart';

class FlipGameProvider with ChangeNotifier {
  FlipGameProvider() {
    // _init();
  }
  _init() async {
    var ref = FirebaseDatabase.instance.ref('prizes');
    var event = await ref.once();
    prizes = (event.snapshot.value as Map<dynamic, dynamic>)
        .values
        .toList()
        .map((e) => Prize.fromJsonObject(e))
        .toList();
    ref.onChildAdded.listen((event) {
      prizes.add(
          Prize.fromJsonObject(event.snapshot.value as Map<dynamic, dynamic>));
      notifyListeners();
    });
    for (var p in prizes) {
      ref.child(p.id).onChildChanged.listen((event) {
        p.update(Prize.fromJsonObject(
            event.snapshot.value as Map<dynamic, dynamic>));
        notifyListeners();
      });
    }
    loadPrizes();
  }

  var random = Random();

  final prizeList = <Prize>[];

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

  // Future<Prize> getPrizesForGame_v1() async {
  //   await updateWinGameNumber();
  //   try {
  //     var ref = FirebaseDatabase.instance.ref("prizes");
  //     var snapshot = await ref.get();

  //     print(snapshot.value);
  //     var prizesJson = snapshot.value as Map<dynamic, dynamic>?;
  //     if (prizesJson != null && prizesJson.isNotEmpty) {
  //       var radomIndex = random.nextInt(prizesJson.keys.length);
  //       var key = prizesJson.keys.toList()[radomIndex];

  //       print("key: $key");

  //       await ref.child(key.toString()).remove().catchError((e, s) {
  //         print("remove error: $e");
  //         throw e;
  //       });
  //       Prize prize = Prize.fromJsonObject(prizesJson[key]);
  //       return prize;
  //     } else {
  //       return _prizes.where((element) => element.id == '3').toList()[0];
  //     }
  //   } catch (e) {
  //     print(e);
  //     return _prizes.where((element) => element.id == '3').toList()[0];
  //   }
  // }

  //-------------------------------------------------------------
  Future<Prize> getPrizesForGame() async {
    await updateWinGameNumber();
    if (checkOutOfGift()) {
      return _prizes.where((element) => element.id == '004').toList()[0];
    }
    int index = await generateIndexAlgorithm();
    Prize prize = _prizes[index];
    await decreaseAmount(prize);
    return prize;
  }

  updateWinGameNumber() async {
    var ref = FirebaseDatabase.instance.ref("win_game_number");
    var event = await ref.once();
    var winGameNumber = event.snapshot.value as int;
    await ref.set(winGameNumber + 1).catchError((error, stackTrace) {
      // winGameNumber++;
      // ref.set(winGameNumber + 1);
      updateWinGameNumber();
      print(error);
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

  decreaseAmount(Prize prize) async {
    var ref = FirebaseDatabase.instance.ref("prizes").child(prize.id);
    await ref.update({
      "quantity": prize.quantity! - 1,
    }).catchError((error, stackTrace) {
      decreaseAmount(prize);
      print(error);
    });
  }

  bool checkOutOfGift() {
    for (var i in _prizes) {
      if (i.quantity! > 0) {
        return false;
      }
    }
    return true;
  }

  Future<double> get sumOfRate async {
    await cumulativeSumOfWeight;

    return _cumulativeSum.last;
  }

  final List<double> _cumulativeSum = [];

  Future get cumulativeSumOfWeight async {
    var snapshot = await FirebaseDatabase.instance.ref("sum_weight").get();
    _cumulativeSum.clear();
    _cumulativeSum.addAll(
        (snapshot.value as List).map((e) => double.parse(e.toString())));
    print(_cumulativeSum);

    // (snapshot.value as List<dynamic>)
    //     .map((e) => _cumulativeSum.add(double.tryParse(e.toString()) ?? 0));
  }

  Future<int> generateIndexAlgorithm() async {
    double max = await sumOfRate;
    int rng = Random().nextInt(max.floor());
    for (int i = 0; i < _cumulativeSum.length; i++) {
      if (rng < _cumulativeSum[i]) {
        return i;
      }
    }
    return _cumulativeSum.length - 1;
  }
}
