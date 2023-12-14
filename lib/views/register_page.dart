import 'package:flutter/material.dart';
import 'package:spendify/pallete.dart';
import 'package:spendify/widgets/buttons/button.dart';
import 'package:spendify/widgets/fields/textfield.dart';
import 'package:spendify/views/register_page2.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoPaternoController =
      TextEditingController();
  final TextEditingController _apellidoMaternoController =
      TextEditingController();
  final TextEditingController _edadController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final double verticalSpacing = 24.0;

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
                      textController: _nombreController,
                      hintText: 'Nombre',
                      labelText: 'Nombre',
                      keyboardType: TextInputType.name,
                      obscureText: false,
                      validator: null,
                    ),
                    const SizedBox(height: 20.0),
                    TextFieldGeneric(
                      textController: _apellidoPaternoController,
                      hintText: 'Apellido Paterno',
                      labelText: 'Apellido Paterno',
                      keyboardType: TextInputType.name,
                      obscureText: false,
                      validator: null,
                    ),
                    const SizedBox(height: 20.0),
                    TextFieldGeneric(
                      textController: _apellidoMaternoController,
                      hintText: 'Apellido Materno',
                      labelText: 'Apellido Materno',
                      keyboardType: TextInputType.name,
                      obscureText: false,
                      validator: null,
                    ),
                    const SizedBox(height: 20.0),
                    TextFieldGeneric(
                      textController: _edadController,
                      hintText: 'Edad',
                      labelText: 'Edad',
                      keyboardType: TextInputType.number,
                      obscureText: false,
                      validator: null,
                    ),
                    const SizedBox(height: 20.0),
                    Button(
                      onPressed: () {
                        if (_nombreController.text.isNotEmpty &&
                            _apellidoPaternoController.text.isNotEmpty &&
                            _apellidoMaternoController.text.isNotEmpty &&
                            _edadController.text.isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Register2(
                                    nombre: _nombreController.text.trim(),
                                    apPaterno:
                                        _apellidoPaternoController.text.trim(),
                                    apMaterno:
                                        _apellidoMaternoController.text.trim(),
                                    edad: int.parse(_edadController.text))),
                          );
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
