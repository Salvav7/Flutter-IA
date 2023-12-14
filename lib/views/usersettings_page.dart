import 'package:flutter/material.dart';
import 'package:spendify/pallete.dart';
import 'package:spendify/services/perfilService.dart';
import 'package:spendify/views/login_page.dart';

class UsersettingsPage extends StatefulWidget {
  const UsersettingsPage({Key? key}) : super(key: key);
  @override
  _UsersettingsPageState createState() => _UsersettingsPageState();
}

class _UsersettingsPageState extends State<UsersettingsPage> {
  final PerfilService service = PerfilService();
  late String nombre = "";
  late int edad = 0;
  late String email = "";
  late String telefono = "";
  bool _isLoading = true;

  init() async {
    final data = await service.getUser(context);
    if (data != null) {
      if (mounted) {
        setState(() {
          nombre = data["nombre"] +
              " " +
              data["apellidoPaterno"] +
              " " +
              data["apellidoMaterno"];
          edad = data["edad"];
          email = data["email"];
          telefono = data["telefono"];
          _isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Pallete.primary,
        title: const Text(
          "Configuración del perfil",
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
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20.0),
                    const CircleAvatar(
                      backgroundImage: AssetImage('assets/images/usuario.png'),
                      radius: 70,
                    ),
                    const SizedBox(height: 40),
                    Container(
                      //width:200, // Ancho fijo para el contenedor, puedes ajustarlo según tus necesidades
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          'Nombre: ' + nombre,
                          style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 19,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 35),
                    Container(
                      //width:200, // Ancho fijo para el contenedor, puedes ajustarlo según tus necesidades
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          'Edad: ' + edad.toString(),
                          style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 19,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 35),
                    Container(
                      //width:200, // Ancho fijo para el contenedor, puedes ajustarlo según tus necesidades
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          'Email: ' + email,
                          style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 19,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 35),
                    Container(
                      //width:200, // Ancho fijo para el contenedor, puedes ajustarlo según tus necesidades
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(
                          'Telefono: ' + telefono,
                          style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 19,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 120),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FloatingActionButton(
                          heroTag: 'deleteButton',
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("SpendiFy"),
                                  content: const Text(
                                    "¿Está seguro de querer eliminar la cuenta?",
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text(
                                        'Cancelar',
                                        style: TextStyle(
                                          color: Pallete.primary,
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        final response = await service
                                            .deleteAccount(context);
                                        Navigator.of(context).pop();
                                        if (response) {
                                          Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const LoginPage(),
                                            ),
                                            (route) => false,
                                          );
                                        }
                                      },
                                      child: const Text(
                                        'Eliminar',
                                        style: TextStyle(
                                          color: Pallete.primary,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          backgroundColor: Pallete.primary,
                          child: const Icon(
                            Icons.delete,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                        FloatingActionButton(
                          heroTag: 'exitButton',
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("SpendiFy"),
                                  content: const Text(
                                    "¿Desea cerrar sesión?",
                                  ),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text(
                                        'Cancelar',
                                        style: TextStyle(
                                          color: Pallete.primary,
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        await service.logout();
                                        Navigator.of(context).pop();
                                        Navigator.pushAndRemoveUntil(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const LoginPage(),
                                          ),
                                          (route) => false,
                                        );
                                      },
                                      child: const Text(
                                        'Cerrar Sesión',
                                        style: TextStyle(
                                          color: Pallete.primary,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          backgroundColor: Pallete.primary,
                          child: const Icon(
                            Icons.exit_to_app,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}