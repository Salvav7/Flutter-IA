import 'package:flutter/material.dart';
import 'package:spendify/pallete.dart';

class Gasto {
  String categoria;
  double precio;

  Gasto(this.categoria, this.precio);
}

class Ingreso {
  String fuente;
  double monto;

  Ingreso(this.fuente, this.monto);
}

class GastosScreen extends StatefulWidget {
  const GastosScreen({Key? key}) : super(key: key);

  @override
  _GastosScreenState createState() => _GastosScreenState();
}

class _GastosScreenState extends State<GastosScreen> {
  double saldo = 1000.0;
  List<Gasto> gastos = [
    Gasto('Comida', 200),
    Gasto('Comida', 200),
    Gasto('Comida', 200),
    // Puedes agregar más elementos con diferentes categorías y precios aquí
  ];

  List<Ingreso> ingresos = [
    Ingreso('Trabajo', 1000),
    Ingreso('Freelance', 500),
    Ingreso('Regalo', 200),
    // Puedes agregar más elementos con diferentes fuentes y montos aquí
  ];

  String seccionActual = 'Gastos';

  @override
  void initState() {
    super.initState();
    actualizarContenido(seccionActual);
  }

  void actualizarContenido(String palabra) {
    setState(() {
      seccionActual = palabra;
    });
  }

  Widget buildContenido() {
    if (seccionActual == 'Gastos') {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
        child: Column(
          children: gastos.map((gasto) {
            return Container(
              margin: EdgeInsets.only(bottom: 10.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blue, width: 2.0),
                  borderRadius: BorderRadius.circular(10.0),
                  color: Pallete.primary.withOpacity(0.1),
                ),
                padding: EdgeInsets.all(16.0),
                child: Text(
                  '${gasto.categoria} ${gasto.precio.toString()}',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      );
    } else if (seccionActual == 'Ingresos') {
      return Container(
        margin: EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
        child: Column(
          children: ingresos.map((ingreso) {
            return Container(
              margin: EdgeInsets.only(bottom: 10.0),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green, width: 2.0),
                  borderRadius: BorderRadius.circular(10.0),
                  color: Pallete.primary.withOpacity(0.1),
                ),
                padding: EdgeInsets.all(16.0),
                child: Text(
                  '${ingreso.fuente} ${ingreso.monto.toString()}',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      );
    }

    return Container();
  }

  Widget buildSeccion(String seccion, bool isSelected) {
    return GestureDetector(
      onTap: () => actualizarContenido(seccion),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        color: Colors.white,
        child: Column(
          children: [
            Text(
              seccion,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.orange : Colors.black,
              ),
            ),
            if (isSelected)
              Container(
                height: 2.0,
                width: 30.0,
                color: Colors.orange,
              ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
      ),
      drawer: Drawer(
        child: Container(
          color: Pallete.primary,
          child: ListView(
            children: const <Widget>[
              DrawerHeader(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      backgroundImage: AssetImage('assets/images/usuario.png'),
                      radius: 40,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Nombre del Usuario',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
              ListTile(
                leading: Icon(Icons.home, color: Colors.white),
                title: Text('Inicio', style: TextStyle(color: Colors.white)),
              ),
              ListTile(
                leading: Icon(Icons.notifications, color: Colors.white),
                title: Text(
                  'Notificaciones',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              ListTile(
                leading: Icon(Icons.attach_money, color: Colors.white),
                title: Text('Divisa', style: TextStyle(color: Colors.white)),
              ),
              ListTile(
                leading: Icon(Icons.person, color: Colors.white),
                title: Text('Perfil', style: TextStyle(color: Colors.white)),
              ),
              ListTile(
                leading: Icon(Icons.info, color: Colors.white),
                title: Text('Acerca de', style: TextStyle(color: Colors.white)),
              ),
              ListTile(
                leading: Icon(Icons.settings, color: Colors.white),
                title: Text(
                  'Configuración',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              Divider(color: Colors.white),
              ListTile(
                leading: Icon(Icons.exit_to_app, color: Colors.white),
                title: Text(
                  'Cerrar sesión',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          margin: const EdgeInsets.all(30),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: Colors.orange,
                        width: 2.0,
                      ),
                    ),
                  ),
                  child: Text(
                    'Hola, Salvador',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'SALDO DISPONIBLE',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  '\$${saldo.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    buildSeccion('Gastos', seccionActual == 'Gastos'),
                    SizedBox(width: 60),
                    buildSeccion('Ingresos', seccionActual == 'Ingresos'),
                  ],
                ),
                SizedBox(height: 10),
                buildContenido(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
