import 'package:flutter/material.dart';
import 'package:spendify/pallete.dart';
import 'package:spendify/views/login_page.dart';

Future<void> mostrarAlerta(BuildContext context, String title, String message) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white, // Cambiar color de fondo
        shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(15)), // Añadir bordes redondeados
        title: Row(
          children: [
            const Icon(Icons.warning,
                color: Colors.red), // Añadir un icono al título
            const SizedBox(width: 10),
            Text(title,
                style: const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Text(
          message,
          style: const TextStyle(color: Colors.grey),
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
                primary: Pallete.primary), // Cambiar color del botón
            child: const Text('Entendido'),
            onPressed: () {
              Navigator.of(context).pop();
              if (message == "Session time expired!") {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                    (route) => false);
              }
            },
          ),
        ],
      );
    },
  );
}
