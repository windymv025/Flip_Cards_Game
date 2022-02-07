import 'package:flip_cards_game/provider/flip-game-provider.dart';
import 'package:flip_cards_game/ui/screen/game-screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PrizeResultScreen extends StatefulWidget {
  static const routeName = '/prize-result';
  const PrizeResultScreen({Key? key}) : super(key: key);

  @override
  _PrizeResultScreenState createState() => _PrizeResultScreenState();
}

class _PrizeResultScreenState extends State<PrizeResultScreen> {
  @override
  Widget build(BuildContext context) {
    final result = ModalRoute.of(context)!.settings.arguments as String;
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(result, style: const TextStyle(fontSize: 100.0)),
            const SizedBox(height: 50.0),
            ElevatedButton(
                onPressed: () {
                  Provider.of<FlipGameProvider>(context, listen: false)
                      .reloadData();
                  Navigator.of(context)
                      .pushReplacementNamed(GameScreen.routeName);
                },
                child: const Text(
                  'Try again',
                  style: TextStyle(fontSize: 20),
                ))
          ],
        ),
      ),
    );
  }
}
