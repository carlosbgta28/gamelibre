import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prueba/anim/shakeWidget.dart';
import 'package:prueba/model/dbhelper.dart';
import 'package:prueba/model/score.dart';
import 'package:prueba/view/desarrollo_software.dart';
import 'package:prueba/view/home_screen.dart';
import 'package:prueba/view/razonamiento_cuantitativo.dart';
import 'package:prueba/services/local_storage.dart';
import 'package:soundpool/soundpool.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MyScore2 extends StatefulWidget {
  late String puntoPartida;

  MyScore2({super.key, required this.puntoPartida});

  @override
  State<MyScore2> createState() => _MyScore2State();
}

class _MyScore2State extends State<MyScore2> {
  late DatabaseHandler handler;
  Future<List<scoregamilibre>>? _scoregamilibreRC;
  Future<List<scoregamilibre>>? _scoregamilibreDS;

  @override
  void initState() {
    handler = DatabaseHandler();
    handler.initializeDB().whenComplete(() async {
      setState(() {
        _scoregamilibreRC = getListRC();
        _scoregamilibreDS = getListDS();
      });
    });
    super.initState();
  }

  //get the list with all rows from table score
  Future<List<scoregamilibre>> getListRC() async {
    return await handler.QueryAllScoresRC();
  }

  Future<List<scoregamilibre>> getListDS() async {
    return await handler.QueryAllScoresDS();
  }

  Future<void> _onRefresh() async {
    setState(() {
      _scoregamilibreRC = getListRC();
      _scoregamilibreDS = getListDS();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
          //overflow: Overflow.visible,
          alignment: Alignment.center,
          children: <Widget>[
            //CONTAINER DEL FONDO QUE CONTIENE IMAGEN DE FONDO LADRILLOS
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/fondo_ladrillos.png"),
                  fit: BoxFit.cover,
                ),
              ),
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
              ),
            ),
            //flecha atras
            Positioned(
                top: 20,
                left: -10,
                child: ShakeWidgetX(
                  child: IconButton(
                    icon: Image.asset('assets/flecha_left.png'),
                    iconSize: 50,
                    onPressed: () {
                      //soundFX
                      _soundBack();

                      //if user come from rc, then go back to rc
                      if (widget.puntoPartida == "rc") {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            PageRouteBuilder(
                                transitionDuration: const Duration(seconds: 1),
                                transitionsBuilder: (BuildContext context,
                                    Animation<double> animation,
                                    Animation<double> secAnimation,
                                    Widget child) {
                                  animation = CurvedAnimation(
                                      parent: animation,
                                      curve: Curves.elasticOut);

                                  return ScaleTransition(
                                    alignment: Alignment.center,
                                    scale: animation,
                                    child: child,
                                  );
                                },
                                pageBuilder: (BuildContext context,
                                    Animation<double> animation,
                                    Animation<double> secAnimattion) {
                                  return const razonamiento();
                                }));
                      }

                      //if user come from ds, then go back to ds
                      if (widget.puntoPartida == "ds") {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            PageRouteBuilder(
                                transitionDuration: const Duration(seconds: 1),
                                transitionsBuilder: (BuildContext context,
                                    Animation<double> animation,
                                    Animation<double> secAnimation,
                                    Widget child) {
                                  animation = CurvedAnimation(
                                      parent: animation,
                                      curve: Curves.elasticOut);

                                  return ScaleTransition(
                                    alignment: Alignment.center,
                                    scale: animation,
                                    child: child,
                                  );
                                },
                                pageBuilder: (BuildContext context,
                                    Animation<double> animation,
                                    Animation<double> secAnimattion) {
                                  return const desarrollo();
                                }));
                      }

                      //if user come from home, then go back to home
                      if (widget.puntoPartida == "home") {
                        Navigator.pop(context);
                        Navigator.push(
                            context,
                            PageRouteBuilder(
                                transitionDuration: const Duration(seconds: 1),
                                transitionsBuilder: (BuildContext context,
                                    Animation<double> animation,
                                    Animation<double> secAnimation,
                                    Widget child) {
                                  animation = CurvedAnimation(
                                      parent: animation,
                                      curve: Curves.elasticOut);

                                  return ScaleTransition(
                                    alignment: Alignment.center,
                                    scale: animation,
                                    child: child,
                                  );
                                },
                                pageBuilder: (BuildContext context,
                                    Animation<double> animation,
                                    Animation<double> secAnimattion) {
                                  return const HomeScreen();
                                }));
                      }
                    },
                  ),
                )),

            Positioned(
              top: 30,
              child: Column(
                children: [
                  Center(
                    child: Container(
                      //mis puntajes letrero png
                      padding: const EdgeInsets.fromLTRB(2, 20, 2, 2),
                      width: 250,
                      height: 50,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                              "assets/banners/bannerGamiPuntajes.png"),
                          //fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Positioned(
              top: 100,
              left: 17,
              child: Row(
                children: [
                  const SizedBox(
                    width: 20,
                  ),
                  Column(
                    children: const [
                      Text(
                        "Razonamiento",
                        style: TextStyle(
                          fontFamily: 'ZCOOL',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "Cuantitativo",
                        style: TextStyle(
                          fontFamily: 'ZCOOL',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    width: 85,
                  ),
                  Column(
                    children: const [
                      Text(
                        "Diseño de",
                        style: TextStyle(
                          fontFamily: 'ZCOOL',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "Software",
                        style: TextStyle(
                          fontFamily: 'ZCOOL',
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(5, 100, 5, 2),
                    child: SizedBox(
                      height: 610.0,
                      child: FutureBuilder<List<scoregamilibre>>(
                        future: _scoregamilibreRC,
                        builder: (BuildContext context,
                            AsyncSnapshot<List<scoregamilibre>> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            var items = snapshot.data ?? <scoregamilibre>[];

                            print(items);

                            return Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 1.0,
                                vertical: 1.0,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListView.builder(
                                itemCount: items.length,
                                itemBuilder: (BuildContext context, int index) {
                                  print("estos son los scores ---------------");
                                  print(items.length);
                                  print(items[0].score);
                                  print(items[1].score);
                                  print(items[2].score);
                                  print("---------------");

                                  int Ipos0 = int.parse(items[0].score);
                                  int Ipos1 = int.parse(items[1].score);
                                  int Ipos2 = int.parse(items[2].score);
                                  int Ipos3 = int.parse(items[3].score);
                                  int Ipos4 = int.parse(items[4].score);
                                  int Ipos5 = int.parse(items[5].score);
                                  int Ipos6 = int.parse(items[6].score);
                                  int Ipos7 = int.parse(items[7].score);
                                  int Ipos8 = int.parse(items[8].score);
                                  int Ipos9 = int.parse(items[9].score);

                                  int sumatoria = Ipos0 +
                                      Ipos1 +
                                      Ipos2 +
                                      Ipos3 +
                                      Ipos4 +
                                      Ipos5 +
                                      Ipos6 +
                                      Ipos7 +
                                      Ipos8 +
                                      Ipos9;

                                  print("La sumatoria es: " +
                                      sumatoria.toString());

                                  //paso la sumatoria a firebase

                                  //CARGO A SHAREDPREDERENCES LA sumatoria
                                  LocalStorage.prefs.setString(
                                      "sumScore", sumatoria.toString());

                                  updateSumScoreRC(sumatoria);

                                  return GestureDetector(
                                    onTap: () {},
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(7, 5, 7, 5),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 0, 0, 0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                      255,
                                                      61,
                                                      13,
                                                      4), // Your desired background color
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors.black
                                                            .withOpacity(0.5),
                                                        blurRadius: 6),
                                                  ]),
                                              child: Row(
                                                children: <Widget>[
                                                  Expanded(
                                                    //para que no haya overflow
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          8.0, 1.0, 1.0, 5.0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          //nivel
                                                          Center(
                                                            child: Text(
                                                              'Nivel ' +
                                                                  items[index]
                                                                      .nivel,
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 10,
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        175,
                                                                        175,
                                                                        175),
                                                              ),
                                                            ),
                                                          ),

                                                          //score
                                                          Center(
                                                            child: Text(
                                                              '' +
                                                                  items[index]
                                                                      .score,
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 16,
                                                                color: Colors
                                                                    .orange,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(5, 100, 5, 2),
                    child: SizedBox(
                      height: 610.0,
                      child: FutureBuilder<List<scoregamilibre>>(
                        future: _scoregamilibreDS,
                        builder: (BuildContext context,
                            AsyncSnapshot<List<scoregamilibre>> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            var items = snapshot.data ?? <scoregamilibre>[];

                            print(items);

                            return Container(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 1.0,
                                vertical: 1.0,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListView.builder(
                                itemCount: items.length,
                                itemBuilder: (BuildContext context, int index) {
                                  print("estos son los scores ---------------");
                                  print(items.length);
                                  print(items[0].score);
                                  print(items[1].score);
                                  print(items[2].score);
                                  print("---------------");

                                  int Ipos0 = int.parse(items[0].score);
                                  int Ipos1 = int.parse(items[1].score);
                                  int Ipos2 = int.parse(items[2].score);
                                  int Ipos3 = int.parse(items[3].score);
                                  int Ipos4 = int.parse(items[4].score);
                                  int Ipos5 = int.parse(items[5].score);
                                  int Ipos6 = int.parse(items[6].score);
                                  int Ipos7 = int.parse(items[7].score);
                                  int Ipos8 = int.parse(items[8].score);
                                  int Ipos9 = int.parse(items[9].score);

                                  int sumatoria = Ipos0 +
                                      Ipos1 +
                                      Ipos2 +
                                      Ipos3 +
                                      Ipos4 +
                                      Ipos5 +
                                      Ipos6 +
                                      Ipos7 +
                                      Ipos8 +
                                      Ipos9;

                                  print("La sumatoria es: " +
                                      sumatoria.toString());

                                  //CARGO A SHAREDPREDERENCES LA sumatoria
                                  LocalStorage.prefs.setString(
                                      "sumScoreDS", sumatoria.toString());
                                  updateSumScoreDS(sumatoria);

                                  return GestureDetector(
                                    onTap: () {},
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.fromLTRB(7, 5, 7, 5),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 0, 0, 0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                      255,
                                                      61,
                                                      13,
                                                      4), // Your desired background color
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                  boxShadow: [
                                                    BoxShadow(
                                                        color: Colors.black
                                                            .withOpacity(0.5),
                                                        blurRadius: 6),
                                                  ]),
                                              child: Row(
                                                children: <Widget>[
                                                  Expanded(
                                                    //para que no haya overflow
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                              .fromLTRB(
                                                          8.0, 1.0, 1.0, 5.0),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          //nivel
                                                          Center(
                                                            child: Text(
                                                              'Nivel ' +
                                                                  items[index]
                                                                      .nivel,
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 10,
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        175,
                                                                        175,
                                                                        175),
                                                              ),
                                                            ),
                                                          ),

                                                          //score
                                                          Center(
                                                            child: Text(
                                                              '' +
                                                                  items[index]
                                                                      .score,
                                                              style:
                                                                  const TextStyle(
                                                                fontSize: 16,
                                                                color: Colors
                                                                    .orange,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ]),
    );
  }

  Future<void> _soundBack() async {
    Soundpool pool = Soundpool(streamType: StreamType.notification);
    int soundId = await rootBundle
        .load("assets/soundFX/buttonBack.wav")
        .then((ByteData soundData) {
      return pool.load(soundData);
    });
    int streamId = await pool.play(soundId);
  }

  void updateSumScoreRC(int sumatoria) {
    CollectionReference collection =
        FirebaseFirestore.instance.collection('users');
    final _auth = FirebaseAuth.instance;

    User? user = _auth.currentUser;

//probar con este id de usuario, sino, entonces mandar el id de usuario entre panllas desde rc o ds a aqui
    DocumentReference document = collection.doc(user?.uid);

    Map<String, String> scoreUpdate = {
      'sumScoreRC': sumatoria.toString(),
    };

    document.update(scoreUpdate);
  }

  void updateSumScoreDS(int sumatoria) {
    CollectionReference collection =
        FirebaseFirestore.instance.collection('users');
    final _auth = FirebaseAuth.instance;

    User? user = _auth.currentUser;

//probar con este id de usuario, sino, entonces mandar el id de usuario entre panllas desde rc o ds a aqui
    DocumentReference document = collection.doc(user?.uid);

    Map<String, String> scoreUpdate = {
      'sumScoreDS': sumatoria.toString(),
    };

    document.update(scoreUpdate);
  }
}
