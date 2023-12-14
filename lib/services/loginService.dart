import 'dart:convert'; // Importación para el manejo de JSON.
import 'package:http/http.dart' as http; // Importación para realizar peticiones HTTP.
import 'package:shared_preferences/shared_preferences.dart'; // Importación para el almacenamiento local de preferencias.
import 'package:flutter/material.dart'; // Importación de widgets y funcionalidades de Flutter.
import 'package:spendify/services/generalService.dart'; // Importación de un servicio general con funciones comunes.

// Clase para manejar los servicios de inicio de sesión y gestión de usuarios.
class LoginService {
  final GeneralService gs = GeneralService(); // Instancia de un servicio general.

  // Función para iniciar sesión.
  Future<bool> login(BuildContext context, email, String password) async {
    // Realiza una petición HTTP POST para iniciar sesión.
    final response = await http.post(Uri.https(gs.baseUrl, "users/login"),
        body: json.encode({"email": email, "password": password}));

    // Verifica si la respuesta es exitosa (código 200).
    if (response.statusCode == 200) {
      // Decodifica la respuesta y almacena el token en SharedPreferences.
      final data = json.decode(response.body);
      SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences.setString('token', data["token"]);
      return true;
    } else {
      // Gestiona los errores en caso de una respuesta fallida.
      gs.gestorErrores(context, response, 1);
      return false;
    }
  }

  // Función para comprobar si el usuario está logueado.
  Future<bool> isLogged() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.get("token");
    // Devuelve verdadero si encuentra un token, indicando que el usuario está logueado.
    return token != null;
  }

  // Función para obtener información del usuario autenticado.
  getUser(BuildContext context) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var token = sharedPreferences.get("token");
    // Realiza una petición HTTP GET para obtener información del usuario.
    var user = await http.get(Uri.https(gs.baseUrl, "users/myInfo"),
        headers: {"Authorization": "Bearer $token"});
    if (user.statusCode == 200) {
      final user2 = json.decode(user.body);
      // Devuelve el nombre del usuario o una cadena vacía si no se encuentra.
      return user2["nombre"] ?? "";
    } else {
      // Gestiona los errores si la petición falla.
      gs.gestorErrores(context, user, 2);
    }
  }

  // Función para enviar un correo electrónico (probablemente para recuperación de contraseña).
  Future<bool> sendEmail(BuildContext context, String email) async {
    final response = await http.post(Uri.https(gs.baseUrl, "forggotPassword"),
        body: json.encode({"email": email}),
        headers: {"Content-Type": "application/json"});

    if (response.statusCode == 200) {
      return true;
    } else {
      gs.gestorErrores(context, response, 2);
      return false;
    }
  }

  // Función para validar una clave (posiblemente para recuperación de contraseña).
  Future<int> validKey(BuildContext context, String key) async {
    final response = await http.post(
        Uri.https(gs.baseUrl, "forggotPassword/verifyKey"),
        body: json.encode({"clave": key}),
        headers: {"Content-Type": "application/json"});
    if (response.statusCode == 200) {
      final id = json.decode(response.body);
      // Devuelve el ID del usuario si la clave es válida.
      return id["id_usuario"];
    } else {
      gs.gestorErrores(context, response, 3);
      return 0;
    }
  }

  // Función para cambiar la contraseña del usuario.
  Future<bool> changePassword(
      BuildContext context, int id, String password) async {
    final response = await http.put(
        Uri.https(gs.baseUrl, "users/changePasswordWithKey/${id}"),
        body: json.encode({"newPassword": password}),
        headers: {"Content-Type": "application/json"});
    if (response.statusCode == 204) {
      return true;
    } else {
      gs.gestorErrores(context, response, 2);
      return false;
    }
  }

  // Función para crear una nueva cuenta de usuario.
  Future<bool> createAccount(BuildContext context, nombre, apPaterno, apMaterno,
      edad, telefono, email, password) async {
    final response =
        await http.post(Uri.https(gs.baseUrl, "users/createAccount"),
            body: json.encode({
              "apellidoMaterno": apMaterno,
              "apellidoPaterno": apPaterno,
              "edad": edad,
              "email": email,
              "nombre": nombre,
              "password": password,
              "telefono": telefono
            }),
            headers: {"Content-Type": "application/json"});
    if (response.statusCode == 201) {
      // Retorna verdadero si la cuenta es creada exitosamente.
      return true;
    } else {
      // Gestiona los errores en caso de fallo.
      gs.gestorErrores(context, response, 2);
      return false;
    }
  }

  // Función para cerrar sesión.
  logout() async {
    // Llama a la función de logout del servicio general.
    await gs.logout();
  }
}
