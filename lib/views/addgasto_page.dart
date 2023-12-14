import 'dart:developer';
import 'package:spendify/services/transaccionService.dart';
import 'package:flutter/material.dart';
import 'package:form_field_validator/form_field_validator.dart';
import 'package:intl/intl.dart';
import 'package:spendify/pallete.dart';
import 'package:spendify/views/budget_page.dart';
import 'package:spendify/views/budgetdetail_page.dart';
import 'package:spendify/views/home_page.dart';
import 'package:spendify/widgets/buttons/button.dart';

class AddGastoPage extends StatefulWidget {
  AddGastoPage({Key? key}) : super(key: key);
  final Map<String, IconData> categoriaIconos = {
    'Comida': Icons.fastfood,
    'Transporte': Icons.directions_car,
    'Servicios(gas, agua, etc)': Icons.settings,
    'Entretenimiento': Icons.movie,
    'Salud': Icons.local_hospital,
    'Educacion': Icons.school,
    'Cuidado personal': Icons.face,
    'Ropa': Icons.shopping_bag,
    'Hogar': Icons.home,
  };

  @override
  _AddGastoPageState createState() => _AddGastoPageState();
}

class _AddGastoPageState extends State<AddGastoPage> {
  final List<String> categorias = [
    'Comida',
    'Transporte',
    'Servicios',
    'Salud',
    'Entretenimiento',
    'Educación',
    'Cuidado Personal',
    'Ropa',
    'Hogar',
  ];

  //una lista de tipo string
  late List<BudgetItem> presupuestos = [];
  late int id = 0;
  late int idCategorie = 0;
  late List<String> list = [""];
  List<int> idCategories = [0];
  String dropdownValue = "";
  List<dynamic> listCategories = [];
  List<String> nameCategories = ["Selecciona un presupuesto"];
  List<int> idListDetail = [0];
  late int idDetail = 0;
  bool _isLoading = true;
  bool _categorieIsLoading = false;

  // Mapa que asocia cada categoría con su respectivo icono
  TransaccionService service = TransaccionService();

  init() async {
    var data = await service.getAllBudgets(context);
    if (mounted && data != null) {
      list.clear();
      setState(() {
        for (int i = 0; i < data.length; i++) {
          var item = BudgetItem(
            id: data[i]["idPresupuesto"],
            amount: data[i]["montoTotal"],
            startDate: data[i]["fechaInicio"],
            endDate: data[i]["fechaFin"],
            details: data[i]["detalles"],
          );
          presupuestos.add(item);
          list.add(
              "Presupuesto ${i + 1}: ${data[i]["fechaInicio"]}-${data[i]["fechaFin"]}");
        }
        _isLoading=false;
      });

    }
    
  }

  @override
  void initState() {
    init();
    super.initState();
  }

  String selectedCategoria = '';
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  String? _selectedBudget;
  final List<String> _budgets = [
    'Presupuesto 1',
    'Presupuesto 2',
    'Presupuesto 3'
  ];
  DateTime? _startDate;
  DateTime? _endDate;
  DateFormat dateFormat = DateFormat('dd/MM/yyyy');

  String _formatDate(DateTime? date) {
    if (date != null) {
      return dateFormat.format(date);
    }
    return '';
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Pallete.primary,
        title: const Text(
          "Añadir gasto",
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
            children: _isLoading == true
                ? [Center(child: CircularProgressIndicator())]:list.length == 0
                ? [
                    Center(
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BudgetPage(),
                              ),
                            );
                          },
                          child: const Text(
                            'Agrega presupuesto',
                            style: TextStyle(
                              fontSize: 16.0,
                              color: Pallete.primary,
                              decoration: TextDecoration.underline,
                              decorationColor: Pallete.primary,
                            ),
                          ),
                        ),
                      ),
                    )
                  ]
                : [
                    const SizedBox(height: 20),
                    const Text(
                      'Seleccione un presupuesto:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    // DropdownButtonFormField para seleccionar presupuesto

                    DropdownMenu<String>(
                      width: 320,
                      initialSelection: list.first,
                      onSelected: (String? value) async {
                        // This is called when the user selects an item.
                        setState(() {
                          dropdownValue = value!;
                          id = list.indexOf(dropdownValue);
                          _categorieIsLoading=true;
                        });
                        var budget = presupuestos.elementAt(id);
                        final detail = await service.getDetailsbyBudget(
                            context, budget.id);
                        setState(() {
                          idCategories.clear();
                          idListDetail.clear();
                          
                          for (int i = 0; i < detail.length; i++) {
                            idCategories.add(detail[i]["idTipo"]);
                            idListDetail.add(detail[i]["idPresupuestoDetalle"]);
                          }
                          //print(idDetail);
                          //print(categorias);
                          
                        });

                        var allCategories = [];
                        List<String> allNameCategories = [];
                        for (int i = 0; i < detail.length; i++) {
                          var categorie = await service.getTypeofExpensebyId(
                              context, idCategories.elementAt(i));
                          allCategories.add(categorie);
                          allNameCategories.add(categorie["tipo"]);
                        }
                        setState(() {
                          listCategories = allCategories;
                          nameCategories = allNameCategories;
                          _categorieIsLoading=false;
                        });
                      },
                      dropdownMenuEntries:
                          list.map<DropdownMenuEntry<String>>((String value) {
                        return DropdownMenuEntry<String>(
                            value: value, label: value);
                      }).toList(),
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
                      child:_categorieIsLoading
                              ? Center(child: CircularProgressIndicator()): nameCategories.isEmpty
                          ? Center(
                              child: MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: GestureDetector(
                                  onTap: () {
                                    var budget = presupuestos.elementAt(id);
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => BudgetDetailPage(
                                            idPresupuesto: budget.id,
                                            fechaInicio: budget.startDate,
                                            fechaFin: budget.endDate,
                                            montoTotal: budget.amount,
                                            option: 2,),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    'No hay categorías disponibles. Haz clic para ir a la página de detalles del presupuesto.',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : ListView(
                              scrollDirection: Axis.horizontal,
                              children: nameCategories
                                  .map(
                                    (categoria) => GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedCategoria = categoria;
                                          idCategorie = idCategories[
                                                  nameCategories
                                                      .indexOf(categoria)] ??
                                              0;
                                          idDetail = idListDetail[nameCategories
                                                  .indexOf(categoria)] ??
                                              0;
                                        });
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Column(
                                          children: [
                                            Container(
                                              width: 60,
                                              height: 60,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                  color: selectedCategoria ==
                                                          categoria
                                                      ? Pallete.primary
                                                      : Colors.transparent,
                                                  width: 2,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                              ),
                                              child: Center(
                                                child: Icon(
                                                  AddGastoPage()
                                                          .categoriaIconos[
                                                      categoria],
                                                  size: 30,
                                                  color: selectedCategoria ==
                                                          categoria
                                                      ? Pallete.primary
                                                      : Colors.grey,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              categoria,
                                              style: TextStyle(
                                                fontWeight: selectedCategoria ==
                                                        categoria
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
                      child: ElevatedButton(
                        onPressed: () async {
                          if (_amountController.text.trim().isEmpty ||
                              _descriptionController.text.trim().isEmpty ||
                              _startDateController.text.trim().isEmpty ||
                              selectedCategoria.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Por favor, llene todos los campos'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }else{                          
                          var budget = presupuestos.elementAt(id);
                          var savGasto = {
                            "descripcion": _descriptionController.text.trim(),
                            "fecha": _startDateController.text.trim(),
                            "idDetalle": idDetail,
                            "monto": double.parse(_amountController.text.trim())
                          };
                          /////////////////////////////////////////////////////////////
                          bool success =
                              await service.saveGastos(context, savGasto);

                          if (success) {
                            // The operation was successful
                            _descriptionController.clear();
                            _startDateController.clear();
                            _amountController.clear();
                            setState(() {
                              selectedCategoria = '';
                              idCategorie = 0;
                              idDetail = 0;
                            });

                            // ignore: use_build_context_synchronously
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Operación exitosa'),
                                backgroundColor: Colors.green,
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Operacion Fallida'),
                                backgroundColor: Colors.red,
                              ),
                            );                        
                          }
                          }
                        },
                        child: const Text('Añadir'),
                      ),
                      /////////////////////////////////////////////////////
                    ),
                  ],
          ),
        ),
      ),
    );
  }
}

class BudgetItem {
  final int id;
  final double amount;
  final String startDate;
  final String endDate;
  final details;

  const BudgetItem({
    required this.id,
    required this.amount,
    required this.startDate,
    required this.endDate,
    required this.details,
  });
}
