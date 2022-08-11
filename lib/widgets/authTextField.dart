import 'package:flutter/material.dart';

class AuthTextField extends StatelessWidget {
  const AuthTextField({
    Key? key,
    required this.controller,
    required this.onSaved,
    required this.hintText,
    required this.validationText,
    required this.parameter,
    required this.label,
  }) : super(key: key);

  final String hintText;
  final String validationText;
  final String parameter;
  final TextEditingController controller;
  final Function onSaved;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: TextFormField(
        onSaved: (val) => onSaved(val, parameter),
        validator: (value) {
          switch (label) {
            case 'כתובת מייל':
              if (value!.isEmpty || !value.contains('@')) {
                return validationText;
              }
              break;
            case 'סיסמא':
              if (value!.isEmpty) {
                return validationText;
              }
          }
          return null;
        },
        controller: controller,
        keyboardType: label.contains('כתובת מייל')
            ? TextInputType.emailAddress
            : TextInputType.visiblePassword,
        autofocus: label.contains('כתובת מייל') ? true : false,
        decoration: InputDecoration(
          hintTextDirection: TextDirection.rtl,
          label: Text(
            label,
          ),
          border:OutlineInputBorder(
            borderRadius:
            BorderRadius.all(Radius.circular(7.0)),
          ),
          hintText: hintText,
          hintStyle: TextStyle(
            color: Colors.grey[400],
            fontSize: 16,
            fontFamily: 'Assistant',
          ),
          errorStyle: const TextStyle(
              color: Colors.red, fontSize: 12, fontFamily: 'Assistant'),
        ),
        textInputAction: label.contains('סיסמא')
            ? TextInputAction.done
            : TextInputAction.next,
        obscureText: label.contains('סיסמא') ? true : false,
        style: const TextStyle(
          fontFamily: 'NunitoSans',
          fontSize: 16,
          color: Colors.black,
        ),
      ),
    );
  }
}
