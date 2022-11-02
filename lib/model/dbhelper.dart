import 'package:prueba/model/score.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHandler {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'gamilibre007.db'),
      onCreate: (database, version) async {
        const String sql = ''
            'CREATE TABLE scoreTable ('
            ' id TEXT PRIMARY KEY,'
            ' modulo TEXT,'
            ' nivel TEXT,'
            ' score TEXT'
            ');';

        await database.execute(sql);
        const String addScoreGame = ''
            'INSERT INTO scoreTable(id, modulo, nivel, score) VALUES '

            //RC -- 01 is the family id's for RC
            '("RC1", "RC", "1", "0"),'
            '("RC2", "RC", "2", "0"),'
            '("RC3", "RC", "3", "0"),'
            '("RC4", "RC", "4", "0"),'
            '("RC5", "RC", "5", "0"),'
            '("RC6", "RC", "6", "0"),'
            '("RC7", "RC", "7", "0"),'
            '("RC8", "RC", "8", "0"),'
            '("RC9", "RC", "9", "0"),'
            '("RC10", "RC", "10", "0"),'
            '("RC11", "RC", "11", "0"),'

            // DS -- 001 is the family id's for DS
            '("DS1", "DS", "1", "0"),'
            '("DS2", "DS", "2", "0"),'
            '("DS3", "DS", "3", "0"),'
            '("DS4", "DS", "4", "0"),'
            '("DS5", "DS", "5", "0"),'
            '("DS6", "DS", "6", "0"),'
            '("DS7", "DS", "7", "0"),'
            '("DS8", "DS", "8", "0"),'
            '("009", "DS", "9", "0"),'
            '("DS10", "DS", "10", "0"),'
            '("DS11", "DS", "11", "0")';

        await database.execute(addScoreGame);
        //deleteDatabase("gamilibre12.db");
      },
      version: 1,
    );
  }

  //INSERT NEW SCORE FROM LEVEL GAME

  //la idea es que esta funcion va a insertar el puntaje completo por nivel dentro de cada modulo
  //se debe invocar cuando se finalice el juego gameover. Se manda desde alla hacia aca mediante un objeto tipogamilibre donde se ponen todos los datos
  Future<void> insertScoreLevel_1(scoregamilibre ScoreGamiLibre) async {
    final db = await initializeDB();

    //inserta en la tabla scoresTable la informaion que se recibe
    // ya lo que se recibe es el objeto que contiene la informacion completa
    await db.insert(
      'scoresTable',
      ScoreGamiLibre.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // SELECT ONE ELEMENT
  Future<List<scoregamilibre>> Gamilibre() async {
    final db = await initializeDB();
    final List<Map<String, dynamic>> queryResult =
        await db.rawQuery('SELECT * FROM score WHERE nivel like ?', ['%1%']);
    Map<String, dynamic> result = {};
    for (var r in queryResult) {
      result.addAll(r);
    }
    return queryResult.map((e) => scoregamilibre.fromMap(e)).toList();
  }

  // SELECT SCORE WHERE MODULO AND NIVEL CONTAINS THE INFO
  // it requires: modulo, nivel

  Future<List<scoregamilibre>> SelectScoreForLevelModule(
      String modulo, String nivel) async {
    final db = await initializeDB();
    final List<Map<String, dynamic>> queryResult = await db.rawQuery(
        'SELECT score FROM scoreTable WHERE modulo like ? AND nivel like ?',
        ['%' + modulo + '%' + nivel + '%']);
    Map<String, dynamic> result = {};
    for (var r in queryResult) {
      result.addAll(r);
    }
    return queryResult.map((e) => scoregamilibre.fromMap(e)).toList();
  }

  // se puede crear 5 valores para avatar, donde el primero es avatarDefault, avatar1, avatar2... en sharedpreferences

  //UPDATE SCORE IN CASE IT REQUIRES
  //ACTUALIZA TODA LA INFO ROW SEL SCORE SEGUN EL ID QUE LE PASEN. LOS ID'S YA HAN SIDO CREADOR ANTERIORMENTE
  Future<Future<int>> updateScore(scoregamilibre ScoreGamiLibre) async {
    final db = await initializeDB();

    return db.update("scoreTable", ScoreGamiLibre.toMap(),
        where: "id = ?", whereArgs: [ScoreGamiLibre.id]);
  }

//cON SENTENCIAS
  Future<void> insertScoreLevel_2(scoregamilibre ScoreGamiLibre) async {
    final db = await initializeDB();

    var resultado = await db.rawInsert(
        "INSERT INTO scoreTable (modulo, nivel, score) "
        "VALUES (${ScoreGamiLibre.modulo}, ${ScoreGamiLibre.nivel}, ${ScoreGamiLibre.score})");
  }

//DELETE sore WITH ID FROM Game Screen
  Future<void> deleteScore(int id) async {
    final db = await initializeDB();
    await db.delete(
      'scoreTable',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

//
// QUERYS -------------------------------------------------------------------------------------------
//
  //QUERY FOR ALL ITEMS GAMES FOR RC
/*   Future<List<scoregamilibre>> QueryAllScoresRC() async {
    final db = await initializeDB();
    final List<Map<String, dynamic>> queryResult = await db.query('scoreTable');
    return queryResult.map((e) => scoregamilibre.fromMap(e)).toList();
  } */

  Future<List<scoregamilibre>> QueryAllScoresRC() async {
    final db = await initializeDB();
    final List<Map<String, dynamic>> queryResult = await db
        .rawQuery('SELECT * FROM scoreTable WHERE modulo like ?', ['%RC%']);
    Map<String, dynamic> result = {};
    for (var r in queryResult) {
      result.addAll(r);
    }
    return queryResult.map((e) => scoregamilibre.fromMap(e)).toList();
  }

//QUERY FOR ALL ITEMS GAMES FOR DS
  Future<List<scoregamilibre>> QueryAllScoresDS() async {
    final db = await initializeDB();
    final List<Map<String, dynamic>> queryResult = await db
        .rawQuery('SELECT * FROM scoreTable WHERE modulo like ?', ['%DS%']);
    Map<String, dynamic> result = {};
    for (var r in queryResult) {
      result.addAll(r);
    }
    return queryResult.map((e) => scoregamilibre.fromMap(e)).toList();
  }

//MAKING SUM FROM ALL LEVELS SCORES FOR RC
  Future<List<scoregamilibre>> SumAllScoresRC() async {
    final db = await initializeDB();
    int sumRC = 0;

    final List<Map<String, dynamic>> queryResult = await db
        .rawQuery('SELECT score FROM scoreTable WHERE modulo like ?', ['%RC%']);
    Map<String, dynamic> result = {};

    for (var r in queryResult) {
      result.addAll(r);
    }

    print("IMPRIMIENDO TODOS LOS SCORES DE RC");
    queryResult.forEach(print);

    return queryResult.map((e) => scoregamilibre.fromMap(e)).toList();
  }

/*   // SELECT ONLY EXLUDE PARAMETER ABOUT CATEGORIA OR LEVEL
  Future<List<game>> categoriaOtros() async {
    final db = await initializeDB();
    final List<Map<String, dynamic>> queryResult = await db.rawQuery(
        "SELECT * FROM todos WHERE categoria NOT IN (' IA ', 'Crypto', 'Idiomas', 'TIC', 'Programación', 'Profesionales', 'Salud y Bienestar', 'Ciencias Sociales y Jurídicas', 'Administración Negocios y Finanzas')");
    Map<String, dynamic> result = {};
    for (var r in queryResult) {
      result.addAll(r);
    }
    return queryResult.map((e) => game.fromMap(e)).toList();
  } */

/* //comentareado por ahora porque esta dando problema para leer la bd
   // SELECT ALL GAMES WITH CONDITIONAL OR
  Future<List<game>> coursesResultQuery(String queryCourse) async {
    final db = await initializeDB();
    final List<Map<String, dynamic>> queryResult = await db.rawQuery(
        'SELECT * FROM quices WHERE title LIKE ? OR categoria LIKE ?',
        ['%' + queryCourse + '%', '%' + queryCourse + '%']);
    Map<String, dynamic> result = {};
    for (var r in queryResult) {
      result.addAll(r);
    }
    return queryResult.map((e) => game.fromMap(e)).toList();
  }  */
}
