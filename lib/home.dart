import 'package:flutter/material.dart';
import 'package:imnabbo/nabbo_card.dart';
import 'package:imnabbo/big_card.dart';
import 'package:imnabbo/grid.dart';
import 'package:imnabbo/globals.dart' as globals;
import 'package:audioplayers/audioplayers.dart';
import 'dart:convert';
import 'dart:io';
import 'dart:math';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;
  int _usrIndex = 0;
  bool _showBigCard = false;

  String _rarityPercentages =
      "★ 34% ★★ 25% ★★★ 18% ★★★★ 13% ★★★★★ 8% ★★★★★★ 2%\n";

  void updateLog(String newLog) {
    final File logFile = File('data/flutter_assets/assets/log.txt');
    // add the newLog line to the file
    logFile.writeAsStringSync("${logFile.readAsStringSync()}\n$newLog");
  }

  int _getRandomIndex() {
    // 1 = 34%, 2 = 25%, 3 = 18%, 4 = 13%, 5 = 8%, 6 = 2%
    // draw the rarity
    Random random = Random();
    int rarity = random.nextInt(100);
    int rarityIndex = 0;
    // count for each rarity how many cards are active and have uses > 0
    List<int> rarityIndexes = [0, 0, 0, 0, 0, 0, 0];
    for (NabboCard card in globals.cardsList) {
      if (card.active &&
          card.rarity > 0 &&
          (card.uses > 0 || card.uses == -1) &&
          card.isMarked()) {
        rarityIndexes[card.rarity] += 1;
      }
    }

    if (rarity < 34) {
      rarityIndex = 1;
    } else if (rarity < 59) {
      rarityIndex = 2;
    } else if (rarity < 77) {
      rarityIndex = 3;
    } else if (rarity < 90) {
      rarityIndex = 4;
    } else if (rarity < 98) {
      rarityIndex = 5;
    } else {
      rarityIndex = 6;
    }

    while (rarityIndexes[rarityIndex] == 0) {
      rarityIndex -= 1;
      if (rarityIndex < 1) {
        while (rarityIndexes[rarityIndex] == 0) {
          rarityIndex += 1;
          if (rarityIndex > 6) {
            setState(() {
              _rarityPercentages = "No card found";
            });
            return 0;
          }
        }
        break;
      }
    }

    // get the list of indexes of cards with rarity == rarityIndex

    List<int> indexes = [];
    for (NabboCard card in globals.cardsList) {
      if (card.active &&
          card.rarity == rarityIndex &&
          (card.uses > 0 || card.uses == -1) &&
          card.isMarked()) {
        indexes.add(globals.cardsList.indexOf(card));
      }
    }
    int newIndex = indexes[random.nextInt(indexes.length)];
    // setState(() {
    //   rarityPercentages = "$rarityIndex, $newIndex, ${indexes.length}";
    // });

    List<int> availableCardsPerIndex = [0, 0, 0, 0, 0, 0];
    for (NabboCard card in globals.cardsList) {
      if (card.active &&
          card.rarity > 0 &&
          (card.uses > 0 || card.uses == -1)) {
        // no card will have rarity 0
        availableCardsPerIndex[card.rarity - 1] += 1;
      }
    }

    String newText = "";
    for (int i = 0; i < availableCardsPerIndex.length; i++) {
      for (int s = 0; s <= i; s++) {
        newText += "★";
      }
      newText += " ${availableCardsPerIndex[i]}";
    }
    _rarityPercentages = "★ 34% ★★ 25% ★★★ 18% ★★★★ 13% ★★★★★ 8% ★★★★★★ 2%\n";
    setState(() {
      _rarityPercentages += newText;
    });

    // get current time
    final DateTime now = DateTime.now();
    // set it as DAY/MONTH/YEAR HOUR:MINUTE:SECOND
    final String formattedDate =
        "${now.day}/${now.month}/${now.year} ${now.hour}:${now.minute}:${now.second}";
    // update the log file
    final String newLog =
        "$formattedDate - ${globals.cardsList[_index].path} -[$_index]";
    updateLog(newLog);

    return newIndex;
  }

  String fixPath(path) {
    return path.replaceAll('\\', '/');
  }

  @override
  Widget build(BuildContext context) {
    // 1. read the cards.json file if it exists, otherwise create it
    final File file = File("data/flutter_assets/${globals.cardsJsonDirectory}");
    if (!file.existsSync()) {
      file.createSync();
      final Map<String, dynamic> jsonMap = {"cards": []};
      final String jsonString = json.encode(jsonMap);
      file.writeAsStringSync(jsonString);
    }
    final cards = json.decode(file.readAsStringSync());
    // 2. create the list of Card objcects
    globals.cardsList = cards["cards"]
        .map<NabboCard>((e) => NabboCard(
            e["path"], e["rarity"], e["active"], e["uses"], e["marker"]))
        .toList();
    // 3. read all the .png in the assets/cards
    final List<String> paths =
        Directory("data/flutter_assets/${globals.cardsImagesDirectory}")
            .listSync()
            .map((e) => e.path)
            .toList();

    //4. remove from the cardsList any card that is not in the paths list
    globals.cardsList.removeWhere((card) =>
        !paths.any((path) => card.path == fixPath(path).substring(20)));
    // for each path in paths, check if there is a card with that path in the cardsList
    // if not, add it to the cardsList
    for (String path in paths) {
      if (!globals.cardsList
          .any((card) => card.path == fixPath(path).substring(20))) {
        globals.cardsList.add(NabboCard(path.substring(20), -1, true, 0, 1));
        // print("Added card with path $path");
      }
    }

    globals.saveJsonState();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          fit: FlexFit.tight,
          child: Column(
            children: [
              BigNabboCard(_index, _showBigCard),
              const SizedBox(
                height: 40,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          final player = AudioPlayer();
                          await player.play(
                            AssetSource('roll.mp3'),
                          );
                          setState(() {
                            _index = _getRandomIndex();
                            globals.cardsList[_index].cardDrawn();
                            globals.saveJsonState();
                            _showBigCard = true;
                          });

                          // wait a second and set _showBigCard to false
                          await Future.delayed(const Duration(seconds: 1));
                          setState(() {
                            _showBigCard = false;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 20,
                          ),
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          "ROLL",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            globals.rollMarker();
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 20,
                          ),
                          backgroundColor: Colors.amber,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          globals.getMarkerText(),
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 40,
                  ),
                  Column(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _showBigCard = true;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 20,
                          ),
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          "LAST",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _showBigCard = false;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 20,
                          ),
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          "CLEAR",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 40,
                  ),
                  Column(
                    children: [
                      SizedBox(
                        width: 90,
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              _usrIndex = int.parse(value);
                            });
                          },
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Index',
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (_usrIndex < globals.cardsList.length) {
                            setState(() {
                              _index = _usrIndex;
                              _showBigCard = true;
                            });
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 40,
                            vertical: 20,
                          ),
                          backgroundColor: Colors.purple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          "SHOW",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                _rarityPercentages,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              )
            ],
          ),
        ),
        CardGrid(index: _index),
      ],
    );
  }
}
