import 'package:flip_cards_game/provider/flip-game-provider.dart';
import 'package:flip_cards_game/ui/screen/game-screen.dart';
import 'package:flip_cards_game/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => FlipGameProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Flip Cards Game',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const GameScreen(),
        routes: routes,
      ),
    );
  }
}
