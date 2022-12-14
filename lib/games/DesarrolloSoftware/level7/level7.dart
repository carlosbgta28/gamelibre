import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prueba/model/dbhelper.dart';
import 'package:prueba/model/score.dart';
import 'package:prueba/view/scores_screen.dart';
import 'package:prueba/view/desarrollo_software.dart';
import 'package:prueba/anim/shakeWidget.dart';
import 'package:soundpool/soundpool.dart';

class level7 extends StatefulWidget {
  const level7({Key? key}) : super(key: key);

  @override
  State<level7> createState() => _level7State();
}

class _level7State extends State<level7> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: Stack(alignment: Alignment.center, children: <Widget>[
        //banner superior
        Positioned(
          top: -195,
          left: 90,
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(1.0),
                width: 150,
                height: 500,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(
                        "assets/games/general/bannerGamerQuiz_dark.png"),
                    //fit: BoxFit.cover,
                  ),
                ),
              ),
              const Text(
                " #4",
                style: TextStyle(
                    color: Color.fromARGB(255, 61, 13, 4),
                    fontFamily: 'ZCOOL',
                    fontSize: 25.0),
              ),
            ],
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
                  //soundFX
                  _soundBack();
                },
              ),
            )),

        const QuestionWidget(),
      ]),
    );
  }
}

class QuestionWidget extends StatefulWidget {
  const QuestionWidget({
    Key? key,
  }) : super(key: key);

  @override
  State<QuestionWidget> createState() => _QuestionWidgetState();
}

//clase que retorna la pregunta en pantalla
class _QuestionWidgetState extends State<QuestionWidget> {
  late PageController _controller;
  int _questionNumber = 1;
  int _score = 0;
  bool _isLocked = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = PageController(initialPage: 0);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          const SizedBox(height: 70),
          const Divider(
            thickness: 1,
            color: Colors.grey,
          ),
          Text(
            'Pregunta $_questionNumber/${questions.length}',
            style: const TextStyle(
                color: Colors.white, fontFamily: 'ZCOOL', fontSize: 15.0),
          ),
          //Se imprime el pageView que contiene pregunta y opciones
          Expanded(
              child: PageView.builder(
            itemCount: questions.length,
            controller: _controller,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final _question = questions[index];
              return buildQuestion(_question);
            },
          )),
          _isLocked ? buildElevatedButton() : const SizedBox.shrink(),
          const SizedBox(height: 20),
          const Divider(
            thickness: 1,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }

  Column buildQuestion(Question question) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //altura del cuerpo que contiene pregunta y respuestas

        const SizedBox(height: 20),
        // espacio para imagen scroll vire
        SizedBox(
          height: 120,
          width: 330,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Center(
              child: Image.network(
                question.img,
                //fit: BoxFit.fill,
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 150,
          width: 330,
          child: SingleChildScrollView(
            child: Text(
              //TEXTO QUE CONTIENE LA PREGUNTA COMPLETA
              question.text,
              style: const TextStyle(
                  color: Color.fromARGB(255, 61, 13, 4),
                  fontFamily: 'ZCOOL',
                  fontSize: 18.0),
            ),
          ),
        ),
        Expanded(
            child: OptionsWidget(
          question: question,
          onClickedOption: (option) {
            if (question.isLocked) {
              return;
            } else {
              setState(() {
                question.isLocked = true;
                question.selectedOption = option;
              });
              _isLocked = question.isLocked;
              if (question.selectedOption!.isCorrect) {
                _score++;
              }
            }
          },
        ))
      ],
    );
  }

  ElevatedButton buildElevatedButton() {
    return ElevatedButton(
      onPressed: () {
        if (_questionNumber < questions.length) {
          _controller.nextPage(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInExpo,
          );
          setState(() {
            _questionNumber++;
            _isLocked = false;
          });
        } else {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ResultPage(score: _score),
            ),
          );
        }
        //pas infO score to bd updating all ROW
        var handler = DatabaseHandler();
        handler.updateScore(scoregamilibre(
            id: 'DS7', modulo: 'DS', nivel: '7', score: _score.toString()));
      },
      child: Text(
        _questionNumber < questions.length ? 'Siguiente' : 'Revisar resultado',
        style:
            TextStyle(color: Colors.white, fontFamily: 'ZCOOL', fontSize: 25.0),
      ),
    );
  }
}

class OptionsWidget extends StatelessWidget {
  final Question question;
  final ValueChanged<Option> onClickedOption;

  const OptionsWidget({
    Key? key,
    required this.question,
    required this.onClickedOption,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        child: Column(
          children: question.options
              .map((option) => buildOption(context, option))
              .toList(),
        ),
      );

  //devuelve graficamente las opciones de respuestas en pantalla
  @override
  Widget buildOption(BuildContext context, Option option) {
    final color = getColorForOption(option, question);
    return GestureDetector(
      onTap: () => onClickedOption(option),
      child: Container(
        height: 50, //altura de las tarjetas de cada opcion
        padding: const EdgeInsets.fromLTRB(3, 1, 1, 1),
        margin: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 1, 10, 1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                fit: FlexFit.loose,
                child: Text(
                  option.text,
                  style: const TextStyle(
                      color: Colors.black, fontFamily: 'ZCOOL', fontSize: 17.0),
                ),
              ),
              getIconForOption(option, question)
            ],
          ),
        ),
      ),
    );
  }

  Color getColorForOption(Option option, Question question) {
    final isSelected = option == question.selectedOption;

    if (question.isLocked) {
      if (isSelected) {
        return option.isCorrect ? Colors.green : Colors.red;
      } else if (option.isCorrect) {
        return Colors.green;
      }
    }

    return Colors.grey.shade300;
  }

  Widget getIconForOption(Option option, Question question) {
    final isSelect = option == question.selectedOption;
    if (question.isLocked) {
      if (isSelect) {
        return option.isCorrect
            ? const Icon(Icons.check_circle, color: Colors.green)
            : const Icon(Icons.cancel, color: Colors.red);
      } else if (option.isCorrect) {
        return const Icon(Icons.check_circle, color: Colors.green);
      }
    }
    return const SizedBox.shrink();
  }
}

class Question {
  late String img = "";
  late final String text;
  late final List<Option> options;
  bool isLocked;
  Option? selectedOption;

  Question({
    required this.img,
    required this.text,
    required this.options,
    this.isLocked = false,
    this.selectedOption,
  });
}

class Option {
  final String text;
  final bool isCorrect;

  const Option({
    required this.text,
    required this.isCorrect,
  });
}

final questions = [
  //para preguntas con imagen se puede usar la clase Question
  // para preguntas sin imagen, se puede usar otra clase comno QuestionNoIMG

  //Pregunta 1
  Question(
      img: ("http://gamilibre.com/imagenes/t1.png"),
      text:
          "1. En el contexto del caso de estudio WebGallery los compradores realizan el pago usando el bot??n PSE o una tarjeta de cr??dito. la demora en tiempo de una transacci??n se vuelve inaceptable para el comprador, conduciendo a intentos repetidos por lo que genera doble pago o abandono de la transacci??n por parte del comprador. La forma de resolver seria; ",
      options: [
        const Option(
            text:
                'A. la capacidad de procesamiento del servidor de pagos para mejorar el tiempo de respuesta. ',
            isCorrect: false),
        const Option(
            text:
                'B. Aumentando el n??mero de servidores que atienden los pagos, balanceando as?? la cantidad de solicitudes simultaneas. ',
            isCorrect: false),
        const Option(
            text:
                ' C. Mostrando un mensaje de terminaci??n de compra y confirmando por correo electr??nico m??s adelante.  ',
            isCorrect: false),
        const Option(
            text:
                'D. Aumentando el ancho de banda de la red para reducir el tiempo de conexi??n con el servidor de autorizaci??n de pagos',
            isCorrect: true)
      ]),

  //Pregunta 2
  Question(
      img: ("http://gamilibre.com/imagenes/t2.png"),
      text:
          "2. para el desarrollo de un sistema se han definido un conjunto de clases. Si se tienen las clases C1 y C2, donde la clase C2 posee adem??s de sus propios atributos, los atributos de la clase C1. ",
      options: [
        const Option(text: 'A. C1 heredada de la clase C2', isCorrect: false),
        const Option(text: 'B. C2 heredada de la clase C1.  ', isCorrect: true),
        const Option(
            text: 'C. C1 con todos sus atributos p??blicos.  ',
            isCorrect: false),
        const Option(
            text: 'D. C1 con todos sus atributos privados', isCorrect: false)
      ]),

  //Pregunta 3
  Question(
      img: ("http://gamilibre.com/imagenes/e6.jpeg"),
      text:
          "3. En la programaci??n extrema(XP) usa un enfoque orientado a objetos como paradigma preferido de desarrollo, y engloba un conjunto de reglas y pr??cticas que ocurren en el contexto de cuatro actividades estructurales:",
      options: [
        const Option(
            text: 'A. Planeaci??n, dise??o, codificaci??n y decodificaci??n ',
            isCorrect: false),
        const Option(
            text: 'B. Planeaci??n, dise??o, codificaci??n y pruebas',
            isCorrect: true),
        const Option(text: 'C. Planeaci??n, dise??o ', isCorrect: false),
        const Option(text: 'D. Codificaci??n y pruebas ', isCorrect: false)
      ]),

  //Pregunta 4
  Question(
      img: ("http://gamilibre.com/imagenes/p4.jpg"),
      text:
          '4. Los principios Scrum son congruentes con el manifiesto ??gil y se utilizan para guiar actividades de desarrollo dentro de un proceso de an??lisis que incorpora las siguientes actividades estructurales',
      options: [
        const Option(
            text: 'A. Requerimientos, an??lisis, dise??o, evoluci??n y entrega  ',
            isCorrect: true),
        const Option(
            text: 'B. Planeaci??n, dise??o, codificaci??n y pruebas',
            isCorrect: false),
        const Option(text: 'C. An??lisis, dise??o', isCorrect: false),
        const Option(text: 'D. Ninguna de las anteriores', isCorrect: false)
      ]),

  //Pregunta 5
  Question(
      img: ("http://gamilibre.com/imagenes/t4.jpg"),
      text:
          "5. Para recorrer una colecci??n sin depender de su implementaci??n, se puede utilizar un patr??n de dise??o de tipo ",
      options: [
        const Option(
            text:
                'A. prototipo, porque conviene realizar ensayos de recorridos antes de decidir una implementaci??n definitiva.',
            isCorrect: false),
        const Option(
            text:
                '  B. interfaz, porque de esta manera se establece un comportamiento abstracto que puede implementarse posteriormente. ',
            isCorrect: false),
        const Option(
            text:
                ' C. iterador, porque este define operaciones de avance, retroceso y detecci??n de terminaci??n en una colecci??n abstracta.   ',
            isCorrect: true),
        const Option(
            text:
                'D. fachada, porque este abstrae la selecci??n de los servicios de un sistema sin importar su implementaci??n.',
            isCorrect: false)
      ]),
];

class ResultPage extends StatelessWidget {
  const ResultPage({Key? key, required this.score}) : super(key: key);

  final int score;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        //CONTAINER DEL FONDO QUE CONTIENE IMAGEN DE FONDO LADRILLOS
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/fondo_ladrillos_oscuro.png"),
              fit: BoxFit.cover,
            ),
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 8,
          ),
        ),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Stack(alignment: Alignment.center, children: <Widget>[
            Center(
              child: Text(
                'Obtuviste $score/${questions.length}\n\nScore + $score',
                style: const TextStyle(
                    color: Colors.white, fontFamily: 'ZCOOL', fontSize: 35.0),
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
                                return MyScore2(
                                  puntoPartida: 'ds',
                                );
                              }));

                      //soundFX
                      _soundBack();
                    },
                  ),
                )),
          ]),
        ),
      ],
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
