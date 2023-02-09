import 'package:flutter/material.dart';

class TextFormfield extends StatelessWidget {
  TextFormfield({Key? key, required this.controller, required this.string,required this.Validator})
      : super(key: key);

  TextEditingController controller;
  final Function Validator;
  String string;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (val) {
        return Validator(val);
      },

      // onSaved: (val){
      //   controller.text = val as String ;
      // },
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
          labelText: string,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: BorderSide(color: Colors.blueAccent),
          ),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
              borderSide: const BorderSide(
                color: Colors.blueAccent,
              ))),
    );
  }
}
