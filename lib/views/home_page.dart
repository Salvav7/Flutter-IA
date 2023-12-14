import 'package:flutter/material.dart';
import 'package:spendify/pallete.dart';
import 'package:spendify/services/loginService.dart';
import 'package:spendify/services/transaccionService.dart';
import 'package:spendify/views/login_page.dart';
import 'package:spendify/views/usersettings_page.dart';
import 'package:spendify/views/applicationsettings_page.dart';
import 'package:spendify/views/about_page.dart';
import 'package:spendify/views/scanner_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final LoginService service = LoginService();
  final TransaccionService transaccionalService = TransaccionService();
  late String user = "";

  Future<void> fetchData() async {
    setState(() {
      // Mostrar la animación de carga antes de obtener los datos
    });

    final data = await service.getUser(context);

    if (mounted) {
      setState(() {
        user = data ?? "";
        // Ocultar la animación de carga una vez que se obtienen los datos
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData(); // Llamamos a la función para obtener los datos al inicio
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Pallete.backgroundColor,
        elevation: 0,
      ),
      drawer: Drawer(
        child: Container(
          color: Pallete.primary, // Color de fondo del Drawer
          child: ListView(
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Pallete.primary, // Color de fondo del DrawerHeader
                  border: Border(
                    bottom: BorderSide(
                      color: Colors.black, // Color de la línea
                      width: 1.0, // Ancho de la línea
                    ),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CircleAvatar(
                      backgroundImage: AssetImage('assets/images/usuario.png'),
                      radius: 40,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      user,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.home, color: Colors.black),
                title:
                    const Text('Inicio', style: TextStyle(color: Colors.black)),
                onTap: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomePage()),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.person, color: Colors.black),
                title:
                    const Text('Perfil', style: TextStyle(color: Colors.black)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const UsersettingsPage()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.info, color: Colors.black),
                title: const Text('Acerca de',
                    style: TextStyle(color: Colors.black)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AboutPage()),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.settings, color: Colors.black),
                title: const Text('Configuración',
                    style: TextStyle(color: Colors.black)),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ApplicationsettingsPage()),
                  );
                },
              ),
              const Divider(color: Colors.black),
              ListTile(
                leading: const Icon(Icons.exit_to_app, color: Colors.black),
                title: const Text('Cerrar sesión',
                    style: TextStyle(color: Colors.black)),
                onTap: () async {
                  await service.logout();
                  // ignore: use_build_context_synchronously
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginPage()),
                      (route) => false);
                },
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Center(
              child: Text(
                'Bienvenido, $user',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            const SizedBox(height: 200),
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'Esta aplicación utiliza inteligencia artificial para reconocer a Bernardo y Erick en imágenes. ¡Captura una foto o selecciona una de tu galería para probarlo!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // Navegar a otra página al presionar el botón
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DocumentScannerPage()),
                );
              },
              style: ElevatedButton.styleFrom(
                shape: const CircleBorder(),
                padding: const EdgeInsets.all(20),
              ),
              child: const Icon(Icons.arrow_forward),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
