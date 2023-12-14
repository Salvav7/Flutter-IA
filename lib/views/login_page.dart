import 'package:flutter/material.dart';
import 'package:spendify/pallete.dart';
import 'package:spendify/services/loginService.dart';
import 'package:spendify/widgets/fields/textfield.dart';
import 'package:spendify/widgets/buttons/button.dart';
import 'package:spendify/views/register_page.dart';
import 'package:spendify/views/email_page.dart';
import 'package:spendify/views/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final LoginService service = LoginService();
  bool _obscureText = true;
  bool _isLoading = false;


  @override
  void initState() {
    super.initState();
   
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Pallete.backgroundColor,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Image.asset(
                  'assets/images/logo.png',
                  height: 225,
                  width: 225,
                ),
                const SizedBox(height: 80),
                TextFieldGeneric(
                  textController: emailController,
                  hintText: 'Correo electrónico',
                  labelText: 'Correo electrónico',
                  keyboardType: TextInputType.emailAddress,
                  obscureText: false,
                ),
                const SizedBox(height: 15),
                TextFieldGeneric(
                  textController: passwordController,
                  hintText: 'Contraseña',
                  labelText: 'Contraseña',
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: _obscureText,
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                ),
                const SizedBox(height: 10),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const EmailPage()),
                      );
                    },
                    child: const Text(
                      '¿Olvidaste tu contraseña? Recupérala',
                      style: TextStyle(
                        color: Pallete.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                _isLoading
                    ? CircularProgressIndicator() // Muestra la animación de carga si isLoading es verdadero
                    : Button(
                        onPressed: () async {
                          final token = await service.login(
                              context,
                              emailController.text.trim(),
                              passwordController.text.trim());
                          if (token == true) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomePage()),
                            );
                          }
                        },
                        label: 'Iniciar sesión',
                      ),
                const SizedBox(height: 10),
                MouseRegion(
                  cursor: SystemMouseCursors.click,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Register()),
                      );
                    },
                    child: const Text(
                      '¿No tienes cuenta? Regístrate',
                      style: TextStyle(
                        color: Pallete.primary,
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
