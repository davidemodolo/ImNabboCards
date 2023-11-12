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
  int _index = 0; // index of the current big card
  int _usrIndex = 0; // custom index from the user
  bool _showBigCard = false; // show the big card or not

  String _rarityPercentages = // string that contains the percentages and #cards
      "★ 34% ★★ 25% ★★★ 18% ★★★★ 13% ★★★★★ 8% ★★★★★★ 2%\n";

  // function that opens the log file and adds a new line
  void updateLog(String newLog) {
    // log file path from the globals file
    final File logFile = File(globals.logFile);
    // add the newLog line to the file
    logFile.writeAsStringSync("${logFile.readAsStringSync()}\n$newLog");
  }

  int _getRandomIndex() {
    // count for each rarity how many cards are active and have uses > 0
    List<int> rarityIndexes = [0, 0, 0, 0, 0, 0, 0];
    for (NabboCard card in globals.cardsList) {
      if (card.active && // card must be active
          card.rarity > 0 && // card must have a rarity set
          (card.uses > 0 || card.uses == -1) && // card must have some uses left
          card.isMarked()) {
        rarityIndexes[card.rarity] += 1;
      }
    }
    // draw the rarity
    Random random = Random(); // i think this could be a final variable outside
    int rarity = random.nextInt(100);
    int rarityIndex = 0;
    // based on the random number, get the rarity of the future drawn card
    if (rarity < 34) {
      //34%
      rarityIndex = 1;
    } else if (rarity < 59) {
      //25%
      rarityIndex = 2;
    } else if (rarity < 77) {
      //18%
      rarityIndex = 3;
    } else if (rarity < 90) {
      //13%
      rarityIndex = 4;
    } else if (rarity < 98) {
      //8%
      rarityIndex = 5;
    } else {
      //2%
      rarityIndex = 6;
    }

    // check if there are cards with rarity == rarityIndex,
    // otherwise roll to the other rarities (looking first for lower cards)
    while (rarityIndexes[rarityIndex] == 0) {
      rarityIndex -= 1; // start with lower rarities
      if (rarityIndex < 1) {
        // if no card in lower rarities, start with higher
        while (rarityIndexes[rarityIndex] == 0) {
          rarityIndex += 1;
          if (rarityIndex > 6) {
            // if no card in higher rarities, return 0
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
    //TODO: merge this for with the previous one putting the rarityIndex if in the while
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
    // TODO: also merge this for with the first one
    List<int> availableCardsPerIndex = [0, 0, 0, 0, 0, 0];
    for (NabboCard card in globals.cardsList) {
      if (card.active &&
          card.rarity > 0 &&
          (card.uses > 0 || card.uses == -1)) {
        // no card will have rarity 0 so we can do this
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
    final File file = File(globals.cardsJsonDirectory);
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
    final List<String> paths = Directory(globals.cardsImagesDirectory)
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
