import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spendify/widgets/notifications/notification.dart';

class GeneralService {
  String baseUrl =
      'spendify-api-service-spendify-juandavid1217.cloud.okteto.net';

  gestorErrores(
      BuildContext context, http.Response response, int opcion) async {
    var message = "";
    if (response.statusCode >= 500) {
      message = "Error en el servidor, intentelo más tarde.";
    } else {
      switch (response.statusCode) {
        case 401:
          if (opcion == 1) {
            message = "Incorrect Email and password.";
          } else if (opcion == 2) {
            message = "Session time expired!";
            await logout();
          } else {
            message = response.body;
          }
          break;
        default:
          message = response.body;
      }
    }
    mostrarAlerta(context, 'Error', message);
  }

  logout() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.remove("token");
  }
}
