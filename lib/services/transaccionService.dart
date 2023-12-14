import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spendify/services/generalService.dart';
import 'package:http/http.dart' as http;

class TransaccionService {
  final GeneralService gs = GeneralService();

  getSumofIncomes(BuildContext context) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.get("token");
    var user = await http.get(Uri.https(gs.baseUrl, "incomes/"), headers: {
      "Authorization": "Bearer $token",
    });
    if (user.statusCode == 200) {
      final user2 = json.decode(user.body);
      return user2;
    } else {
      gs.gestorErrores(context, user, 2);
    }
  }

  getSumofExpenses(BuildContext context) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.get("token");
    var user = await http.get(Uri.https(gs.baseUrl, "expenses/"), headers: {
      "Authorization": "Bearer $token",
    });
    if (user.statusCode == 200) {
      final user2 = json.decode(user.body);
      return user2;
    } else {
      gs.gestorErrores(context, user, 2);
    }
  }

  getTypesIncomes(BuildContext context) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.get("token");
    var types = await http.get(Uri.https(gs.baseUrl, "tipoIngresos"), headers: {
      "Authorization": "Bearer $token",
    });
    if (types.statusCode == 200) {
      final types2 = json.decode(types.body);
      return types2;
    } else {
      gs.gestorErrores(context, types, 2);
    }
  }

  getTypesExpenses(BuildContext context) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.get("token");
    var types = await http.get(Uri.https(gs.baseUrl, "tipoGastos"), headers: {
      "Authorization": "Bearer $token",
    });
    if (types.statusCode == 200) {
      final types2 = json.decode(types.body);
      return types2;
    } else {
      gs.gestorErrores(context, types, 2);
    }
  }

  Future<bool> saveIncome(BuildContext context, Map<String, dynamic> incomeData) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.get("token");
    final response = await http.post(
      Uri.https(gs.baseUrl, "incomes/saveIncome"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: json.encode(incomeData),  
    );
    if (response.statusCode == 201) {
      // Handle the successful response here, for example:
      // Show a success message or update the UI
      return true;
    } else {
      gs.gestorErrores(context, response, 2);
      return false;
    }
}

Future<bool> saveGastos(BuildContext context, Map<String, dynamic> expenseData) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.get("token");
    final response = await http.post(
      Uri.https(gs.baseUrl, "expenses/addExpense"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: json.encode(expenseData),
    );
    if (response.statusCode == 201) {
      // Handle the successful response here, for example:
      // Show a success message or update the UI
      return true;
    } else {
      gs.gestorErrores(context, response, 2);
      return false;
    }
        }


  getAllIncomes(BuildContext context) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.get("token");
    final incomes = await http
        .get(Uri.https(gs.baseUrl, "incomes/allIncomesByUser"), headers: {
      "Authorization": "Bearer $token",
    });
    if (incomes.statusCode == 200) {
      final incomes2 = json.decode(incomes.body);
      return incomes2;
    } else {
      gs.gestorErrores(context, incomes, 2);
    }
  }

  getAllExpenses(BuildContext context) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.get("token");
    final expenses = await http
        .get(Uri.https(gs.baseUrl, "expenses/getAllExpensesByUser"), headers: {
      "Authorization": "Bearer $token",
    });
    if (expenses.statusCode == 200) {
      final expenses2 = json.decode(expenses.body);
      return expenses2;
    } else {
      gs.gestorErrores(context, expenses, 2);
    }
  }

  getAllBudgets(BuildContext context) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.get("token");
    final budges = await http
        .get(Uri.https(gs.baseUrl, "budgets/getAllBudgesByUser"), headers: {
      "Authorization": "Bearer $token",
    });
    if (budges.statusCode == 200) {
      final budges2 = json.decode(budges.body);
      return budges2;
    } else {
      gs.gestorErrores(context, budges, 2);
    }
  }

  saveNewBudget(BuildContext context, String fechaInicio, String fechaFin,
      double monto) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.get("token");
    final response = await http.post(
        Uri.https(gs.baseUrl, "budgets/saveBudget"),
        body: json.encode({
          "detalles": [],
          "fechaFin": fechaFin,
          "fechaInicio": fechaInicio,
          "idUsuario": 1,
          "montoTotal": monto
        }),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        });
    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      gs.gestorErrores(context, response, 2);
    }
  }

  saveNewDetail(BuildContext context, int id, int tipo, num monto) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.get("token");
    final response = await http.post(
        Uri.https(gs.baseUrl, "budgetDetails/addDetail/${id}"),
        body: json.encode({"idTipo": tipo, "monto": monto}),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        });
    if (response.statusCode == 201) {
      return json.decode(response.body);
    } else {
      gs.gestorErrores(context, response, 2);
    }
  }

  deleteBudget(BuildContext context, int id) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.get("token");
    final response = await http.delete(
        Uri.https(gs.baseUrl, "budgets/deleteBudget/${id}"),
        headers: {"Authorization": "Bearer $token"});
    if (response.statusCode == 204) {
      return true;
    } else {
      gs.gestorErrores(context, response, 2);
      return false;
    }
  }

  getDetailsbyBudget(BuildContext context, int id) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.get("token");
    final response = await http.get(
        Uri.https(gs.baseUrl, "budgetDetails/getDetailsByBudget/${id}"),
        headers: {"Authorization": "Bearer $token"});
    if (response.statusCode == 200) {
      final details = json.decode(response.body);
      return details;
    } else {
      gs.gestorErrores(context, response, 2);
    }
  }

  getDetailbyId(BuildContext context, int id) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.get("token");
    final response = await http.get(
        Uri.https(gs.baseUrl, "budgetDetails/getDetail/${id}"),
        headers: {"Authorization": "Bearer $token"});
    if (response.statusCode == 200) {
      final detail = json.decode(response.body);
      return detail;
    } else {
      gs.gestorErrores(context, response, 2);
    }
  }

  getAllExpensesbyDetail(BuildContext context, int id) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.get("token");
    final response = await http.get(
        Uri.https(gs.baseUrl, "expenses/getAllExpenseByDetail/${id}"),
        headers: {"Authorization": "Bearer $token"});
    if (response.statusCode == 200) {
      final expenses = json.decode(response.body);
      return expenses;
    } else {
      gs.gestorErrores(context, response, 2);
    }
  }

  deleteDetail(BuildContext context, int id) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.get("token");
    final response = await http.delete(
        Uri.https(gs.baseUrl, "budgetDetails/deleteDetail/${id}"),
        headers: {"Authorization": "Bearer $token"});
    if (response.statusCode == 204) {
      return true;
    } else {
      gs.gestorErrores(context, response, 2);
      return false;
    }
  }

  getTypeofExpensebyId(BuildContext context, int id) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.get("token");
    final response = await http.get(Uri.https(gs.baseUrl, "tipoGastos/${id}"),
        headers: {"Authorization": "Bearer $token"});
    if (response.statusCode == 200) {
      final types = json.decode(response.body);
      return types;
    } else {
      gs.gestorErrores(context, response, 2);
    }
  }

 Future<bool> saveNotification(BuildContext context,
      Map<String, dynamic> notificationData, int id) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.get("token");
    final response = await http.post(
      Uri.https(gs.baseUrl, "notificationsByBudgetDetail/$id"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: json.encode(notificationData),
    );
    if (response.statusCode == 201) {
      // Si la notificación se guardó exitosamente, retornar true
      return true;
    } else {
      // Si hubo un error al guardar la notificación, manejar el error y retornar false
      gs.gestorErrores(context, response, 2);
      return false;
    }
  }
}
