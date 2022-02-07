import 'package:flip_cards_game/provider/flip-game-provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'flip-game/flip-game-body.dart';

class GameScreen extends StatefulWidget {
  static const String routeName = '/game_screen';
  const GameScreen({Key? key}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  Widget build(BuildContext context) {
    final flipGameProvider = Provider.of<FlipGameProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flip Cards Game'),
        actions: [
          IconButton(
            icon: const Icon(Icons.replay_outlined),
            onPressed: () {
              flipGameProvider.reloadData();
            },
          ),
        ],
      ),
      body: FlipGameBody(
        prizeList: flipGameProvider.prizeList,
      ),
    );
  }
}
