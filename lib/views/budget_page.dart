import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:spendify/pallete.dart';
import 'package:spendify/services/transaccionService.dart';
import 'package:spendify/views/budgetdetail_page.dart';

class BudgetPage extends StatefulWidget {
  const BudgetPage({Key? key}) : super(key: key);

  @override
  _BudgetPageState createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  List<BudgetItem> _recuadros = [];

  DateTime? _startDate;
  DateTime? _endDate;
  TextEditingController _amountController = TextEditingController();
  TextEditingController _startDateController = TextEditingController();
  TextEditingController _endDateController = TextEditingController();
  TransaccionService service = TransaccionService();
  bool _isLoading = false;

  DateFormat dateFormat = DateFormat('dd/MM/yyyy');

  Future<void> _refreshData() async {
  setState(() {
    _isLoading = true;
  });
  await init(); // Vuelve a cargar los datos
  setState(() {
    _isLoading = false;
  });
}

  init() async {
    var data = await service.getAllBudgets(context);
    if (mounted && data != null) {
      setState(() {
        _isLoading = false;
        for (int i = 0; i < data.length; i++) {
          var item = BudgetItem(
            id: data[i]["idPresupuesto"],
            amount: data[i]["montoTotal"],
            startDate: data[i]["fechaInicio"],
            endDate: data[i]["fechaFin"],
            details: data[i]["detalles"],
            onDelete: () {
              _removeRecuadro(data[i]["idPresupuesto"]);
            },
          );
          _recuadros.add(item);
        }
      });
    }
  }

  @override
  void initState() {
    _isLoading = true;
    super.initState();
    _startDateController = TextEditingController();
    _endDateController = TextEditingController();
    init();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime? date) {
    if (date != null) {
      return dateFormat.format(date);
    }
    return '';
  }

  void _removeRecuadro(int id) async {
    final response = await service.deleteBudget(context, id);
    if (response == true) {
      setState(() {
        _recuadros.removeWhere((element) => element.id == id);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Pallete.primary,
        title: const Text(
          "Presupuesto",
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
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: _recuadros.length > 0
                              ? _recuadros
                              : [
                                  const Center(
                                      child: Text(
                                    "Sin presupuestos registrados",
                                    textAlign: TextAlign.center,
                                  ))
                                ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Agregar Presupuesto'),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        decoration: const InputDecoration(
                          labelText: 'Fecha de inicio',
                        ),
                        readOnly: true,
                        controller: _startDateController,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              _startDate = pickedDate;
                              _startDateController.text =
                                  _formatDate(_startDate);
                              _endDate =
                                  _startDate?.add(const Duration(days: 30));
                              _endDateController.text = _formatDate(_endDate);
                            });
                          }
                        },
                      ),
                      TextField(
                        decoration: const InputDecoration(
                          labelText: 'Fecha de fin',
                        ),
                        readOnly: true,
                        controller: _endDateController,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.parse(_startDate.toString())
                                .add(const Duration(days: 30)),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              _endDate = pickedDate;
                              _endDateController.text = _formatDate(_endDate);
                            });
                          }
                        },
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
                    child: const Text('Agregar'),
                    onPressed: () async {
                      if (_startDate != null &&
                          _endDate != null &&
                          _amountController.text.isNotEmpty) {
                        if (_startDate!.isAfter(_endDate!)) {
                          String errorMessage =
                              'La fecha de inicio no puede ser después de la fecha de fin';
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
                          final data = await service.saveNewBudget(
                              context,
                              _startDateController.text,
                              _endDateController.text,
                              double.parse(_amountController.text));
                          if (data != null) {
                            setState(() {
                              _recuadros.add(
                                BudgetItem(
                                  id: data["idPresupuesto"],
                                  amount: data["montoTotal"],
                                  startDate: data["fechaInicio"],
                                  endDate: data["fechaFin"],
                                  details: data["detalles"],
                                  onDelete: () {
                                    _removeRecuadro(data["idPresupuesto"]);
                                  },
                                ),
                              );
                              _startDate = null;
                              _endDate = null;
                              _amountController.clear();
                              _startDateController.clear();
                              _endDateController.clear();
                            });
                            Navigator.of(context).pop();
                          }
                        }
                      } else {
                        String errorMessage =
                            'Por favor completa todos los campos';
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
                      }
                    },
                  ),
                ],
              );
            },
          );
        },
        backgroundColor: Pallete.primary,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}

class BudgetItem extends StatelessWidget {
  final int id;
  final double amount;
  final String startDate;
  final String endDate;
  final details;
  final VoidCallback onDelete;

  const BudgetItem({
    required this.id,
    required this.amount,
    required this.startDate,
    required this.endDate,
    required this.details,
    required this.onDelete,
  });

  disponible() {
    num suma = 0;
    for (int i = 0; i < details.length; i++) {
      suma += details[i]["monto"];
    }
    return amount - suma;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
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
                      fontSize: 12, // Aquí puedes ajustar el tamaño del texto
                    ),
                    minimumSize: Size(20,
                        20), // Cambia el tamaño del botón aquí (ancho x alto)
                    // O puedes usar padding para ajustar el tamaño interno del botón
                    // padding: EdgeInsets.all(16), // Esto ajustará el tamaño interno del botón
                  ),
                  child: const Text('Eliminar'),
                  onPressed: () async {
                    onDelete(); // Llama al método onDelete para eliminar este recuadro
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: TextStyle(
                      fontSize: 12, // Aquí puedes ajustar el tamaño del texto
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
                      fontSize: 12, // Aquí puedes ajustar el tamaño del texto
                    ),
                    minimumSize: Size(20,
                        20), // Cambia el tamaño del botón aquí (ancho x alto)
                    // O puedes usar padding para ajustar el tamaño interno del botón
                    // padding: EdgeInsets.all(16), // Esto ajustará el tamaño interno del botón
                  ),
                  child: const Text('Detalles'),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BudgetDetailPage(
                          idPresupuesto: id,
                          fechaInicio: startDate,
                          fechaFin: endDate,
                          montoTotal: amount,
                          option: 1,
                        ),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        );
      },
      child: Container(
        width: double.infinity,
        height: 110,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 255, 255, 255),
          boxShadow: [
            BoxShadow(
              color: disponible() == 0 ? Colors.red : Colors.green,
              offset: Offset(0, 2),
              blurRadius: 4,
            ),
          ],
        ),
        margin: const EdgeInsets.only(bottom: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  // child: Text('Monto: $amount'),
                  child: Text('Monto: \$' '${amount.toStringAsFixed(2)}'),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('Del $startDate \n  al $endDate'),
                ),
              ],
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                // child: Text('Saldo sin asignar: \$' + disponible().toString()),
                child: Text(
                    'Saldo sin asignar: \$' + disponible().toStringAsFixed(2)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
