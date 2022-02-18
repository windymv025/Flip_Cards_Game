import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
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

    return StreamBuilder<DatabaseEvent>(
        // stream: FirebaseFirestore.instance.collection('prizes').snapshots().map(
        //     (snapshot) => snapshot.docs
        //         .map((doc) => Prize.fromJson(doc.data()))
        //         .toList()),
        stream: FirebaseDatabase.instance.ref("prizes").onValue,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          flipGameProvider.prizes =
              (snapshot.data?.snapshot.value as Map<dynamic, dynamic>)
                  .values
                  .toList()
                  .map((e) => Prize.fromJsonObject(e))
                  .toList();
          flipGameProvider.loadPrizes();

          return Scaffold(
            appBar: AppBar(
              title: const Text('Flip Cards Game'),
            ),
            body: FlipGameBody(
              prizeList: flipGameProvider.prizeList,
            ),
          );
        });
  }
}
