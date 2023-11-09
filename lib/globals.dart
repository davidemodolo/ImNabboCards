import 'package:imnabbo/nabbo_card.dart';
import 'dart:convert';
import 'dart:io';

List<NabboCard> cardsList = [];

String cardsJsonDirectory = 'assets/cards.json';
String cardsImagesDirectory = 'assets/cards';
int activeMarker = 0;

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
            "marker": card.marker
          })
      .toList();
  final Map<String, dynamic> jsonMap = {"cards": cardsMapList};
  final String jsonString = json.encode(jsonMap);
  final File file = File("data/flutter_assets/$cardsJsonDirectory");
  file.writeAsStringSync(jsonString);
}

void rollMarker() {
  // roll activeMarker between 0, 1, 2
  activeMarker = (activeMarker + 1) % 3;
}

String getMarkerText() {
  switch (activeMarker) {
    case 0:
      return "All";
    case 1:
      return "A";
    case 2:
      return "B";
    default:
      return "Error";
  }
}
