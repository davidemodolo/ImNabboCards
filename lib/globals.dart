import 'package:flutter/material.dart';
import 'package:imnabbo/nabbo_card.dart';
import 'dart:convert';
import 'dart:io';

List<NabboCard> cardsList = [];

const String cardsJsonDirectory = 'data/flutter_assets/assets/cards.json';
const String cardsImagesDirectory = 'data/flutter_assets/assets/cards';
int activeMarker = 0;
const String bgColorFile = 'data/flutter_assets/assets/colorRGB.txt';
const String logFile = 'data/flutter_assets/assets/log.txt';
const List<String> soundToPlay = [
  "default.mp3",
  "positive.mp3",
  "negative.mp3",
  "funny.mp3",
];

Color bgColor = Colors.purple;

void saveJsonState() {
  for (NabboCard card in cardsList) {
    card.path = card.path.replaceAll('\\', '/');
  }
  final List<Map<String, dynamic>> cardsMapList = cardsList
      .map((card) => {
            "path": card.path,
            "rarity": card.rarity,
            "active": card.active,
            "uses": card.uses,
            "marker": card.marker,
            "sound": card.soundIndex
          })
      .toList();
  final Map<String, dynamic> jsonMap = {"cards": cardsMapList};
  final String jsonString = json.encode(jsonMap);
  final File file = File(cardsJsonDirectory);
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
