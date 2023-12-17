import 'package:flutter/material.dart';
import 'package:imnabbo/globals.dart' as globals;

class SmallCard extends StatefulWidget {
  final int index;
  final bool tf;
  const SmallCard({super.key, required this.index, required this.tf});

  @override
  State<SmallCard> createState() => _SmallCardState();
}

class _SmallCardState extends State<SmallCard> {
  bool isActive = true;
  int rarityIndex = 0;

  void _cycleRarity() {
    setState(() {
      rarityIndex = (globals.cardsList[widget.index].rarity % 6) + 1;
      globals.cardsList[widget.index].rarity = rarityIndex;
    });
    globals.saveJsonState();
  }

  @override
  Widget build(BuildContext context) {
    globals.saveJsonState();

    List<Widget> rarityIcons = List.generate(
      5,
      (index) => SizedBox(
        width: 20,
        height: 20,
        child: Icon(
          index < globals.cardsList[widget.index].rarity
              ? Icons.star
              : Icons.star_border,
          color: globals.cardsList[widget.index].rarity == -1
              ? Colors.red
              : globals.cardsList[widget.index].rarity == 6
                  ? Colors.green
                  : Colors.amber,
        ),
      ),
    );
    return GestureDetector(
      onLongPress: () {
        setState(() {
          isActive = !globals.cardsList[widget.index].active;
          globals.cardsList[widget.index].active = isActive;
          globals.saveJsonState();
        });
      },
      onTap: () => setState(() {
        _cycleRarity();
        globals.saveJsonState();
      }),
      child: Container(
        margin: const EdgeInsets.all(2),
        child: Column(
          children: [
            Container(
              width: globals.cardsList[widget.index].active ? 200 : 150,
              decoration: BoxDecoration(
                border: Border.all(
                  color: widget.tf
                      ? Colors.green
                      : globals.cardsList[widget.index].rarity == -1
                          ? Colors.red
                          : Colors.transparent,
                  width: 5,
                ),
              ),
              child: Stack(
                children: [
                  ColorFiltered(
                    colorFilter: !globals.cardsList[widget.index].active
                        ? const ColorFilter.mode(
                            Colors.grey,
                            BlendMode.saturation,
                          )
                        : const ColorFilter.mode(
                            Colors.transparent,
                            BlendMode.saturation,
                          ),
                    child: Image(
                      image: AssetImage(
                        globals.cardsList[widget.index].path,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 5,
                    right: 5,
                    child: Text(
                      widget.index.toString(),
                      style: TextStyle(
                        color: globals.bgColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          globals.cardsList[widget.index].changeMarker();
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            globals.cardsList[widget.index].isMarked()
                                ? Colors.green
                                : Colors.red,
                      ),
                      child: Text(
                        globals.cardsList[widget.index].getMarkerText(),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          globals.cardsList[widget.index].changeSound();
                        });
                      },
                      // style: ElevatedButton.styleFrom(
                      //   backgroundColor: globals.cardsList[widget.index].isMarked()
                      //       ? Colors.green
                      //       : Colors.red,
                      // ),
                      child: Text(
                        globals.cardsList[widget.index].getSound(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: rarityIcons,
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (globals.cardsList[widget.index].uses > -1) {
                          setState(() {
                            globals.cardsList[widget.index].uses -= 1;
                          });
                        }
                      },
                      child: const Text("-"),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Text(
                      globals.cardsList[widget.index].uses.toString(),
                      style: const TextStyle(
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          globals.cardsList[widget.index].uses += 1;
                        });
                      },
                      child: const Text("+"),
                    ),
                  ],
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
