import 'package:flutter/material.dart';
import 'package:spendify/pallete.dart';
import 'package:spendify/services/loginService.dart';
import 'package:spendify/widgets/buttons/button.dart';
import 'package:spendify/widgets/fields/textfield.dart';
import 'package:spendify/views/codepassword_page.dart';

class EmailPage extends StatefulWidget {
  const EmailPage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _EmailPageState createState() => _EmailPageState();
}

class _EmailPageState extends State<EmailPage> {
  final TextEditingController _correoController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final double verticalSpacing = 24.0;
  final LoginService service = LoginService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Pallete.primary,
        title: const Text(
          "Recuperar contraseña",
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
      body: Padding(
        padding:
            const EdgeInsets.fromLTRB(25.0, kToolbarHeight + 20.0, 25.0, 0),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Para restablecer el acceso, ingrese su correo electrónico',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 90.0),
                TextFieldGeneric(
                  textController: _correoController,
                  hintText: 'Correo electrónico',
                  labelText: 'Correo electrónico',
                  keyboardType: TextInputType.emailAddress,
                  obscureText: false,
                  validator: null,
                ),
                const SizedBox(height: 40.0),
                Button(
                  onPressed: () async {
                    if (_correoController.text.isNotEmpty) {
                      final response = await service.sendEmail(
                          context, _correoController.text.trim());
                      if (response) {
                        // ignore: use_build_context_synchronously
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CodePasswordPage(
                                email: _correoController.text.trim()),
                          ),
                        );
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Por favor, complete todos los campos obligatorios.',
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  label: 'Siguiente',
                ),
                const SizedBox(height: 20.0),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CodePasswordPage(
                                email: _correoController.text.trim())),
                      );
                    },
                    child: const Text(
                      '¿Ya tienes un codigo? Clic aquí',
                      style: TextStyle(
                        color: Pallete.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
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
    );
  }
}
