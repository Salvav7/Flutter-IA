import 'package:flutter/material.dart';
import 'package:spendify/pallete.dart';
import 'package:spendify/services/transaccionService.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final TransaccionService transaccionService = TransaccionService();
  //
  List<Widget> listaRectangulos = [];
  bool _isLoading = true;

  init() async {
    var data = await transaccionService.getAllIncomes(context);
    final data2 = await transaccionService.getAllExpenses(context);
    data += data2;
    data.sort((a, b) {
      return a['fecha'].toString().compareTo(b['fecha'].toString());
    });
    data = data.reversed.toList();
    if (mounted && data != null) {
      setState(() {
        for (int i = 0; i < data.length; i++) {
          final item = ListItem(
            titulo: data[i]["idTipo"] == 1
                ? 'Ingreso'
                : data[i]["idTipo"] == 2
                    ? 'Ahorro'
                    : 'Gasto',
            fecha: data[i]["fecha"] ?? "",
            descripcion: data[i]["descripcion"] ?? "",
            cantidad: data[i]["monto"] ?? 0,
            condicion:
                data[i]["idTipo"] == 1 || data[i]["idTipo"] == 2 ? true : false,
          );
          this.listaRectangulos.add(item);
        }
      });
    }
    setState(() {
      _isLoading = false; // Desactiva la animación cuando los datos estén listos
    });
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        title: const Text('Historial',
            style: TextStyle(
                color: Colors.white,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold)),
        backgroundColor: Pallete.primary,
        foregroundColor: const Color.fromARGB(255, 255, 255, 255),
      ),
        body: _isLoading
          ? Center(child: CircularProgressIndicator())
      :listaRectangulos.isEmpty? Center(child: Text("Sin transacciones.")): ListView(
        children: [
          ListH(listaRectangulos),

        ],
      ),
    );
  }
}

class ListH extends StatelessWidget {
  final List<Widget> listaRectangulos;

  ListH(this.listaRectangulos);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(16.0),
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
  String fecha;
  String descripcion;
  bool condicion = true;
  double cantidad;

  ListItem(
      {super.key,
      required this.titulo,
      required this.fecha,
      required this.descripcion,
      required this.condicion,
      required this.cantidad});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: condicion ? Color.fromRGBO(83, 255, 67, 1): Color.fromRGBO(255, 72, 72, 1), 
                borderRadius: BorderRadius.circular(15),
              ),
      height: 100,
      width: 600,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              color: Color.fromRGBO(255, 217, 0, 0),
              margin: EdgeInsets.only(
                  left: 16.0, top: 8.0, bottom: 8.0), // Márgenes a la derecha
              child: ListView(
                children: [
                  Text(
                    titulo,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    fecha,
                    textAlign: TextAlign.justify,
                    style: TextStyle(color: Colors.black, fontSize: 12),
                  ),
                  Text(
                    descripcion,
                    textAlign: TextAlign.justify,
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              "\$" + cantidad.toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: condicion
                      ? const Color.fromRGBO(0, 132, 0, 1)
                      : Color.fromRGBO(133, 3, 3, 1),
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

