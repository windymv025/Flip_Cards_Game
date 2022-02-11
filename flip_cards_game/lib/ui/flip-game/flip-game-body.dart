import 'package:flip_card/flip_card_controller.dart';
import 'package:flip_cards_game/models/prize.dart';
import 'package:flip_cards_game/provider/flip-game-provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'flip-game-item.dart';

class FlipGameBody extends StatefulWidget {
  const FlipGameBody({Key? key, required this.prizeList}) : super(key: key);
  final List<Prize> prizeList;

  @override
  _FlipGameBodyState createState() => _FlipGameBodyState();
}

class _FlipGameBodyState extends State<FlipGameBody> {
  final controllers = <FlipCardController>[];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: buildGridItem(),
    );
  }

  Widget buildGridItemV1() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GridView.count(
        crossAxisCount: 3,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
        children: List.generate(widget.prizeList.length, (index) {
          return FlipGameItem(
            prize: widget.prizeList[index],
          );
        }),
      ),
    );
  }

  Widget buildGridItem() {
    return Center(
      child: Column(children: [
        buildRowItem(0),
        buildRowItem(1),
        buildRowItem(2),
        buildRowItem(3),
      ]),
    );
  }

  Widget buildRowItem(int rowNum) {
    return Expanded(
      child: Row(
        children: List.generate(3, (index) {
          return Expanded(
            child: FlipGameItem(
              controller: getFlipCardController(),
              prize: widget.prizeList[rowNum * 3 + index],
              onTap: flipAll,
            ),
          );
        }),
      ),
    );
  }

  FlipCardController getFlipCardController() {
    var flipCardController = FlipCardController();
    controllers.add(flipCardController);
    return flipCardController;
  }

  void flipAll() {
    for (int i = 0; i < controllers.length; i++) {
      final c = controllers[i];
      c.toggleCard();
    }
  }
}
