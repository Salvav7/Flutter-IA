import 'package:flutter/material.dart';
import 'package:spendify/pallete.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);
  
  @override
  // ignore: library_private_types_in_public_api
  _notificationPageState createState() => _notificationPageState();
}

// ignore: camel_case_types
class _notificationPageState extends State<NotificationPage> {
  //
  List<Widget> listaRectangulos = [];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificaciones', style: TextStyle(color:Colors.white, fontFamily: 'Poppins', fontWeight: FontWeight.bold)),
        backgroundColor: Pallete.primary,
        foregroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
      body: ListView(
        children: [
          ListN(listaRectangulos),

          //Reemplazar botón con una función extrayendo notificaciones nuevas/leídas
          ElevatedButton(
            onPressed: () {
              setState(() {
                listaRectangulos.add(
                  ListItem(
                    titulo: 'Título',
                    descripcion: 'Descripción del elemento',
                    condicion: true,
                  ),
                );
              });
            },
            child: const Text('Agregar Rectángulo'),
          ),
          // Otros widgets pueden agregarse aquí según sea necesario
        ],
        ),
    );
  }
}



class ListN extends StatelessWidget {
  final List<Widget> listaRectangulos;

  ListN(this.listaRectangulos);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: listaRectangulos,
      ),
    );
  }
}

// ignore: must_be_immutable
class ListItem extends StatelessWidget {
  String titulo;
  String descripcion;
  bool condicion = true;

  ListItem({super.key, required this.titulo, required this.descripcion, required this.condicion});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 600,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      color: Pallete.primaryVariant,
      child: Row(

        children: [
          
          Container(
            margin: const EdgeInsets.all(5),
            width: 15.0,
            height: 15.0,
                decoration: BoxDecoration(
                  color: condicion ? const Color.fromRGBO(0, 0, 255, 1) : const Color.fromRGBO(255, 0, 0, 0.0), // Puedes cambiar a cualquier tono de azul marino
                  shape: BoxShape.circle,
                ),
          ),

          Expanded(
            child: ListView(
              children: [
                Text(
            titulo,
            textAlign: TextAlign.start,
            style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8.0),
          Text(
            descripcion,
            textAlign: TextAlign.justify,
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
              ],
            )
          ),
          
        ],
      ),
    );
  }
}