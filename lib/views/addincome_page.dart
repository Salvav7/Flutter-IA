import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:spendify/pallete.dart';
import 'package:spendify/services/transaccionService.dart';
import 'package:spendify/views/home_page.dart';
import 'package:spendify/widgets/buttons/button.dart';

class AddIncomePage extends StatefulWidget {
  const AddIncomePage({Key? key}) : super(key: key);

  @override
  _AddIncomePageState createState() => _AddIncomePageState();
}

class _AddIncomePageState extends State<AddIncomePage> {
  final TransaccionService service = TransaccionService();

  late List<String> categorias = [];
  late List<int> ids = [];
  bool _isLoading = true;

  init() async {
    final categorias = await service.getTypesIncomes(context);
    if (mounted && categorias != null) {
      setState(() {
        for (int i = 0; i < categorias.length; i++) {
          this.categorias.add(categorias[i]["tipo"]);
          ids.add(categorias[i]["idTipoIngreso"]);
        }
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  String selectedCategoria = '';
  int idTipo = 0;
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  DateTime? _startDate;
  
  DateFormat dateFormat = DateFormat('dd/MM/yyyy');

  String _formatDate(DateTime? date) {
    if (date != null) {
      return dateFormat.format(date);
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Pallete.primary,
        title: const Text(
          "Añadir ingreso",
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:_isLoading == true
                ? [Center(child: CircularProgressIndicator())]: [
              const Text(
                'Ingrese la cantidad:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _amountController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      maxLines: 1,
                      decoration: const InputDecoration(
                        border: UnderlineInputBorder(),
                      ),
                    ),
                  ),
                  const Text('MX'),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Seleccione una categoría:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                height: 100,
                width: double.infinity,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: categorias
                      .map(
                        (categoria) => GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedCategoria = categoria;
                              idTipo = ids[categorias.indexOf(categoria)] ?? 0;
                            });
                          },
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Column(
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: selectedCategoria == categoria
                                          ? Pallete.primary
                                          : Colors.transparent,
                                      width: 2,
                                    ),
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.category,
                                      size: 30,
                                      color: selectedCategoria == categoria
                                          ? Pallete.primary
                                          : Colors.grey,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  categoria,
                                  style: TextStyle(
                                    fontWeight: selectedCategoria == categoria
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Seleccione la fecha:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
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
                      _startDateController.text = _formatDate(_startDate);
                    });
                  }
                },
              ),
              const SizedBox(height: 20),
              const Text(
                'Ingrese una descripción:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  hintText: 'Descripción',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: Button(
                  label: 'Añadir',
                  onPressed: () async {
                    // Validar que hay algo en los campos
                    if (_amountController.text.trim().isEmpty ||
                        _descriptionController.text.trim().isEmpty ||
                        _startDateController.text.trim().isEmpty ||
                        selectedCategoria.isEmpty) {
                      SnackBar snackBar = const SnackBar(
                        content: Text('Por favor llene todos los campos'),
                        backgroundColor: Colors.red,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      return;
                    }else{
                      // Crear el mapa de datos del ingreso
                    Map<String, dynamic> incomeData = {
                        "descripcion": _descriptionController.text.trim(),
                        "fecha": _startDateController.text.trim(),
                        "idTipo": idTipo,
                        "id_usuario": 1,
                        "monto": double.parse(_amountController.text.trim())
                    };

                    // Llamar a la función saveIncome
                    final response= await service.saveIncome(context, incomeData);
                    if (response == true){
                      SnackBar snackBar = const SnackBar(
                        content: Text('Ingreso guardado'),
                        backgroundColor: Colors.green,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      _amountController.clear();
                      _descriptionController.clear();
                      _startDateController.clear();
                      setState(() {
                        selectedCategoria = '';
                        idTipo = 0;
                      });
                    } else{
                      SnackBar snackBar = const SnackBar(
                        content: Text('Error al guardar el ingreso'),
                        backgroundColor: Colors.red,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                    }
                    }
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
