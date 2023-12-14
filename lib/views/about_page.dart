import 'package:flutter/material.dart';
import 'package:spendify/pallete.dart';
import 'package:spendify/views/terms_page.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Pallete.primary,
        title: const Text(
          "Acerca de",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                      child: Image.asset(
                        'assets/images/logo.png',
                        height: 225,
                        width: 225,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    const Text(
                      'SpendiFy',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Color.fromARGB(255, 0, 0, 0),
                        decoration: TextDecoration.none,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    const Text(
                      'Version 1.0',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Color.fromARGB(255, 0, 0, 0),
                        decoration: TextDecoration.none,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    // Términos y condiciones con MouseRegion para el cursor
                    MouseRegion(
                      cursor: SystemMouseCursors.click,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TermsAndConditions(),
                            ),
                          );
                        },
                        child: const Text(
                          'Términos y condiciones',
                          style: TextStyle(
                            fontSize: 16.0,
                            color: Pallete.primary,
                            decoration: TextDecoration.underline,
                            decorationColor: Pallete.primary,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    const Text(
                      '© 2023 SpendiFy',
                      textAlign: TextAlign.left,
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 12.0,
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
  }
}