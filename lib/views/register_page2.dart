import 'package:flutter/material.dart';
import 'package:spendify/pallete.dart';
import 'package:spendify/services/loginService.dart';
import 'package:spendify/views/login_page.dart';
import 'package:spendify/widgets/buttons/button.dart';
import 'package:spendify/widgets/fields/textfield.dart';
import 'package:spendify/views/terms_page.dart';

class Register2 extends StatefulWidget {
  final String nombre;
  final String apPaterno;
  final String apMaterno;
  final int edad;
  Register2(
      {Key? key,
      required this.nombre,
      required this.apPaterno,
      required this.apMaterno,
      required this.edad})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _Register2State createState() => _Register2State();
}

class _Register2State extends State<Register2> {
  final TextEditingController _correoController = TextEditingController();
  final TextEditingController _contrasenaController = TextEditingController();
  final TextEditingController _confirmarContrasenaController =
      TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final LoginService service = new LoginService();
  final double verticalSpacing = 24.0;
  bool _obscureText = true;
  bool termsAccepted = false;

  late String nombre;
  late String apPaterno;
  late String apMaterno;
  late int edad;

  @override
  void initState() {
    super.initState();
    nombre = widget.nombre;
    apPaterno = widget.apPaterno;
    apMaterno = widget.apMaterno;
    edad = widget.edad;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Pallete.primary,
        title: const Text(
          "Registro",
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
                    TextFieldGeneric(
                      textController: _telefonoController,
                      hintText: 'Numero de Telefono',
                      labelText: 'Numero de Telefono',
                      keyboardType: TextInputType.number,
                      obscureText: false,
                      validator: null,
                    ),
                    const SizedBox(height: 20.0),
                    TextFieldGeneric(
                      textController: _correoController,
                      hintText: 'Correo Electrónico',
                      labelText: 'Correo Electrónico',
                      keyboardType: TextInputType.emailAddress,
                      obscureText: false,
                      validator: null,
                    ),
                    const SizedBox(height: 20.0),
                    TextFieldGeneric(
                      textController: _contrasenaController,
                      hintText: 'Contraseña',
                      labelText: 'Contraseña',
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: _obscureText,
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                      validator: null,
                    ),
                    const SizedBox(height: 20.0),
                    TextFieldGeneric(
                      textController: _confirmarContrasenaController,
                      hintText: 'Confirmar Contraseña',
                      labelText: 'Confirmar Contraseña',
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: _obscureText,
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                      validator: null,
                    ),
                    const SizedBox(height: 20.0),
                    // Checkbox para aceptar términos y condiciones
                    Center(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TermsAndConditions()),
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Checkbox(
                              value: termsAccepted,
                              onChanged: (value) {
                                setState(() {
                                  termsAccepted = value!;
                                });
                              },
                            ),
                            const Text(
                              'Acepto los ',
                              style: TextStyle(fontSize: 15.0),
                            ),
                            const Text(
                              'términos y condiciones',
                              style: TextStyle(
                                fontSize: 15.0,
                                color: Pallete
                                    .primary, // Cambia el color del texto según lo necesites
                                decoration: TextDecoration.underline,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Button(
                      onPressed: () async {
                        if (_correoController.text.isNotEmpty &&
                            _contrasenaController.text.isNotEmpty &&
                            _confirmarContrasenaController.text.isNotEmpty &&
                            termsAccepted) {
                          if (_contrasenaController.text ==
                              _confirmarContrasenaController.text) {
                            // Validar la contraseña con expresiones regulares
                            RegExp regex = RegExp(
                              r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*\W)(?!.*\s).{8,16}$',
                            );
                            if (!regex.hasMatch(_contrasenaController.text)) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'La contraseña debe contener al menos 1 mayúscula, 1 minúscula, 1 número, 1 carácter especial no alfanumérico y tener una longitud entre 8 y 16 caracteres.',
                                  ),
                                  backgroundColor: Colors.red,
                                ),
                              );
                              return; // Detener el flujo si la contraseña no cumple los requisitos
                            }

                            final response = await service.createAccount(
                              context,
                              nombre,
                              apPaterno,
                              apMaterno,
                              edad,
                              _telefonoController.text.trim(),
                              _correoController.text.trim(),
                              _contrasenaController.text.trim(),
                            );
                            if (response == true) {
                              // ignore: use_build_context_synchronously
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const LoginPage(),
                                ),
                              );
                            }
                          } else {
                            // Las contraseñas no coinciden, mostrar mensaje de error
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
                              content: Text(
                                'Por favor, complete todos los campos y acepte los términos y condiciones.',
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      label: 'Siguiente',
                    ),

                    SizedBox(height: verticalSpacing),
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

bool validatePassword(String password) {
  // Verificar la longitud entre 8 y 16 caracteres
  if (password.length < 8 || password.length > 16) {
    return false;
  }

  // Verificar al menos una mayúscula, una minúscula, un número y un carácter especial
  final hasUppercase = password.contains(RegExp(r'[A-Z]'));
  final hasLowercase = password.contains(RegExp(r'[a-z]'));
  final hasDigit = password.contains(RegExp(r'[0-9]'));
  final hasSpecialCharacters =
      password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

  return hasUppercase && hasLowercase && hasDigit && hasSpecialCharacters;
}
