import 'package:flutter/material.dart';
import 'package:spendify/pallete.dart';

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Pallete.primary,
        title: const Text(
          "Términos y Condiciones",
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
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSection(
                'Términos y Condiciones de la Aplicación de Gestión Financiera',
                '''
Introducción

Bienvenido a SpendiFy, la aplicación móvil de gestión financiera. Antes de utilizar nuestra aplicación, te pedimos que leas y aceptes estos Términos y Condiciones. Al hacer uso de la aplicación, aceptas regirte por estos términos y cumplir con todas las leyes y regulaciones aplicables.

1. Registro y Cuenta de Usuario

1.1. Para utilizar SpendiFy, debes registrarte y crear una cuenta de usuario.

1.2. Debes proporcionar información precisa y completa durante el proceso de registro.

1.3. Eres responsable de mantener la confidencialidad de tus credenciales de inicio de sesión y de cualquier actividad que ocurra en tu cuenta.

2. Privacidad y Seguridad

2.1. SpendiFy recopilará y procesará datos personales de acuerdo con nuestra Política de Privacidad. Al utilizar la aplicación, aceptas los términos de esta política.

2.2. Debes tomar medidas para proteger la seguridad de tu cuenta y notificarnos de inmediato si sospechas de un acceso no autorizado.

3. Uso de la Aplicación

3.1. SpendiFy está diseñada para ayudarte a llevar un registro de tus finanzas personales. No garantizamos resultados financieros específicos y no somos responsables de tus decisiones financieras.

3.2. Toda la información proporcionada en la aplicación es solo con fines informativos. No sustituye el asesoramiento financiero profesional.

4. Datos y Propiedad Intelectual

4.1. Mantienes la propiedad de todos los datos e información que ingreses en la aplicación.

4.2. SpendiFy retiene los derechos de propiedad intelectual sobre la aplicación y su contenido.

5. Cambios y Actualizaciones

5.1. SpendiFy se reserva el derecho de realizar cambios y actualizaciones en la aplicación en cualquier momento.

6. Cancelación y Terminación

6.1. Puedes cancelar tu cuenta en cualquier momento.

6.2. SpendiFy se reserva el derecho de suspender o terminar tu cuenta si violas estos Términos y Condiciones.

7. Responsabilidad y Exoneración de Responsabilidad

7.1. SpendiFy no es responsable de pérdidas financieras, daños o perjuicios derivados del uso de la aplicación.

8. Ley Aplicable

8.1. Estos Términos y Condiciones se rigen por las leyes de los Estados Unidos Mexicanos.

9. Contacto

9.1. Si tienes alguna pregunta o inquietud sobre estos Términos y Condiciones, puedes ponerte en contacto con nosotros a través de su support@spendify-app.com.
                ''',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8.0),
          Text(content),
        ],
      ),
    );
  }
}
