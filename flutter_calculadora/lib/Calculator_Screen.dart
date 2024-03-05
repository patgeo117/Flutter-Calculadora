import 'package:flutter_calculadora/button_values.dart';
// paquete de flutter para crear la interfaz de usuario

import 'package:flutter/material.dart';
// clase que crea la pantalla de la calculadora

import 'package:intl/intl.dart';
// NumberFormat para modificar cadenas de texto

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});
  // crea el estado de la pantalla de la calculadora
  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
  // crea el estado de la pantalla de la calculadora
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String number1 = ""; // . 0-9
  String operand = ""; // + - * /
  String number2 = ""; // . 0-9

  @override
  Widget build(BuildContext context) {
    // crea la pantalla de la calculadora
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        // crea un area segura para la pantalla de la calculadora
        bottom: false,
        child: Column(
          // crea una columna para la pantalla de la calculadora
          children: [
            // output
            Expanded(
              child: SingleChildScrollView(
                reverse: true,
                child: Container(
                  // crea un contenedor para la pantalla de la calculadora
                  alignment: Alignment.bottomRight,
                  // alinea el contenedor a la derecha
                  padding: const EdgeInsets.all(16),
                  // añade un padding al contenedor
                  child: Text(
                    "$number1$operand$number2".isEmpty
                        ? "0"
                        : "$number1$operand$number2",
                    style: const TextStyle(
                      // estilo del texto
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.end,
                  ),
                ),
              ),
            ),

            // buttons
            Wrap(
              children: Btn.buttonValues
                  .map(
                    (value) => SizedBox(
                      // crea un contenedor para los botones
                      width: value == Btn.n0
                          ? screenSize.width / 2
                          : (screenSize.width / 4),
                          // añade un ancho al contenedor
                      height: screenSize.width / 5,
                      // añade un alto al contenedor
                      child: buildButton(value),
                      
                    ),
                  )
                  .toList(),
            )
          ],
        ),
      ),
    );
  }

  Widget buildButton(value) {
    // crea un boton
    return Padding(
      padding: const EdgeInsets.all(4.0),
      // añade un padding al boton
      child: Material(
        color: getBtnColor(value),
        // color del boton
        clipBehavior: Clip.hardEdge,
        // añade un clip al boton
        shape: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.white24,
            // color del borde
          ),
          borderRadius: BorderRadius.circular(100),
        ),
        child: InkWell(
          onTap: () => onBtnTap(value),
          // añade una accion al boton
          child: Center(
            child: Text(
              value,
              // texto del boton
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
            ),
          ),
        ),
      ),
    );
  }
  
  void onBtnTap(String value) {
    // 0-9, ., +, -, *, /, del, clr, per, calculate
    if (value == Btn.del) {
      delete();
      return;
    }

    if (value == Btn.clr) {
      clearAll();
      return;
    }

    if (value == Btn.per) {
      convertToPercentage();
      return;
    }

    if (value == Btn.calculate) {
      calculate();
      return;
    }

    appendValue(value);
  }

  // calculo de las operaciones
  void calculate() {
    if (number1.isEmpty) return;
    if (operand.isEmpty) return;
    if (number2.isEmpty) return;
    // 123+123

    final double num1 = double.parse(number1);
    final double num2 = double.parse(number2);

    var result = 0.0;
    // resultado se inicializa en 0
    switch (operand) {
      case Btn.add:
        result = num1 + num2;
        break;
      case Btn.subtract:
        result = num1 - num2;
        break;
      case Btn.multiply:
        result = num1 * num2;
        break;
      case Btn.divide:
        result = num1 / num2;
        break;
      default:
    }

    setState(() {

       number1 = result.toString(); // Convertir el resultado a una cadena
    
    if (number1.length > 8) {
      // Si el número de dígitos es mayor que 8, no se acortará
      number1 = result.toStringAsPrecision(15); // Cambiar a una precisión mayor
    } else if (number1.endsWith(".0")) {
      number1 = number1.substring(0, number1.length - 2);
    }

      // Aplicar formato con NumberFormat
      number1 = NumberFormat("#,##0.00").format(double.parse(number1));

      operand = "";
      number2 = "";
      // se reinician las variables
    });
  }

  // convertir a porcentaje
  void convertToPercentage() {
    // 123 => 1.23
    if (number1.isNotEmpty && operand.isNotEmpty && number2.isNotEmpty) {
      // calcula el resultado antes de convertir a porcentaje
      calculate();
    }

    if (operand.isNotEmpty) {
      // realiza el calculo antes de convertir a porcentaje
      return;
    }

    final number = double.parse(number1);
    // convierte el numero a porcentaje
    setState(() {
      number1 = "${(number / 100)}";
      operand = "";
      number2 = "";
    });
  }

  // limpiar pantalla
  void clearAll() {
    setState(() {
      number1 = "";
      operand = "";
      number2 = "";
    });
  }

  // eliminar el ultimo valor
  void delete() {
    if (number2.isNotEmpty) {
      // 12323 => 1232
      number2 = number2.substring(0, number2.length - 1);
    } else if (operand.isNotEmpty) {
      operand = "";
    } else if (number1.isNotEmpty) {
      number1 = number1.substring(0, number1.length - 1);
    }

    setState(() {});
  }

  // anexa el valor al final de la pantalla
  void appendValue(String value) {
    // number1 opernad number2
    // 234       +      5343

    // asigna el valor al operando
    if (value != Btn.dot && int.tryParse(value) == null) {
      if (operand.isNotEmpty && number2.isNotEmpty) {
        // se calcula el resultado antes de asignar el valor al operando
        calculate();
      }
      operand = value;
    }
    // asigna el valor a number1 variable
    else if (number1.isEmpty || operand.isEmpty) {
      // chekea si el valor es "." | ex: number1 = "1.2"
      if (value == Btn.dot && number1.contains(Btn.dot)) return;
      if (value == Btn.dot && (number1.isEmpty || number1 == Btn.n0)) {
        // ex: number1 = "" | "0"
        value = "0.";
      }
      number1 += value;
    }
    // asigna el valor a number2 variable
    else if (number2.isEmpty || operand.isNotEmpty) {
      // chekea si el valor es "." | ex: number2 = "1.2"
      if (value == Btn.dot && number2.contains(Btn.dot)) return;
      if (value == Btn.dot && (number2.isEmpty || number2 == Btn.n0)) {
        // number1 = "" | "0"
        value = "0.";
      }
      number2 += value;
    }

    setState(() {});
  }

  // color del boton
  Color getBtnColor(value) {
    return [Btn.del, Btn.clr].contains(value)
        ? const Color.fromARGB(255, 77, 92, 100)
        : [
            Btn.per,
            Btn.multiply,
            Btn.add,
            Btn.subtract,
            Btn.divide,
            Btn.calculate,
          ].contains(value)
            ? const Color.fromARGB(255, 9, 157, 206)
            : Colors.black87;
  }
}