import 'package:flip_cards_game/ui/screen/game-screen.dart';
import 'package:flip_cards_game/ui/screen/prize-result/prize-result-screen.dart';
import 'package:flutter/material.dart';

final routes = <String, WidgetBuilder>{
  PrizeResultScreen.routeName: (context) => const PrizeResultScreen(),
  GameScreen.routeName: (context) => const GameScreen(),
};
