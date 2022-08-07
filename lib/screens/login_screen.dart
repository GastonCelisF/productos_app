import 'package:flutter/material.dart';
import 'package:productos_app/providers/login_form_provider.dart';
import 'package:provider/provider.dart';

import '../ui/input_decorations.dart';
import 'package:productos_app/widgets/widgets.dart';

class LoginScreen extends StatelessWidget {
   
  const LoginScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: AuthBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [

              SizedBox(height: 180,),


              CardContainer(
                child: Column( 
                  children: [
                    SizedBox(height: 10),
                    Text('Login',style: Theme.of(context).textTheme.headline4,),
                    SizedBox(height: 30,),
                    
                    ChangeNotifierProvider(
                      create: (_) => LoginFormProvider(),
                      child: _LoginForm(),
                      ),
                    
                  ],
                ),
              ),
              SizedBox(height: 50,),
              Text('Crear nueva Cuenta',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
              SizedBox(height: 50,)
            ],
          ),
        )
      ),
    );
  }
}


class _LoginForm extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {
  final loginForm = Provider.of<LoginFormProvider>(context);

    return Container(
      child: Form(
        key: loginForm.formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          children: [
            TextFormField(
              autocorrect: false,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                hintText: 'Jhon.doe@gmail.com',
                labelText: 'Correo Electronico',
                prefixIcon: Icons.alternate_email_rounded,
              ),
              onChanged: (value)=>loginForm.email = value,
              validator: (value){
                String pattern = r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                RegExp regExp  = new RegExp(pattern);
                // Al ser una funcion que pueda recibir nulos y  valores tipos string
                //  hay que crear un ternario y cambiar el valor de bool a string o null
                // entonces.. si hace match regresamos un match osea correcto caso contrario mandamos un string de mensaje de que no es el formato correcto por ej
                return regExp.hasMatch(value ?? '')
                ? null
                : 'El Valor ingresado no luce como un correo';
              },
            ),
            const SizedBox(height: 30,),
            TextFormField(
              autocorrect: false,
              obscureText: true,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecorations.authInputDecoration(
                hintText: '*****',
                labelText: 'Contraseña',
                prefixIcon: Icons.lock_outline,
              ),
              onChanged: (value)=>loginForm.password = value,
               validator: (value){          
                 // si la contraseña es diferente de null y mayor o igual a 6 
                return (value != null && value.length >=6) 
                      ? null //pasa..
                      : 'La contraseña debe ser de 6 caracteres'; //de lo contraio mandamos msj
                
              },
            ),
            const SizedBox(height: 30,),
            MaterialButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              disabledColor: Colors.grey,
              color:Colors.deepPurple,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 80,vertical: 15),
                child: Text(
                  //si loginform isloading entonces espere de lo contraio valor ingresar
                  loginForm.isLoading
                  ? 'Espere...'
                  : 'Ingresar',
                  style:TextStyle(color: Colors.white),
                  ),
                
              ),
              //para desabilitar un boton debemos mander un nulo y se hace meidante un if
              //si esta cargando manda un null sino manda la funcion..
              onPressed: loginForm.isLoading ? null:() async{
                FocusScope.of(context).unfocus();
                if(!loginForm.isValidform()) return;
                loginForm.isLoading=true;
                await Future.delayed(Duration(seconds: 2));
                
                loginForm.isLoading=false;

                Navigator.pushReplacementNamed(context, 'home');
              })
          ],
        ),
        ),
      
    );
  }
}