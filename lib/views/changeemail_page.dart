import 'package:flutter/material.dart';
import 'package:spendify/pallete.dart';
import 'package:spendify/services/loginService.dart';
import 'package:spendify/widgets/buttons/button.dart';
import 'package:spendify/widgets/fields/textfield.dart';
import 'package:spendify/services/perfilService.dart';
import 'package:spendify/views/login_page.dart';

class ChangeEmailPage extends StatefulWidget {
  const ChangeEmailPage({Key? key}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _ChangeEmailPageState createState() => _ChangeEmailPageState();
}

class _ChangeEmailPageState extends State<ChangeEmailPage> {
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _nuevocorreoController = TextEditingController();
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
          "Cambiar correo",
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
                      textController: _correoController,
                      hintText: 'Nuevo Correo',
                      labelText: 'Nuevo Correo',
                      keyboardType: TextInputType.emailAddress,
                      obscureText: false,
                      validator: null,
                    ),
                    const SizedBox(height: 20.0),
                    TextFieldGeneric(
                      textController: _nuevocorreoController,
                      hintText: 'Confirmar Correo',
                      labelText: 'Confirmar Correo',
                      keyboardType: TextInputType.emailAddress,
                      obscureText: false,
                      validator: null,
                    ),
                    const SizedBox(height: 20.0),
                    const SizedBox(height: 20.0),
                    Button(
                      onPressed: () async {
                        if (_correoController.text.isNotEmpty && _nuevocorreoController.text.isNotEmpty) {
                          // Llamada a la función para actualizar la cuenta
                          // Use _nuevocorreoController.text as the new email
                          bool response = await perfilService.updateEmail(
                            context,
                            _correoController.text,
                          );

                          if (response) {
                            // Update was successful, you can perform any additional actions or navigation here
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Actualización exitosa.'),
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
                            // Update failed, handle the error
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('La actualización falló.'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        } else {
                          // Either correo or nuevocorreo is empty, show an error message
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
