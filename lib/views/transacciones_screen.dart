import 'package:flutter/material.dart';

class AgregarTransaccionScreen extends StatefulWidget {
  const AgregarTransaccionScreen({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _AgregarTransaccionScreenState createState() => _AgregarTransaccionScreenState();
}


class _AgregarTransaccionScreen extends StatefulWidget {
  @override
  _AgregarTransaccionScreenState createState() =>
      _AgregarTransaccionScreenState();
}

class _AgregarTransaccionScreenState extends State<AgregarTransaccionScreen> {
  String? categoriaSeleccionada;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Añadir Transacción'),
        backgroundColor: Color(0xFF00477B),
        actions: [
          ElevatedButton(
            onPressed: () {
              seleccionarCategoria('Ingresos');
            },
            child: Text('Ingresos', style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              primary: Color(0xFF00477B),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    seleccionarCategoria('Gastos');
                  },
                  child: Text('Gastos', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF00477B),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    seleccionarCategoria('Ingresos');
                  },
                  child:
                      Text('Ingresos', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF00477B),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 150,
                  child: TextField(
                    decoration: InputDecoration(
                      labelText: 'Cantidad',
                      suffix: Text('MX', style: TextStyle(color: Colors.grey)),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text('Seleccione Categoría',
                        style: TextStyle(color: Colors.grey)),
                  ),
                  DropdownButton<String>(
                    isExpanded: true,
                    underline: Container(),
                    value: categoriaSeleccionada ??
                        'Comida', // Valor predeterminado
                    onChanged: (String? newValue) {
                      setState(() {
                        categoriaSeleccionada = newValue;
                        print('Categoría seleccionada: $categoriaSeleccionada');
                      });
                    },
                    items: [
                      'Comida',
                      'Transporte',
                      'Servicios',
                      'Salud',
                      'Entretenimiento',
                      'Educación',
                      'Cuidado Personal',
                      'Ropa',
                      'Hogar',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(value),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Text('Añade Descripción del Gasto',
                    style: TextStyle(color: Colors.white)),
              ],
            ),
            SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(5),
              ),
              child: TextField(
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Añade descripción del gasto',
                  contentPadding: EdgeInsets.all(8),
                  border: InputBorder.none,
                ),
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                print('Añadiendo transacción...');
              },
              child: Text('Añadir'),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF00477B),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void seleccionarCategoria(String categoria) {
    setState(() {
      categoriaSeleccionada = categoria;
      print('Categoría seleccionada: $categoriaSeleccionada');
    });
  }
}
