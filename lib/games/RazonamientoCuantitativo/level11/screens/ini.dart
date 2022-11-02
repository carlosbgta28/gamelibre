import 'package:flutter/material.dart';

class InitPreview extends StatelessWidget {
  const InitPreview({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
        child: Container(
          width: double.infinity,
          height: 430,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Color(0xffFfCF53)),
          child: Column(
            children: <Widget>[_Zapatoconsombra(), _Zapatostalla()],
          ),
        ));
  }
}

class _Zapatostalla extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          _TallazapatoCaja(7),
          _TallazapatoCaja(7.5),
          _TallazapatoCaja(8),
          _TallazapatoCaja(8.5),
          _TallazapatoCaja(9),
          _TallazapatoCaja(9.5),
        ],
      ),
    );
  }
}

class _TallazapatoCaja extends StatelessWidget {
  final double numero;

  const _TallazapatoCaja(this.numero);

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        child: Text(
          '${numero.toString().replaceAll('.0', '')}',
          style: TextStyle(
              color: (this.numero == 9) ? Colors.white : Color(0xffF1A23A),
              fontSize: 16,
              fontWeight: FontWeight.bold),
        ),
        width: 45,
        height: 45,
        decoration: BoxDecoration(
            color: (this.numero == 9) ? Color(0xffF1A23A) : Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              if (this.numero == 9)
                BoxShadow(
                    color: Color(0xffF1A23A),
                    blurRadius: 10,
                    offset: Offset(0, 5))
            ]));
  }
}

class _Zapatoconsombra extends StatelessWidget {
  const _Zapatoconsombra({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(50),
      child: Stack(
        children: <Widget>[
          Positioned(bottom: 20, right: 0, child: _zapatosombra()),
          Image(image: AssetImage('assets/manthumbs.png'))
        ],
      ),
    );
  }
}

class _zapatosombra extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -0.5,
      child: Container(
        width: 230,
        height: 120,
        decoration: BoxDecoration(
            //color: Colors.transparent,
            borderRadius: BorderRadius.circular(100),
            boxShadow: [
              BoxShadow(
                color: Color(0xffEAA14E),
                blurRadius: 40,
              )
            ]),
      ),
    );
  }
}
