//import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:prueba/games/DesarrolloSoftware/level11/provider/routes.dart';
import 'package:prueba/games/DesarrolloSoftware/level11/screens/ini.dart';
import 'package:prueba/games/DesarrolloSoftware/level11/screens/quizz_screen.dart';
import 'package:prueba/games/DesarrolloSoftware/level11/theme/preferences.dart';
import 'package:prueba/games/DesarrolloSoftware/level11/theme/theme.dart';
import 'package:provider/provider.dart';
import 'package:prueba/games/DesarrolloSoftware/level11/ui/shared/color.dart';

//import 'package:pages/pages.dart';

//import 'package:quiz/widgets/widgets.dart';

class level11 extends StatefulWidget {
  @override
  _level11State createState() => _level11State();
}

class _level11State extends State<level11> {
  final List<int> _items = List<int>.generate(50, (int index) => index);
  //LoginController _con = new LoginController();

  @override
  Widget build(BuildContext context) {
    final apptheme = Provider.of<ThemeProvider>(context).currentheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: Text('GamiLibre'),
      ),
      backgroundColor: AppColor.primaryColor,
      drawer: _MenuPrincipal(),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 48.0,
          horizontal: 12.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Center(
              child: Text(
                "GamiLibre",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            InitPreview(),
            Expanded(
              child: Center(
                child: RawMaterialButton(
                  onPressed: () {
                    //Navigating the the Quizz Screen
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => QuizzScreen(),
                        ));
                  },
                  shape: const StadiumBorder(),
                  fillColor: AppColor.secondaryColor,
                  child: const Padding(
                    padding:
                        EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                    child: Text(
                      "Inicio de examen",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const Center(
              child: Text(
                "ingenieria en TIC",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ListaOpciones extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final aptheme = Provider.of<ThemeProvider>(context).currentheme;
    return ListView.separated(
      physics: BouncingScrollPhysics(),
      separatorBuilder: (context, i) =>
          Divider(color: aptheme.primaryColorLight),
      itemCount: pageRoutesquiz.length,
      itemBuilder: (context, i) => ListTile(
        leading: FaIcon(pageRoutesquiz[i].icon, color: aptheme.accentColor),
        //trailing:FaIcon(FontAwesomeIcons().chevronRight, color: aptheme.accentColor),
        title: Text(pageRoutesquiz[i].titulo),
        onTap: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => pageRoutesquiz[i].page));
        },
      ),
    );
  }
}

class _MenuPrincipal extends StatefulWidget {
  @override
  State<_MenuPrincipal> createState() => _MenuPrincipalState();
}

class _MenuPrincipalState extends State<_MenuPrincipal> {
  final Color color1;
  final Color color2;

  _MenuPrincipalState(
      {this.color1 = Colors.purple, this.color2 = Colors.blueGrey});
  @override
  Widget build(BuildContext context) {
    final apptheme = Provider.of<ThemeProvider>(context).currentheme;
    return Drawer(
      child: Container(
        child: Column(
          children: <Widget>[
            SafeArea(
              child: RawMaterialButton(
                onPressed: () {},
                shape: CircleBorder(),
                padding: EdgeInsets.all(15.0),
                child: Container(
                  width: double.infinity,
                  height: 250,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(150),
                      ),
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: <Color>[
                            apptheme.accentColor,
                            apptheme.accentColor
                          ]),
                      color: apptheme.accentColor,
                    ),
                    child: Lottie.asset(
                      'assets/brain.json',
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(child: _ListaOpciones()),
            SwitchListTile.adaptive(
                value: Preferencess.isDarkmode,
                title: Text('CAMBIO COLOR DE FONDO '),
                onChanged: (value) {
                  Preferencess.isDarkmode = value;
                  final themeProvider =
                      Provider.of<ThemeProvider>(context, listen: false);

                  value
                      ? themeProvider.setDarkMode()
                      : themeProvider.setLightMode();
                  setState(() {});
                }),
          ],
        ),
      ),
    );
  }
}
