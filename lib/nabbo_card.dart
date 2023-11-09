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
    return ((globals.activeMarker == marker) || (globals.activeMarker == 0));
  }

  void changeMarker() {
    marker = (marker == 1) ? 2 : 1;
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

  NabboCard(this.path, this.rarity, this.active, this.uses, this.marker);
  String path;
  int rarity;
  bool active;
  int uses;
  int marker;
}
