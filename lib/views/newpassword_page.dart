import 'package:flutter/material.dart';
import 'package:spendify/pallete.dart';
import 'package:spendify/services/loginService.dart';
import 'package:spendify/views/login_page.dart';
import 'package:spendify/widgets/buttons/button.dart';
import 'package:spendify/widgets/fields/textfield.dart';

class NewPasswordPage extends StatefulWidget {
  final int id_user;
  NewPasswordPage({Key? key, required this.id_user}) : super(key: key);
  @override
  // ignore: library_private_types_in_public_api
  _NewPasswordPageState createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  final TextEditingController _contrasenaController = TextEditingController();
  final TextEditingController _confirmarContrasenaController =
      TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final double verticalSpacing = 24.0;
  final LoginService service = new LoginService();

  late int id = 0;
  @override
  void initState() {
    super.initState();
    id = widget.id_user;
  }

  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Pallete.primary,
        title: const Text(
          "Nueva contraseña",
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
                    const SizedBox(height: 20.0),
                    Button(
                      onPressed: () async {
                        if (_contrasenaController.text.isNotEmpty &&
                            _confirmarContrasenaController.text.isNotEmpty) {
                          if (_contrasenaController.text ==
                              _confirmarContrasenaController.text) {
                            final response = await service.changePassword(
                                context,
                                id,
                                _confirmarContrasenaController.text.trim());
                            if (response) {
                              // ignore: use_build_context_synchronously
                              Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const LoginPage()),
                                  (route) => false);
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
                                'Por favor, complete todos los campos',
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      label: 'Siguiente',
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
