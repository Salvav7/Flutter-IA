import 'package:flutter/material.dart';
import 'package:spendify/pallete.dart';
import 'package:spendify/services/loginService.dart';
import 'package:spendify/widgets/buttons/button.dart';
import 'package:spendify/widgets/fields/textfield.dart';
import 'package:spendify/services/perfilService.dart';
import 'package:spendify/views/login_page.dart';

class ChangeUserPage extends StatefulWidget {
  const ChangeUserPage({Key? key}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _ChangeUserPageState createState() => _ChangeUserPageState();
}

class _ChangeUserPageState extends State<ChangeUserPage> {
  final TextEditingController _usuarioController = TextEditingController();
  final TextEditingController _apellidoPController = TextEditingController();
  final TextEditingController _apellidoMController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final double verticalSpacing = 24.0;
  final LoginService service = new LoginService();
  final PerfilService perfilService = new PerfilService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Pallete.primary,
        title: const Text(
          "Cambiar usuario",
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
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Form(
              key: formKey,
              child: Builder(
                builder: (context) => Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const SizedBox(height: 180),
                    TextFieldGeneric(
                      textController: _usuarioController,
                      hintText: 'Nombre',
                      labelText: 'Nombre',
                      keyboardType: TextInputType.name,
                      obscureText: false,
                      validator: null,
                    ),
                    const SizedBox(height: 20.0),
                    TextFieldGeneric(
                      textController: _apellidoPController,
                      hintText: 'Apellido paterno',
                      labelText: 'Apellido paterno',
                      keyboardType: TextInputType.name,
                      obscureText: false,
                      validator: null,
                    ),
                    const SizedBox(height: 20.0),
                    TextFieldGeneric(
                      textController: _apellidoMController,
                      hintText: 'Apellido materno',
                      labelText: 'Apellido materno',
                      keyboardType: TextInputType.name,
                      obscureText: false,
                      validator: null,
                    ),
                    const SizedBox(height: 20.0),
                    Button(
                      onPressed: () async {
                        if (_usuarioController.text.isNotEmpty &&
                            _apellidoPController.text.isNotEmpty &&
                            _apellidoMController.text.isNotEmpty) {
                          // Llamada a la función para actualizar la cuenta
                          bool success = await perfilService.updateAccount(
                              context,
                              _usuarioController.text,
                              _apellidoPController.text,
                              _apellidoMController.text);
                          if (success) {
                            // Actualización exitosa, puedes mostrar un mensaje o navegar a otra pantalla
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Actualización exitosa'),
                                backgroundColor: Colors.green,
                              ),
                            );
                            await service.logout();
                            // ignore: use_build_context_synchronously
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginPage()),
                                (route) => false);
                          } else {
                            // Ocurrió un error en la actualización, el manejo de errores debe hacerse en perfilService.updateAccount
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content:
                                  Text('Por favor, complete todos los campos'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      label: 'Guardar',
                    ),
                    const SizedBox(height: 170),
                    const Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 16.0),
                        child: Text(
                          'SpendiFy 2023 ©\nTodos los derechos reservados \u{00A9}\u{00AE}',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}