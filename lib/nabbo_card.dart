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

  NabboCard(this.path, this.rarity, this.active, this.uses);
  String path;
  int rarity;
  bool active;
  int uses;
}
