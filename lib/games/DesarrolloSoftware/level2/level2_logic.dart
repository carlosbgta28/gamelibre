class GameCards {
  final String hiddenCardpath = 'assets/logo_cards.png';
  List<String>? gameImg;

  final List<String> cards_list = [
    "assets/games/DesarrolloSoftware/ds_sentence_1.png",

    "assets/games/DesarrolloSoftware/ds_sentence_3.png",

    "assets/games/DesarrolloSoftware/ds_sentence_6.png",
    "assets/games/DesarrolloSoftware/ds_sentence_4.png",
    "assets/games/DesarrolloSoftware/ds_sentence_2.png",
    "assets/games/DesarrolloSoftware/ds_sentence_5.png",

    //"assets/games/level2/sentence_5.png",

    "assets/games/DesarrolloSoftware/ds_sentence_3.png",

    "assets/games/DesarrolloSoftware/ds_sentence_1.png",

    "assets/games/DesarrolloSoftware/ds_sentence_4.png",
    "assets/games/DesarrolloSoftware/ds_sentence_2.png",

    "assets/games/DesarrolloSoftware/ds_sentence_6.png",
    "assets/games/DesarrolloSoftware/ds_sentence_5.png",
  ];

  // in this list we will store the two first clicked card and see if they match or not
  List<Map<int, String>> matchCheck = [];

  final int cardCount = 12;

  void initGame() {
    gameImg = List.generate(cardCount, (index) => hiddenCardpath);
  }
}
