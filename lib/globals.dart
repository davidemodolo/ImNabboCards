import 'package:imnabbo/nabbo_card.dart';
import 'dart:convert';
import 'dart:io';

List<NabboCard> cardsList = [];

String cardsJsonDirectory = 'assets/cards.json';
String cardsImagesDirectory = 'assets/cards';

void saveJsonState() {
  // apply replaceAll('\\', '/') to every path
  for (NabboCard card in cardsList) {
    card.path = card.path.replaceAll('\\', '/');
  }
  final List<Map<String, dynamic>> cardsMapList = cardsList
      .map((card) => {
            "path": card.path,
            "rarity": card.rarity,
            "active": card.active,
            "uses": card.uses,
          })
      .toList();
  final Map<String, dynamic> jsonMap = {"cards": cardsMapList};
  final String jsonString = json.encode(jsonMap);
  final File file = File("data/flutter_assets/$cardsJsonDirectory");
  file.writeAsStringSync(jsonString);
}
