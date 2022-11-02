import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:prueba/games/DesarrolloSoftware/level11/screens/quizz_screen.dart';

final pageRoutesquiz = <_Routequiz>[
  _Routequiz(FontAwesomeIcons.slideshare, 'quiz', QuizzScreen()),
  //_Route(FontAwesomeIcons.slideshare, 'urgencias', EmergencyPage()),
  //_Route(FontAwesomeIcons.ambulance, 'Galerias', SlideShowPage()),
];

class _Routequiz {
  final IconData icon;
  final String titulo;
  final Widget page;

  _Routequiz(this.icon, this.titulo, this.page);
}
