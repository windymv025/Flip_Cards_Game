import 'dart:async';

import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';

import 'package:flip_cards_game/constants/assets.dart';
import 'package:flip_cards_game/models/prize.dart';
import 'package:flip_cards_game/provider/flip-game-provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FlipGameItem extends StatefulWidget {
  const FlipGameItem(
      {Key? key, required this.prize, this.controller, this.onTap})
      : super(key: key);
  final Prize prize;
  final FlipCardController? controller;
  final Function? onTap;

  @override
  _FlipGameItemState createState() => _FlipGameItemState();
}

class _FlipGameItemState extends State<FlipGameItem> {
  bool _isFocus = false;
  late Prize _prize;
  late FlipGameProvider provider;
  @override
  void initState() {
    super.initState();
    _prize = widget.prize;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    provider = Provider.of<FlipGameProvider>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: FlipCard(
        controller: widget.controller,
        direction: FlipDirection.HORIZONTAL,
        speed: 1000,
        flipOnTouch: false,
        onFlipDone: (status) {
          if (!status) {
            setState(() {
              _isFocus = false;
            });
          }
        },
        fill: Fill.fillFront,
        front: InkWell(
          onTap: () async {
            _prize = await provider.getPrizesForGame();

            setState(() {
              _isFocus = true;
            });

            widget.onTap?.call();
            Timer(const Duration(seconds: 1), () => showPrize());
          },
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
            child: Image.asset(
              Assets.assetsImagesElcaLogo,
              fit: BoxFit.cover,
            ),
          ),
        ),
        back: Container(
          decoration: BoxDecoration(
            border: _isFocus
                ? const Border(
                    top: BorderSide(width: 1.0, color: Colors.blue),
                    left: BorderSide(width: 1.0, color: Colors.blue),
                    right: BorderSide(width: 1.0, color: Colors.blue),
                    bottom: BorderSide(width: 1.0, color: Colors.blue),
                  )
                : null,
            borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          ),
          child: Center(
            child: Image.network(
              _prize.imageUrl!,
              fit: BoxFit.scaleDown,
            ),
          ),
        ),
      ),
    );
  }

  void showPrize() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Center(child: Text('Your prize is')),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.network(
                  _prize.imageUrl!,
                  fit: BoxFit.scaleDown,
                ),
                const SizedBox(height: 10),
                Center(
                  child: Text(_prize.name ?? "",
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
            actions: <Widget>[
              Center(
                child: ElevatedButton(
                  child: const Text('Try again'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    widget.onTap?.call();
                    provider.reloadData();
                  },
                ),
              ),
            ],
          );
        });
  }
}
