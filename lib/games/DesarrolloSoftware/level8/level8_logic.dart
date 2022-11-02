class GameCards {
  final String hiddenCardpath = 'assets/logo_cards.png';
  List<String>? gameImg;

  final List<String> cards_list = [
    "assets/games/DesarrolloSoftware/level8/ds_nivel8_1.png",
    "assets/games/DesarrolloSoftware/level8/ds_nivel8_3.png",
    "assets/games/DesarrolloSoftware/level8/ds_nivel8_5.png",
    "assets/games/DesarrolloSoftware/level8/ds_nivel8_2.png",
    "assets/games/DesarrolloSoftware/level8/ds_nivel8_4.png",
    "assets/games/DesarrolloSoftware/level8/ds_nivel8_6.png",
    "assets/games/DesarrolloSoftware/level8/ds_nivel8_5.png",
    "assets/games/DesarrolloSoftware/level8/ds_nivel8_6.png",
    "assets/games/DesarrolloSoftware/level8/ds_nivel8_3.png",
    "assets/games/DesarrolloSoftware/level8/ds_nivel8_4.png",
    "assets/games/DesarrolloSoftware/level8/ds_nivel8_1.png",
    "assets/games/DesarrolloSoftware/level8/ds_nivel8_2.png",
  ];

  // in this list we will store the two first clicked card and see if they match or not
  List<Map<int, String>> matchCheck = [];

  final int cardCount = 12;

  void initGame() {
    gameImg = List.generate(cardCount, (index) => hiddenCardpath);
  }
}
