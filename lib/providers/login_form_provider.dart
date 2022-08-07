import 'package:flutter/material.dart';

class LoginFormProvider extends ChangeNotifier{
   
   GlobalKey<FormState> formKey = new GlobalKey<FormState>();
   
   String email = '';
   String password='';

   bool _isLoading = false;
   bool get isLoading => _isLoading;

   //Cuando se le asigne un nuevo valor a isLoading  va a establecerselo a _isloading
   // y notyfylisteners va a mandar la notificacion de todos los widgets que lo esten escuchando
   set isLoading(bool value){
     _isLoading = value;
     notifyListeners();
   }


  bool isValidform(){



    return formKey.currentState?.validate() ?? false;
  }


}