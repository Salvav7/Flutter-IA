import 'package:flutter/material.dart';
import 'package:spendify/pallete.dart';
import 'package:spendify/services/loginService.dart';
import 'package:spendify/widgets/buttons/button.dart';
import 'package:spendify/widgets/fields/textfield.dart';
import 'package:spendify/views/newpassword_page.dart';

class CodePasswordPage extends StatefulWidget {
  final email;
  const CodePasswordPage({Key? key, required this.email}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _CodePasswordPageState createState() => _CodePasswordPageState();
}

class _CodePasswordPageState extends State<CodePasswordPage> {
  final TextEditingController _codeController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final LoginService service = new LoginService();

  late String email = "";

  @override
  void initState() {
    super.initState();
    email = widget.email;
  }

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
            const EdgeInsets.fromLTRB(25.0, kToolbarHeight + 25.0, 25.0, 25.0),
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text(
                  'Se ha enviado un código a su correo electrónico.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10.0),
                const Icon(
                  Icons.email,
                  size: 50,
                  color: Pallete.primary,
                ),
                const SizedBox(height: 20.0),
                const Text(
                  'Ingrese el código de verificación a continuación:',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10.0),
                TextFieldGeneric(
                  textController: _codeController,
                  hintText: 'Código',
                  labelText: 'Código',
                  keyboardType: TextInputType.text,
                  obscureText: false,
                  validator: null,
                ),
                const SizedBox(height: 20.0),
                Button(
                  onPressed: () async {
                    if (_codeController.text.isNotEmpty) {
                      final id = await service.validKey(
                          context, _codeController.text.trim());
                      if (id != 0) {
                        // ignore: use_build_context_synchronously
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    NewPasswordPage(id_user: id)));
                      }
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Por favor, ingresa un código'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  label: 'Siguiente',
                ),
                const SizedBox(height: 10),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () async {
                      final response = await service.sendEmail(context, email);
                      if (response == true) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                                'Se ha enviado una nueva clave a su Email.'),
                            backgroundColor: Colors.green,
                          ),
                        );
                      }
                    },
                    child: const Text(
                      '¿No recibió su código? Enviar nuevo codigo',
                      style: TextStyle(
                        color: Pallete.primary,
                      ),
                    ),
                  ),
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
    );
  }
}
