import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:spendify/services/generalService.dart';

class PerfilService {
  final GeneralService gs = GeneralService();

  // Obtener información del usuario
  getUser(BuildContext context) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.get("token");
    var user = await http.get(Uri.https(gs.baseUrl, "users/myInfo"), headers: {
      "Authorization": "Bearer $token",
    });
    if (user.statusCode == 200) {
      final user2 = json.decode(user.body);
      return user2;
    } else {
      gs.gestorErrores(context, user, 2);
    }
  }

  // Eliminar cuenta de usuario
  Future<bool> deleteAccount(BuildContext context) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.get("token");
    var response = await http
        .delete(Uri.https(gs.baseUrl, "users/deleteAccount"), headers: {
      "Authorization": "Bearer $token",
    });
    if (response.statusCode == 204) {
      sharedPreferences.remove("token");
      return true;
    } else {
      gs.gestorErrores(context, response, 2);
      return false;
    }
  }

  // Cerrar sesión
  logout() async {
    await gs.logout();
  }

  // Cambiar correo electrónico
  Future<bool> updateEmail(BuildContext context, String email) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.get("token");

    // Obtén los datos actuales del usuario
    var userDataResponse = await http.get(
      Uri.https(gs.baseUrl, "users/myInfo"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (userDataResponse.statusCode == 200) {
      var userData = json.decode(userDataResponse.body);

      // Prepara los datos para la actualización
      var updatedUserData = {
        "email": email,
        "nombre": userData['nombre'],
        "apellidoPaterno": userData['apellidoPaterno'],
        "apellidoMaterno": userData['apellidoMaterno'],
        "edad": userData['edad'], // Mantén la edad actual
        "id": userData['id'], // Mantén el ID actual
        "telefono": userData['telefono'] // Mantén el teléfono actual
      };

      // Envía la solicitud de actualización
      var response = await http.put(
        Uri.https(gs.baseUrl, "users/updateAccount"),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
        body: json.encode(updatedUserData),
      );

      if (response.statusCode == 204) {
        return true;
      } else {
        gs.gestorErrores(context, response, 2);
        return false;
      }
      } else {
      gs.gestorErrores(context, userDataResponse, 2);
      return false;
    }
  }

  // Cambiar contraseña
Future<bool> changePassword(
    BuildContext context, String oldPasswaord, String newPassword) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  var token = sharedPreferences.get("token");

  var response = await http.put(
    Uri.https(gs.baseUrl, "users/changePassword"),
    headers: {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json"
    },
    body: json.encode({
      "oldPasswaord": oldPasswaord,
      "newPassword": newPassword,
    }),
  );

  if (response.statusCode == 204) {
    return true;
  } else {
    gs.gestorErrores(context, response, 2);
    return false;
  }
}




  // Cambiar nombre de usuario
  Future<bool> updateAccount(BuildContext context, String nombre, String apellidoPaterno, String apellidoMaterno) async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  var token = sharedPreferences.get("token");
  
  // Obtén los datos actuales del usuario
  var userDataResponse = await http.get(
    Uri.https(gs.baseUrl, "users/myInfo"),
    headers: {"Authorization": "Bearer $token"},
  );

  if (userDataResponse.statusCode == 200) {
    var userData = json.decode(userDataResponse.body);

    // Prepara los datos para la actualización
    var updatedUserData = {
      "nombre": nombre,
      "apellidoPaterno": apellidoPaterno,
      "apellidoMaterno": apellidoMaterno,
      "edad": userData['edad'], // Mantén la edad actual
      "email": userData['email'], // Mantén el email actual
      "id": userData['id'], // Mantén el ID actual
      "telefono": userData['telefono'] // Mantén el teléfono actual
    };

    // Envía la solicitud de actualización
    var response = await http.put(
      Uri.https(gs.baseUrl, "users/updateAccount"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json"
      },
      body: json.encode(updatedUserData),
    );

    if (response.statusCode == 204) {
      return true;
    } else {
      gs.gestorErrores(context, response, 2);
      return false;
    }
  } else {
    gs.gestorErrores(context, userDataResponse, 2);
    return false;
  }
}
}