import 'package:flutter/material.dart';
import 'package:productos_app/widgets/widgets.dart';

import '../ui/input_decorations.dart';

class ProductScreen extends StatelessWidget {
   
  const ProductScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: SingleChildScrollView(      
        child: Column(
        children: [
          Stack(
            children: [
              ProductImage(),
              Positioned(
                top:60,
                left: 20,
                child: IconButton(
                  onPressed: ()=> Navigator.of(context).pop(),
                 icon: Icon(Icons.arrow_back_ios_new,size: 40,color: Colors.white,)),
                ),
                Positioned(
                top:60,
                right: 20,
                child: IconButton(
                  onPressed: (){
                    //todo:camara o galeria
                  },
                 icon: Icon(Icons.camera_alt_outlined,size: 40,color: Colors.white,)),
                ),
            ],
          ),

          _ProductForm(),
          SizedBox(height: 100,)
        ],  
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,      
      floatingActionButton: FloatingActionButton(
        child:Icon(Icons.save_outlined),
        onPressed: (){
          //TODO:Guardar producto
        }),
    );
  }
}

class _ProductForm extends StatelessWidget {
  

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        //Evitar que los inputs queden pegados al borde de la tarjeta
        padding: EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        decoration: _BuildBoxDecoration(),
        child: Form(
          child: Column(children: [
            SizedBox(height: 10,),
            TextFormField(
             decoration: InputDecorations.authInputDecoration(
               hintText: 'Nombre del Producto',
               labelText: 'Nombre:'),
            ),
            SizedBox(height: 30,),
             SizedBox(height: 10,),
            TextFormField(
              keyboardType: TextInputType.number,
             decoration: InputDecorations.authInputDecoration(
               hintText: '\$150',
               labelText: 'Precio:'),
            ),
            SizedBox(height: 30,),
            SwitchListTile.adaptive(
              value: true,
              title: Text('Disponible'),
              activeColor: Colors.indigo,
              onChanged: (value){
                //TODO :pendiente..
              }
               ),
            SizedBox(height: 30,)
          ]),
        ),
      ),
    );
  }

  BoxDecoration _BuildBoxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(bottomRight: Radius.circular(25),bottomLeft: Radius.circular(25)),
      boxShadow: [BoxShadow(
        color: Colors.black.withOpacity(0.05),
        offset: Offset(0,5),
        blurRadius: 5
      )]
    );
  }
}