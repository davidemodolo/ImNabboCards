<div style="text-align:center;">
    <img src="https://user-images.githubusercontent.com/25181517/186150365-da1eccce-6201-487c-8649-45e9e99435fd.png" alt="FlutterIcon" width="20" style="margin: 10px;" />
    <img src="https://user-images.githubusercontent.com/25181517/186150304-1568ffdf-4c62-4bdc-9cf1-8d8efcea7c5b.png" alt="DartIcon" width="20" style="margin: 10px;" />
    <img src="https://user-images.githubusercontent.com/25181517/186884150-05e9ff6d-340e-4802-9533-2c3f02363ee3.png" alt="WindowsIcon" width="20" style="margin: 10px;" />
</div>


----

**Before running:**
1. put all `.png` in the `data\flutter_assets\assets\cards` folder (<u>at least one card; no whitespace characters in the names</u>);
2. put a .mp3 file in the `data\flutter_assets\assets` folder;
3. write the RGB color for the background in the `data\flutter_assets\assets\colorRGB.txt` file;
4. start the program.

**Setup:**
- long press on a card to add/remove (enable/disable) it from the pool;
- single press on a card to increase its rarity (1 to 6 and back);
- set the number of times a card can be drawn, set as `-1` if unlimited;
- set the marker of each card as A or B.

**Draw steps:**
1. play the `.mp3` file;
2. randomly select a rarity;
3. randomly select a card of such rarity;
4. 1.5s animation "from the right" that makes the drawn card appear;
5. the card stays for 45 seconds;
6. hide the card;
7. add the drawn card to the log file;
8. reduce by one the number of uses left and disable the card if it reaches `0`.

If there isn't any available card of the randomly selected rarity, it first checks the lower rarities and then the higher rarities.
> _e.g.: if Rarity 4 is selected and it has no cards, the check order is 3-2-1-5-6. If there isn't any card available, it returns the first card whether is active/drawable or not._

The pool can be made by **A** cards, **B** cards or **both**.

**Functions:**
- DRAW: draws a card, shows it and, after 45 seconds, hides it
- ALL/A/B: set the marker from which draw the random card
- LAST: show the last card drawn (until clear)
- CLEAR: hide the current big card
- INDEX: set the index of a specific card
- SHOW: show the card of the specified index that <u>ovverides the last card</u> (until clear)

Folders structure:

*TODO*

JSON structure:
```
{
  "cards": [
    {
      "path": "path_to_card_image.png",
      "rarity": 1, // from 1 to 5, 0 if the card is new
      "active": true, // if active in the card pool
      "uses": 1, // uses left
      "marker": 1 // 1 = A, 2 = B
    },
    .
    .
    .
  ]
}

```

## TODO
- [x] show last drawn card - time unlimited
- [x] show a specific card - time unlimited
- [x] decide a number of markers
- [x] ask for screen resolution
- [x] ask again for check order if no card available
- [x] OBS smoothness 840 nice glowing effect
- [x] draw with index overrides LAST