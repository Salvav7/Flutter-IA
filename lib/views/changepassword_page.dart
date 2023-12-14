import 'package:flutter/material.dart';
import 'package:spendify/pallete.dart';
import 'package:spendify/services/perfilService.dart';
import 'package:spendify/widgets/buttons/button.dart';
import 'package:spendify/widgets/fields/textfield.dart';
import 'package:spendify/views/login_page.dart';
import 'package:spendify/services/loginService.dart';

class ChangePasswordPage extends StatefulWidget {
  const ChangePasswordPage({Key? key}) : super(key: key);

  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController _contrasenaController = TextEditingController();
  final TextEditingController _confirmarContrasenaController =
      TextEditingController();
  final TextEditingController _contrasenaActualController =
      TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final double verticalSpacing = 24.0;
  final PerfilService perfilService = PerfilService();
  final LoginService service = LoginService();

  bool _obscureText = true;

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, introduce una contraseña';
    }
    if (value.length < 8) {
      return 'La contraseña debe tener al menos 8 caracteres';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Pallete.primary,
        title: const Text(
          "Cambiar contraseña",
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const SizedBox(height: 180),
                  TextFieldGeneric(
                    textController: _contrasenaActualController,
                    hintText: 'Contraseña actual',
                    labelText: 'Contraseña actual',
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: _obscureText,
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                    validator: validatePassword,
                  ),
                  const SizedBox(height: 20.0),
                  TextFieldGeneric(
                    textController: _contrasenaController,
                    hintText: 'Nueva Contraseña',
                    labelText: 'Nueva Contraseña',
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: _obscureText,
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                    validator: validatePassword,
                  ),
                  const SizedBox(height: 20.0),
                  TextFieldGeneric(
                    textController: _confirmarContrasenaController,
                    hintText: 'Confirmar nueva Contraseña',
                    labelText: 'Confirmar nueva Contraseña',
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: _obscureText,
                    onPressed: () {
                      setState(() {
                        _obscureText = !_obscureText;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, confirma tu contraseña';
                      }
                      if (value != _contrasenaController.text) {
                        return 'Las contraseñas no coinciden';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20.0),
                  Button(
                    onPressed: () async {
                      if (formKey.currentState?.validate() ?? false) {
                        if (_contrasenaController.text ==
                            _confirmarContrasenaController.text) {
                          String newPassword =
                              _contrasenaController.text.trim();
                          if (newPassword.isNotEmpty) {
                            // Cambia la contraseña
                            bool cambioExitoso =
                                await perfilService.changePassword(
                              context,
                              _contrasenaActualController.text
                                  .trim(), // Contraseña actual
                              newPassword, // Nueva contraseña
                            );

                            if (cambioExitoso) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text('Contraseña cambiada con éxito.'),
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
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'La actualización de contraseña falló.'),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Las contraseñas no coinciden.'),
                              backgroundColor: Colors.red,
                            ),
                          );
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
                  const SizedBox(height: 20.0),
                  const SizedBox(height: 20.0),
                  const SizedBox(height: 20.0),
                  const SizedBox(height: 20.0),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
