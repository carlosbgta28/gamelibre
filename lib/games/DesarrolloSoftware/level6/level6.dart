import 'dart:math';
import 'package:flutter/services.dart';
import 'package:prueba/anim/shakeWidget.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:prueba/dialogs/dialog_helper.dart';
import 'package:prueba/model/dbhelper.dart';
import 'package:prueba/model/score.dart';
import 'package:prueba/view/desarrollo_software.dart';
import 'package:soundpool/soundpool.dart';

// JUEGO SELECCIONAR Y SOLTAR PALABRA

class level6 extends StatefulWidget {
  const level6({Key? key}) : super(key: key);

  @override
  State<level6> createState() => _level6State();
}

//font code: https://youtu.be/KOh6CkX-d6U

class _level6State extends State<level6> {
  final Map<String, bool> score = {};

  final Map choices = {
    'GET': 'realiza una petición a un recurso específico',
    'POST': 'puede enviar datos al servidor por medio del cuerpo (body)',
    'PUT': 'puede ser ejecutado varias veces y tiene el mismo efecto',
    'DELETE': ' permite eliminar un recurso específico',
    'PATCH':
        'se emplea para modificaciones parciales de un recurso en particular',
    'HEAD': ' no retorna ningún contenido HTTP Response',
  };

  //Color.fromARGB(255, 61, 13, 4), //color red dark
  //Color.fromARGB(255, 255, 233, 230), // color white pink clear

  int seed = 0;

  final AudioCache _audioController = AudioCache();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 233, 230),
      body: Stack(
        //overflow: Overflow.visible,
        alignment: Alignment.center,
        children: <Widget>[
          //divider
          Positioned(
            top: -470,
            left: 5,
            right: 5,
            bottom: 100,
            child: Container(
              child: const Divider(
                thickness: 1,
                color: Colors.grey,
              ),
            ),
          ),

//FLECHA ATRAS
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
                    Navigator.push(
                        context,
                        PageRouteBuilder(
                            transitionDuration: const Duration(seconds: 1),
                            transitionsBuilder: (BuildContext context,
                                Animation<double> animation,
                                Animation<double> secAnimation,
                                Widget child) {
                              animation = CurvedAnimation(
                                  parent: animation, curve: Curves.elasticOut);

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

                    //KILL NAVIGATOR WHEN USER TAP BACK BUTTON
                    Future.delayed(const Duration(seconds: 3), () {
                      Navigator.of(context)
                          .popUntil(ModalRoute.withName('/desarrollo'));
                    });
                  },
                ),
              )),
          //banner superior
          Positioned(
            top: -43,
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(1.0),
                  width: 160,
                  height: 200,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                      image:
                          AssetImage("assets/games/general/bannerGamiDrop.png"),
                      //fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
            ),
          ),

//score
          Positioned(
            top: 83,
            child: Container(
              width: 300,
              alignment: Alignment.topRight,
              child: Text(
                'Score: ${score.length} / 5',
                textAlign: TextAlign.right,
                style: const TextStyle(
                    fontSize: 15,
                    fontFamily: 'ZCOOL',
                    color: Color.fromARGB(255, 61, 13, 4)),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.fromLTRB(1, 105, 1, 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: choices.keys.map((conceptoAfirmacion) {
                      return Draggable<String>(
                        data: conceptoAfirmacion,
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(20)),
                          child: Container(
                            ////  ////  ////  //// CONCEPT INSIDE CARD LEFT
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
                            color: Color.fromARGB(255, 61, 13, 4),
                            child: ConceptoAfirmacion(
                                //if concept is correct at draw, then show check emoti in left cards
                                conceptoAfirmacion:
                                    score[conceptoAfirmacion] == true
                                        ? '✅'
                                        : conceptoAfirmacion),
                          ),
                        ),
                        feedback: ConceptoAfirmacion(
                          conceptoAfirmacion: conceptoAfirmacion,
                        ),
                        childWhenDragging:
                            const ConceptoAfirmacion(conceptoAfirmacion: '🧐'),
                      );
                    }).toList()),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: choices.keys
                      .map((conceptoAfirmacion) =>
                          _buildDragTarget(conceptoAfirmacion))
                      .toList()
                    ..shuffle(Random(seed)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDragTarget(conceptoAfirmacion) {
    return DragTarget<String>(
        builder: (BuildContext context, List<String?> incoming, List rejected) {
          if (score[conceptoAfirmacion] == true) {
            return ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              child: Container(
                color: Colors.green,
                child: const Text(
                  'Correcto!',
                  style: TextStyle(
                      color: Colors.white, fontSize: 25, fontFamily: 'ZCOOL'),
                ),
                alignment: Alignment.center,
                height: 80,
                width: 200,
              ),
            );
          } else {
            ////  ////  //////text cards answers
            return ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              child: Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.fromLTRB(8, 2, 8, 2),
                color: Color.fromARGB(159, 158, 158, 158),
                child: Text(
                  choices[conceptoAfirmacion],
                  style: const TextStyle(
                      color: Colors.black, fontSize: 20, fontFamily: 'ZCOOL'),
                ),
                height: 100,
                width: 200,
              ),
            );
          }
        },
        onWillAccept: (data) => data == conceptoAfirmacion,
        onAccept: (data) {
          setState(() {
            score[conceptoAfirmacion] = true;
            //game over, si el usuario complet+o las 5 palabras, se genera su score y se cierra el nivel
            if (score.length == 5) {
              DialogHelper.showDialogGameOver(context, 5,
                  'ds'); //gana 5 puntos si alcanzó a completar || SCORE
              //pas infO score to bd updating all ROW
              var handler = DatabaseHandler();
              handler.updateScore(scoregamilibre(
                  id: 'DS6',
                  modulo: 'DS',
                  nivel: '6',
                  score: score.length.toString()));
            }
          });

          //_audioController.load('assets/soundFX/succes1.wav');
        },
        onLeave: (data) {});
  }
}

class ConceptoAfirmacion extends StatelessWidget {
  const ConceptoAfirmacion({Key? key, required this.conceptoAfirmacion})
      : super(key: key);

  final String conceptoAfirmacion;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
          alignment: Alignment.centerLeft,
          height: 50,
          padding: const EdgeInsets.fromLTRB(1, 0, 1, 0),
          child: Align(
            alignment: Alignment.centerRight,
            child: Text(
              conceptoAfirmacion,
              style: const TextStyle(
                  //color text left csrds
                  color: Colors.white,
                  fontSize: 25,
                  fontFamily: 'ZCOOL'),
            ),
          )),
    );
  }
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
