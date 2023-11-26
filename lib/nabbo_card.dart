import 'package:imnabbo/globals.dart' as globals;

class NabboCard {
  void cardDrawn() {
    if (uses == -1) {
      return;
    } else {
      if (uses > 0) {
        uses -= 1;
      }
      if (uses == 0) {
        active = false;
      }
    }
  }

  bool isMarked() {
    return ((globals.activeMarker == marker) ||
        (globals.activeMarker == 0) ||
        (marker == 0));
  }

  void changeMarker() {
    marker = (marker + 1) % 3;
  }

  void changeSound() {
    soundIndex = (soundIndex + 1) % 4;
  }

  String getSound() {
    // return globals.soundToPlay[soundIndex] without the last ".mp3"
    return globals.soundToPlay[soundIndex]
        .substring(0, globals.soundToPlay[soundIndex].length - 4);
  }

  String getMarkerText() {
    switch (marker) {
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

  NabboCard(this.path, this.rarity, this.active, this.uses, this.marker,
      this.soundIndex);
  String path;
  int rarity;
  bool active;
  int uses;
  int marker;
  int soundIndex;
}
