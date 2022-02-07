// ignore_for_file: avoid_print

import 'package:flip_card/flip_card.dart';

import 'package:flip_cards_game/constants/assets.dart';
import 'package:flip_cards_game/ui/screen/prize-result/prize-result-screen.dart';
import 'package:flutter/material.dart';

class FlipGameItem extends StatelessWidget {
  const FlipGameItem({Key? key, required this.prize}) : super(key: key);
  final String prize;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: FlipCard(
        direction: FlipDirection.HORIZONTAL,
        speed: 1000,
        onFlipDone: (status) {
          print(status);
          if (status) {
            Navigator.of(context).pushReplacementNamed(
                PrizeResultScreen.routeName,
                arguments: prize);
          }
        },
        fill: Fill.fillFront,
        front: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          child: Image.asset(
            Assets.assetsImagesElcaLogo,
            fit: BoxFit.cover,
          ),
        ),
        back: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
          ),
          child:
              Center(child: Text(prize, style: const TextStyle(fontSize: 50))),
        ),
      ),
    );
  }
}
