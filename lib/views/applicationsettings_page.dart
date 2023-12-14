import 'package:flutter/material.dart';
import 'package:spendify/pallete.dart';
import 'package:spendify/views/changepassword_page.dart';
import 'package:spendify/views/changeemail_page.dart';
import 'package:spendify/views/changeuser_page.dart';

class ApplicationsettingsPage extends StatelessWidget {
  const ApplicationsettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Pallete.primary,
        title: const Text(
          "Configuración de la aplicación",
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
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildListTileWithShadow(
                        icon: Icons.email_outlined,
                        text: 'Correo',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ChangeEmailPage(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20.0),
                      _buildListTileWithShadow(
                        icon: Icons.person_pin,
                        text: 'Usuario',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const ChangeUserPage(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20.0),
                      _buildListTileWithShadow(
                        icon: Icons.password,
                        text: 'Contraseña',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>  ChangePasswordPage(),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildListTileWithShadow({
    required IconData icon,
    required String text,
    required Function() onTap,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white, // Cambiar el color del ListTile a blanco
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(
                  255, 255, 255, 255), // Cambiar el color de la sombra
              offset: Offset(0, 2),
              blurRadius: 4,
            ),
          ],
        ),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
          //contentPadding: EdgeInsets.symmetric(vertical: 20.0),
          leading: Icon(
            icon,
            color:
                const Color(0xFF00477b), // Cambiar el color del icono a negro
          ),
          title: Text(
            text,
            style: const TextStyle(
                color: Colors.black), // Cambiar el color del texto a negro
          ),
          onTap: onTap,
        ),
      ),
    );
  }
}
