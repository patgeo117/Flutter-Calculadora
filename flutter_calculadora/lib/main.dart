import 'package:flutter/material.dart';
import 'Calculator_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // crea la aplicacion de la calculadora
    return MaterialApp(
      title: 'GEP Calculadora',
      // titulo de la aplicacion
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      // tema de la aplicacion
      //home: const CalculatorScreen(),
      // pantalla de la calculadora

      // codigo para cambiar el logo de la aplicacion
      home: Scaffold(
        appBar: AppBar(
          title: const Text('GEP Calculadora'),
        ),
        body: const CalculatorScreen(),
      ),
    );
  }
}
