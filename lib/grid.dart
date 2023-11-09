import 'package:flutter/material.dart';
import 'package:imnabbo/small_card.dart';
import 'package:imnabbo/globals.dart' as globals;

class CardGrid extends StatefulWidget {
  const CardGrid({required this.index, super.key});
  final int index;

  @override
  State<CardGrid> createState() => _CardGridState();
}

class _CardGridState extends State<CardGrid> {
  @override
  Widget build(BuildContext context) {
    return Flexible(
      fit: FlexFit.tight,
      child: Container(
        color: Colors.white,
        child: GridView.builder(
          itemCount: globals.cardsList.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            childAspectRatio: 0.4,
          ),
          itemBuilder: (BuildContext context, int i) {
            return SmallCard(
              index: i,
              tf: i == widget.index,
            );
          },
        ),
      ),
    );
  }
}
