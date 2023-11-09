**Before running:**
1. put all `.png` in the `data\flutter_assets\assets\cards` folder (<u>AT LEAST ONE</u>);
2. put a .mp3 file in the `data\flutter_assets\assets` folder;
3. write the RGB color for the background in the `data\flutter_assets\assets\colorRGB.txt` file;
4. start the program.

**Setup:**
- long press on a card to add/remove it from the pool;
- single press on a card to increase its rarity (1 to 6 and back);
- set the number of times a card can be drawn, set as `-1` if unlimited;
- set the marker of each card as A or B.

**Draw steps:**
1. play the `.mp3` file;
2. randomly selects a rarity;
3. randomly selects a card of such rarity;
4. 1.5s animation from right that makes the drawn card appear;
5. card stays for 5 seconds;
6. hide the card;
7. add the drawn card to the log file.

If there isn't any available card of the randomly selected rarity, it first checks the lower rarities and then the higher rarities.
> _e.g.: if Rarity 4 is selected but no cards in it, the check order is 3-2-1-5-6_.

The pool can be made by **A** cards, **B** cards or **both**.