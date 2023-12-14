import 'package:flutter/material.dart';
import 'package:spendify/pallete.dart';

class TextFieldGeneric extends StatelessWidget {
  final TextEditingController textController;
  final String hintText;
  final String labelText;
  final TextInputType keyboardType;
  final bool obscureText;
  final VoidCallback? onPressed;
  final FormFieldValidator<String>? validator;

  const TextFieldGeneric({
    Key? key,
    required this.textController,
    required this.hintText,
    required this.labelText,
    required this.keyboardType,
    this.obscureText = true,
    this.onPressed,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 400,
      height: 45,
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: TextFormField(
        controller: textController,
        keyboardType: keyboardType,
        obscureText: obscureText,
        decoration: InputDecoration(
          hintText: hintText,
          labelText: labelText,
          contentPadding: const EdgeInsets.all(20),
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.horizontal(
              left: Radius.circular(30), // Radio grande para el borde izquierdo
              right: Radius.circular(30), // Radio grande para el borde derecho
            ),
            borderSide: BorderSide(
              color: Pallete.primary,
              width: 3,
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.horizontal(
              left: Radius.circular(30), // Radio grande para el borde izquierdo
              right: Radius.circular(30), // Radio grande para el borde derecho
            ),
            borderSide: BorderSide(
              color: Pallete.primary,
              width: 2,
            ),
          ),
          suffixIcon: onPressed != null
              ? IconButton(
                  icon: Icon(
                    obscureText ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: onPressed,
                )
              : null, // Mostrar el icono solo si onPressed no es nulo
        ),
        validator: validator,
      ),
    );
  }
}
