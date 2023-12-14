import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:spendify/pallete.dart';
import 'package:spendify/services/transaccionService.dart';
import 'package:spendify/views/addgasto_page.dart';
import 'package:spendify/views/budget_page.dart';

class BudgetDetailPage extends StatefulWidget {
  final int idPresupuesto;
  final String fechaInicio;
  final String fechaFin;
  final double montoTotal;
  final int option;
  BudgetDetailPage(
      {Key? key,
      required this.idPresupuesto,
      required this.fechaInicio,
      required this.fechaFin,
      required this.montoTotal,
      required this.option})
      : super(key: key);

  @override
  _BudgetDetailPageState createState() => _BudgetDetailPageState();
}

class _BudgetDetailPageState extends State<BudgetDetailPage> {
  final TransaccionService service = TransaccionService();
  TextEditingController _amountController = TextEditingController();
  late int idPresupuesto;
  late String fechaInicio;
  late String fechaFin;
  late double montoTotal;
  late int option;
  late List<Detail> _details = [];
  late num disponible = 0;
  late List<String> list = [];
  late List<int> ids = [];
  late int idValue = 0;
  bool _isLoading = false;

  init() async {
    final response = await service.getDetailsbyBudget(context, idPresupuesto);
    if (mounted && response != null) {
      setState(() {
        _isLoading = false;
        num sum = 0;
        for (int i = 0; i < response.length; i++) {
          final item = Detail(
            idDetail: response[i]["idPresupuestoDetalle"],
            onPresed: () {
              _removeRecuadro();
            },
          );
          _details.add(item);
          sum += response[i]["monto"];
        }
        disponible = montoTotal - sum;
      });
    }
  }

  void _removeRecuadro() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => BudgetDetailPage(
          idPresupuesto: idPresupuesto,
          fechaInicio: fechaInicio,
          fechaFin: fechaFin,
          montoTotal: montoTotal,
          option: option,
        ),
      ),
    );
  }

  @override
  void initState() {
    _isLoading = true;
    super.initState();
    fechaInicio = widget.fechaInicio;
    fechaFin = widget.fechaFin;
    montoTotal = widget.montoTotal;
    idPresupuesto = widget.idPresupuesto;
    option = widget.option;
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Pallete.primary,
          title: const Text(
            "Detalle de presupuesto",
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            // onPressed: () {
            //   Navigator.pushReplacement(
            //     context,
            //     MaterialPageRoute(builder: (context) => const BudgetPage()),
            //   );
            // },
            onPressed: () {
              if (option == 1) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const BudgetPage()),
                );
              } else {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => AddGastoPage()),
                );
              }
            }
          ),
        ),
        
        
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (_isLoading) // Mostrar la animación de carga si _isLoading es verdadero
                  CircularProgressIndicator(),
                if (!_isLoading) // Mostrar los detalles solo si _isLoading es falso
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Del ${fechaInicio} al ${fechaFin}',
                            style: TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 14),
                          // Text(
                          //   '\$' +
                          //       disponible.toString() +
                          //       ' disponibles de: \$' +
                          //       montoTotal.toString(),
                          //   style: TextStyle(fontSize: 18, color: Colors.black),
                          // ),
                          Text(
                            '\$${disponible.toStringAsFixed(2)} disponibles de: \$${montoTotal.toStringAsFixed(2)}',
                            style: TextStyle(fontSize: 18, color: Colors.black),
                          ),

                          const SizedBox(height: 20.0),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: _details.length == 0
                                ? [
                                    Center(
                                        child: Text(
                                      "Sin detalles registrados",
                                      textAlign: TextAlign.center,
                                    ))
                                  ]
                                : _details,
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () async {
            final types = await service.getTypesExpenses(context);
            if (types != null) {
              String dropdownValue = "";
              setState(() {
                this.list.clear();
                this.ids.clear();
                this._amountController.text = "";
                this.idValue = 0;
                for (int i = 0; i < types.length; i++) {
                  this.list.add(types[i]["tipo"]);
                  ids.add(types[i]["idTipoGasto"]);
                }
                dropdownValue = list.first;
                idValue = ids.first;
              });
              // ignore: use_build_context_synchronously
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  if (disponible != 0) {
                    return AlertDialog(
                      title: const Text('Agregar Detalle'),
                      content: SingleChildScrollView(
                          child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          DropdownMenu<String>(
                            width: 200,
                            initialSelection: list.first,
                            onSelected: (String? value) {
                              // This is called when the user selects an item.
                              setState(() {
                                dropdownValue = value!;
                                final index = list.indexOf(dropdownValue);
                                idValue = ids[index];
                              });
                            },
                            dropdownMenuEntries: list
                                .map<DropdownMenuEntry<String>>((String value) {
                              return DropdownMenuEntry<String>(
                                  value: value, label: value);
                            }).toList(),
                          ),
                          TextField(
                            decoration: const InputDecoration(
                              labelText: 'Monto',
                            ),
                            controller: _amountController,
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                RegExp(r'^\d*\.?\d{0,2}'),
                              ),
                            ],
                          ),
                          // Text("\$" + "${disponible} max."),
                          Text("\$" + "${disponible.toStringAsFixed(2)} max."),
                        ],
                      )),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Cancelar'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: const Text('Agregar'),
                          onPressed: () async {
                            final valor = num.parse(_amountController.text);
                            if (valor > disponible || valor <= 0) {
                              String errorMessage = 'Cantidad invalida!';
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Error'),
                                    content: Text(errorMessage),
                                    actions: <Widget>[
                                      TextButton(
                                        child: const Text('Aceptar'),
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            } else {
                              final data = await service.saveNewDetail(
                                  context,
                                  idPresupuesto,
                                  idValue,
                                  num.parse(_amountController.text));
                              if (data != null) {
                                setState(() {
                                  _details.add(
                                    Detail(
                                      idDetail: data["idPresupuestoDetalle"],
                                      onPresed: () {
                                        _removeRecuadro();
                                      },
                                    ),
                                  );
                                  disponible -= data["monto"];
                                });
                                Navigator.of(context).pop();
                              }
                            }
                          },
                        ),
                        // TextButton(
                        //   child: const Text('Cancelar'),
                        //   onPressed: () {
                        //     Navigator.of(context).pop();
                        //   },
                        // ),
                      ],
                    );
                  } else {
                    return AlertDialog(
                      title: const Text('Agregar Detalle'),
                      content: SingleChildScrollView(
                        child: Text("No tienes saldo saldo disponible"),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: const Text('Aceptar'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ],
                    );
                  }
                },
              );
            }
          },
          backgroundColor: Pallete.primary,
          child: const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ));
  }
}

class Detail extends StatefulWidget {
  final int idDetail;
  final VoidCallback onPresed;
  Detail({Key? key, required this.idDetail, required this.onPresed})
      : super(key: key);

  @override
  _DetailState createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  final TransaccionService service = TransaccionService();
  late String tipo = "Tipo";
  late int idDetail;
  late dynamic detail = {};
  late dynamic expenses = {};
  late num disponible = 0;
  late VoidCallback onPresed;
  bool _isLoading = true;


  init() async {
    final detalle = await service.getDetailbyId(context, idDetail);
    final response =
        await service.getTypeofExpensebyId(context, detalle["idTipo"]);
    final gastos = await service.getAllExpensesbyDetail(
        context, detalle["idPresupuestoDetalle"]);
    if (mounted && response != null) {
      setState(() {
        num sum = 0;
        detail = detalle;
        tipo = response["tipo"];
        expenses = gastos;
        for (int i = 0; i < expenses.length; i++) {
          sum += expenses[i]["monto"];
        }
        disponible = detail["monto"] - sum;
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    idDetail = widget.idDetail;
    init();
    onPresed = widget.onPresed;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          if(!_isLoading){
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Opciones'),
                content: const Text('Selecciona una opción'),
                actions: <Widget>[
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: TextStyle(
                        fontSize: 11, // Aquí puedes ajustar el tamaño del texto
                      ),
                      minimumSize: Size(20,
                          20), // Cambia el tamaño del botón aquí (ancho x alto)
                      // O puedes usar padding para ajustar el tamaño interno del botón
                      // padding: EdgeInsets.all(16), // Esto ajustará el tamaño interno del botón
                    ),
                    child: const Text('Eliminar'),
                    onPressed: () async {
                      final response = await service.deleteDetail(context,
                          idDetail); // Llama al método onDelete para eliminar este recuadro
                      if (response == true) {
                        Navigator.of(context).pop();
                        onPresed();
                      }
                    },
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: TextStyle(
                        fontSize: 11, // Aquí puedes ajustar el tamaño del texto
                      ),
                      minimumSize: Size(20,
                          20), // Cambia el tamaño del botón aquí (ancho x alto)
                      // O puedes usar padding para ajustar el tamaño interno del botón
                      // padding: EdgeInsets.all(16), // Esto ajustará el tamaño interno del botón
                    ),
                    child: const Text('Cancelar'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: TextStyle(
                        fontSize: 10,
                      ),
                      minimumSize: Size(20, 20),
                    ),
                    child: const Text('Agregar \nNotificación'),
                    onPressed: () async {
                      Map<String, dynamic> statusNotify = {
                        "descripcion": "Descripción de la notificación",
                        "umbral":
                            50, // Ejemplo de umbral de notificación (puede ser un número)
                        // Otros campos necesarios para la notificación
                      };
                      // bool notificationSaved = await service.saveNotification(
                      //     context, statusNotify, idDetail);
                      // if (notificationSaved) {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          String descripcion = '';
                          int? porcentaje; // Cambio a tipo int nullable

                          return AlertDialog(
                            title: const Text('Agregar Notificación'),
                            content: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
                                    decoration: const InputDecoration(
                                      labelText: 'Descripción',
                                    ),
                                    onChanged: (value) {
                                      descripcion = value;
                                    },
                                  ),
                                  TextField(
                                    decoration: const InputDecoration(
                                      labelText:
                                          'Porcentaje del monto al que deseas que se notifique',
                                      labelStyle: TextStyle(fontSize: 11),
                                    ),
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter
                                          .digitsOnly, // Solo números
                                      FilteringTextInputFormatter.allow(RegExp(
                                          r'^[1-9]?[0-9]?$|^100$')), // Rango de 1 a 100
                                    ],
                                    onChanged: (value) {
                                      if (value.isNotEmpty) {
                                        porcentaje = int.parse(value);
                                      } else {
                                        porcentaje = null;
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                            actions: <Widget>[
                              TextButton(
                                child: const Text('Cancelar'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: const Text('Aceptar'),
                                onPressed: () async {
                                  if (descripcion.isNotEmpty &&
                                      porcentaje != null) {
                                    bool notificationSaved =
                                        await service.saveNotification(
                                            context, statusNotify, idDetail);
                                    if (notificationSaved) {
                                      // Realizar acciones con los valores válidos
                                      // print('Descripción: $descripcion');
                                      // print('Porcentaje del monto: $porcentaje');
                                      var statusNotify = {
                                        "descripcion": descripcion,
                                        "idDetalle": idDetail,
                                        "umbral": porcentaje
                                      };
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return AlertDialog(
                                            title: const Text('Éxito'),
                                            content: const Text(
                                                'La notificación se ha agregado correctamente.'),
                                            actions: <Widget>[
                                              TextButton(
                                                child: const Text('Aceptar'),
                                                onPressed: () {
                                                  Navigator.of(context).pop();
                                                  Navigator.of(context).pop();
                                                  Navigator.of(context)
                                                      .pop(); // Para cerrar el diálogo anterior si es necesario
                                                },
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    } else {
                                    }
                                    // Aquí puedes realizar más acciones si es necesario
                                  } else {
                                    // Mostrar mensaje de error
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return AlertDialog(
                                          title: const Text('Error'),
                                          content: const Text(
                                              'Por favor, completa la información correctamente.'),
                                          actions: <Widget>[
                                            TextButton(
                                              child: const Text('Aceptar'),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  }
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                  )
                ],
              );
            },
          );
          }
        },
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white, // Cambiar el color del ListTile a blanco
              borderRadius: BorderRadius.circular(10.0),
              boxShadow: [
                BoxShadow(
                  color: _isLoading? Colors.black : disponible == 0
                      ? Colors.red
                      : Colors.green, // Cambiar el color de la sombra
                  offset: Offset(0, 2),
                  blurRadius: 4,
                ),
              ],
            ),
            child: Column(
              children: _isLoading
                  ? [Center(child: CircularProgressIndicator())]: <Widget>[
                ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 10.0),
                    //contentPadding: EdgeInsets.symmetric(vertical: 20.0),
                    title: Text(
                      '${tipo}',
                      style: const TextStyle(
                          fontSize: 18,
                          color: Colors
                              .black), // Cambiar el color del texto a negro
                      textAlign: TextAlign.center, // Centrar el texto
                    ),
                    subtitle: Text(
                      'Asignado: \$${(detail["monto"] ?? 0).toStringAsFixed(2)}\nDisponible: \$${disponible.toStringAsFixed(2)}',
                      style: const TextStyle(
                          fontSize: 18,
                          color: Colors
                              .black), // Cambiar el color del texto a negro
                      textAlign: TextAlign.center, // Centrar el texto
                    )),
              ],
            ),
          ),
        ));
  }
}
