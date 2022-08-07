import 'package:flutter/material.dart';

class InputDecorations{
  static InputDecoration authInputDecoration({
    required String hintText,
    required String labelText,
            IconData? prefixIcon
  }){
    return   InputDecoration(
                enabledBorder: const UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.deepPurple
                    )
                ),
                focusedBorder:const UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.deepPurple,
                    width: 2
                  )
                ),
                hintText: hintText,
                labelText: labelText,
                labelStyle: const  TextStyle(
                  color:Colors.grey
                ),
                //si el  valor de prexi icon es diferente de null
                //se lo mando al widget icon sino NULL
                prefixIcon: prefixIcon != null 
                ? Icon(prefixIcon ,color: Colors.deepPurple,)
                : null
              );
  }
}