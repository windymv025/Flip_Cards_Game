import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flip_cards_game/models/prize.dart';
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
    final provider = Provider.of<FlipGameProvider>(context);
    return StreamBuilder<List<Prize>>(
        stream: FirebaseFirestore.instance.collection('prizes').snapshots().map(
            (snapshot) => snapshot.docs
                .map((doc) => Prize.fromJson(doc.data()))
                .toList()),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          provider.prizes = snapshot.data;
          provider.loadPrizes();

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
        });
  }
}
