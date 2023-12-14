import 'package:flutter/material.dart';
import 'package:spendify/pallete.dart';
import 'views/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dinamyte Inc.',
     theme: ThemeData.dark().copyWith(
          scaffoldBackgroundColor: Pallete.backgroundColor,
          // Puedes personalizar otras propiedades del tema aquí
        ),
      
      debugShowCheckedModeBanner: false,
      home: const LoginPage(), // Cambia esto a la clase LoginPage
    );
  }
}
